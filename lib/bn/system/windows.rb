require "ffi"

# TODO: This is a mess..

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

# FFI Types
# https://github.com/ffi/ffi/wiki/Types

# Windows - Common Data Types
# https://msdn.microsoft.com/en-us/library/cc230309.aspx

# Windows Data Types
# https://msdn.microsoft.com/en-us/library/windows/desktop/aa383751(v=vs.85).aspx

FFI.typedef :uint16, :word
FFI.typedef :uint32, :dword
# uintptr_t is defined in an FFI conf as platform specific, either
# ulong_long on x64 or just ulong on x86
FFI.typedef :uintptr_t, :handle
FFI.typedef :uintptr_t, :hwnd

# buffer_inout is similar to pointer (platform specific), but optimized for buffers
FFI.typedef :buffer_inout, :lpwstr
# buffer_in is similar to pointer (platform specific), but optimized for CONST read only buffers
FFI.typedef :buffer_in, :lpcwstr
FFI.typedef :buffer_in, :lpcolestr

# string is also similar to pointer, but should be used for const char *
# NOTE that this is not wide, useful only for A suffixed functions
FFI.typedef :string, :lpcstr
FFI.typedef :string, :lpctstr

# pointer in FFI is platform specific
# NOTE: for API calls with reserved lpvoid parameters, pass a FFI::Pointer::NULL
FFI.typedef :pointer, :lpcvoid
FFI.typedef :pointer, :lpvoid
FFI.typedef :pointer, :lpword
FFI.typedef :pointer, :lpbyte
FFI.typedef :pointer, :lpdword
FFI.typedef :pointer, :pdword
FFI.typedef :pointer, :phandle
FFI.typedef :pointer, :ulong_ptr
FFI.typedef :pointer, :pbool
FFI.typedef :pointer, :lpunknown

# any time LONG / ULONG is in a win32 API definition DO NOT USE platform specific width
# which is what FFI uses by default
# instead create new aliases for these very special cases
# NOTE: not a good idea to redefine FFI :ulong since other typedefs may rely on it
FFI.typedef :uint32, :win32_ulong
FFI.typedef :int32, :win32_long
# FFI bool can be only 1 byte at times,
# Win32 BOOL is a signed int, and is always 4 bytes, even on x64
# https://blogs.msdn.com/b/oldnewthing/archive/2011/03/28/10146459.aspx
FFI.typedef :int32, :win32_bool

# Same as a LONG, a 32-bit signed integer
FFI.typedef :int32, :hresult

# NOTE: FFI already defines (u)short as a 16-bit (un)signed like this:
# FFI.typedef :uint16, :ushort
# FFI.typedef :int16, :short

# 8 bits per byte
FFI.typedef :uchar, :byte
FFI.typedef :uint16, :wchar

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

require "bn/system/windows/user32"
require "bn/system/windows/kernel32"

require "bn/error/system/windows/invalid_pid"
require "bn/error/system/windows/window_not_found"
require "bn/error/system/windows/open_process_failure"
require "bn/error/system/windows/local_free_memory_leak"

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

class ::FFI::Pointer
  NULL_HANDLE = 0
  NULL_TERMINATOR_WCHAR = 0

  def self.from_string_to_wide_string(str, &block)
    str = BN::System::Windows::String.wide_string(str)
    FFI::MemoryPointer.new(:byte, str.bytesize) do |ptr|
      # uchar here is synonymous with byte
      ptr.put_array_of_uchar(0, str.bytes.to_a)

      yield ptr
    end

    # ptr has already had free called, so nothing to return
    nil
  end

  def read_win32_bool
    # BOOL is always a 32-bit integer in Win32
    # some Win32 APIs return 1 for true, while others are non-0
    read_int32 != 0
  end

  alias_method :read_dword, :read_uint32
  alias_method :read_win32_ulong, :read_uint32
  alias_method :read_qword, :read_uint64

  alias_method :read_hresult, :read_int32

  def read_handle
    type_size == 4 ? read_uint32 : read_uint64
  end

  alias_method :read_wchar, :read_uint16
  alias_method :read_word,  :read_uint16

  def read_wide_string(char_length, dst_encoding = Encoding::UTF_8)
    # char_length is number of wide chars (typically excluding NULLs), *not* bytes
    str = get_bytes(0, char_length * 2).force_encoding('UTF-16LE')
    str.encode(dst_encoding)
  end

  def read_win32_local_pointer(&block)
    ptr = nil
    begin
      ptr = read_pointer
      yield ptr
    ensure
      if ptr && ! ptr.null?
        raise Error::System::Windows::LocalFreeMemoryLeak if BN::System::Windows::Kernel32.local_free(ptr.address) != FFI::Pointer::NULL_HANDLE
      end
    end

    # ptr has already had LocalFree called, so nothing to return
    nil
  end
end

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

module BN
  module System
    # Container module for Windows system DLL FFI interfaces.
    module Windows
      module String
        def wide_string(str)
          # if given a nil string, assume caller wants to pass a nil pointer to win32
          return nil if str.nil?
          # ruby (< 2.1) does not respect multibyte terminators, so it is possible
          # for a string to contain a single trailing null byte, followed by garbage
          # causing buffer overruns.
          #
          # See http://svn.ruby-lang.org/cgi-bin/viewvc.cgi?revision=41920&view=revision
          newstr = str + "\0".encode(str.encoding)
          newstr.encode!('UTF-16LE')
        end
        module_function :wide_string
      end

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
