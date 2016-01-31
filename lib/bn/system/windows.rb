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
          pid_pointer = FFI::MemoryPointer.new(:dword)

          User32.get_window_thread_process_id(window_handle, pid_pointer)
          pid = pid_pointer.get_int(0)

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

          # permissions = Kernel32::PROCESS_QUERY_INFORMATION | Kernel32::PROCESS_VM_READ
          # permissions = Kernel32::PROCESS_QUERY_LIMITED_INFORMATION
          # permissions = Kernel32::PROCESS_QUERY_INFORMATION | Kernel32::PROCESS_VM_READ
          permissions = Kernel32::PROCESS_QUERY_INFORMATION | Kernel32::PROCESS_VM_READ
          process_handle = Kernel32.open_process(permissions, false, pid)

          if process_handle == 0
            error_message = format_error_code(Kernel32.get_last_error)

            raise Error::System::Windows::OpenProcessFailure, message: error_message
          end

          process_handle
        end

        def format_error_code(code)
          error_string = ""
          flags = Kernel32::FORMAT_MESSAGE_ALLOCATE_BUFFER |
                  Kernel32::FORMAT_MESSAGE_FROM_SYSTEM |
                  Kernel32::FORMAT_MESSAGE_ARGUMENT_ARRAY |
                  Kernel32::FORMAT_MESSAGE_IGNORE_INSERTS |
                  Kernel32::FORMAT_MESSAGE_MAX_WIDTH_MASK

          # this pointer actually points to a :lpwstr (pointer) since we're letting Windows allocate for us
          FFI::MemoryPointer.new(:pointer, 1) do |buffer_ptr|
            length = Kernel32.format_message_w(flags, FFI::Pointer::NULL, code, 0, buffer_ptr, 0, FFI::Pointer::NULL)
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
