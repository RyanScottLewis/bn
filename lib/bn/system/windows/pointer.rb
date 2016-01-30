require "ffi"

require "bn/system/windows/kernel32"
require "bn/system/windows/string"

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
        raise Error::System::Windows::LocalFreeMemoryLeak if System::Windows::Kernel32.local_free(ptr.address) != FFI::Pointer::NULL_HANDLE
      end
    end

    # ptr has already had LocalFree called, so nothing to return
    nil
  end
end
