require "ffi"

require "bn/system/windows/types"
require "bn/system/windows/pointer"
require "bn/system/windows/user32"
require "bn/system/windows/kernel32"

require "bn/error/system/windows/invalid_pid"
require "bn/error/system/windows/window_not_found"
require "bn/error/system/windows/open_process_failure"
require "bn/error/system/windows/local_free_memory_leak"

module BN
  module System
    # Container module for Windows system DLL FFI interfaces.
    module Windows
      class << self
        def find_window_by_title(title)
          window_handle = User32.find_window(nil, title)
          raise Error::System::Windows::WindowNotFound, title: title if window_handle == 0

          window_handle
        end

        def window_pid(window_handle)
          pid = User32.get_window_thread_process_id(window_handle, nil).to_i
          raise Error::System::Windows::InvalidPID if pid == 0

          pid
        end

        # Open a process, getting it's process ID from finding the window handle by it's title.
        #
        # @param [#to_s] title
        # @raise
        # @return [FFI::Pointer]
        def open_process_by_title(title)
          window_handle = find_window_by_title(title)
          pid = window_pid(window_handle)

          # permissions = System::Windows::Kernel32::PROCESS_QUERY_INFORMATION | System::Windows::Kernel32::PROCESS_VM_READ
          permissions = Kernel32::PROCESS_QUERY_LIMITED_INFORMATION
          process_handle = Kernel32.open_process(permissions, false, pid)

          puts ?% * 80
          p window_handle
          p pid
          p process_handle
          puts ?% * 80

          # raise OpenProcessFailure if process_handle.null?
          if process_handle == 0
            last_error_code = Kernel32.get_last_error
            error_message = format_error_code(last_error_code)

            puts ?^ * 80
            puts error_message
            puts ?^ * 80

            raise Error::System::Windows::OpenProcessFailure
          end

          process_handle
        end

        def format_error_code(code)
          # specifying 0 will look for LANGID in the following order
          # 1.Language neutral
          # 2.Thread LANGID, based on the thread's locale value
          # 3.User default LANGID, based on the user's default locale value
          # 4.System default LANGID, based on the system default locale value
          # 5.US English
          dwLanguageId = 0
          flags = Kernel32::FORMAT_MESSAGE_ALLOCATE_BUFFER |
                  Kernel32::FORMAT_MESSAGE_FROM_SYSTEM |
                  Kernel32::FORMAT_MESSAGE_ARGUMENT_ARRAY |
                  Kernel32::FORMAT_MESSAGE_IGNORE_INSERTS |
                  Kernel32::FORMAT_MESSAGE_MAX_WIDTH_MASK
          error_string = ""

          # this pointer actually points to a :lpwstr (pointer) since we're letting Windows allocate for us
          FFI::MemoryPointer.new(:pointer, 1) do |buffer_ptr|
            length = Kernel32.format_message_w(flags, FFI::Pointer::NULL, code, dwLanguageId, buffer_ptr, 0, FFI::Pointer::NULL)
            raise Error::System::Windows::InvalidErrorCode, code: code if length == 0

            # returns an FFI::Pointer with autorelease set to false, which is what we want
            buffer_ptr.read_win32_local_pointer do |wide_string_ptr|
              error_string = wide_string_ptr.null? ? "" : wide_string_ptr.read_wide_string(length)
            end
          end

          error_string
        end
      end
    end
  end
end
