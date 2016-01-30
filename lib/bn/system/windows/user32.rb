require "ffi"
require "bn/system/windows/types"

module BN
  module System
    module Windows
      module User32
        extend FFI::Library

        ffi_lib "user32"
        ffi_convention :stdcall

        # DWORD WINAPI GetWindowThreadProcessId(
        #   _In_      HWND    hWnd,
        #   _Out_opt_ LPDWORD lpdwProcessId
        # );
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms633522(v=vs.85).aspx
        #
        # Parameters
        #   hWnd [in]
        #     A handle to the window.
        #   lpdwProcessId [out, optional]
        #     A pointer to a variable that receives the process identifier. If this parameter is not NULL, GetWindowThreadProcessId copies the identifier of the process to the variable; otherwise, it does not.
        #
        # Return value
        #   The return value is the identifier of the thread that created the window.
        attach_function :get_window_thread_process_id, :GetWindowThreadProcessId, [:handle, :pointer], :dword

        # HWND WINAPI FindWindow(LPCTSTR lpClassName, LPCTSTR lpWindowName);
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms633499%28v=vs.110%29.aspx
        #
        # If lpClassName is NULL, it finds any window whose title matches the lpWindowName parameter.
        #
        # If the function succeeds, the return value is a handle to the window that has the specified class name and window name.
        # If the function fails, the return value is NULL. To get extended error information, call GetLastError.
        attach_function :find_window, :FindWindowA, [:lpctstr, :lpctstr], :handle
      end
    end
  end
end
