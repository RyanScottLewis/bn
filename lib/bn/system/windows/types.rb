require "ffi"

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
