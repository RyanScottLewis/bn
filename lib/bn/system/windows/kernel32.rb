require "ffi"
require "bn/system/windows/types"

module BN
  module System
    module Windows
      module Kernel32

        # Process Access Rights # TODO Documentation for these constants

        PROCESS_QUERY_LIMITED_INFORMATION = 0x10000000
        PROCESS_TERMINATE                 = 0x00000001
        PROCESS_SET_INFORMATION           = 0x00000200
        PROCESS_QUERY_INFORMATION         = 0x00000400
        PROCESS_ALL_ACCESS                = 0x001F0FFF
        PROCESS_VM_READ                   = 0x00000010

        # FormatMessage Constants

        # The function allocates a buffer large enough to hold the formatted message, and places a pointer to the allocated buffer at the address specified by lpBuffer.
        # The lpBuffer parameter is a pointer to an LPTSTR; you must cast the pointer to an LPTSTR (for example, (LPTSTR)&lpBuffer).
        # The nSize parameter specifies the minimum number of TCHARs to allocate for an output message buffer. The caller should use the LocalFree function to free the buffer when it is no longer needed.
        # If the length of the formatted message exceeds 128K bytes, then FormatMessage will fail and a subsequent call to GetLastError will return ERROR_MORE_DATA.
        # In previous versions of Windows, this value was not available for use when compiling Windows Store apps. As of Windows 10 this value can be used.
        #
        # Windows Server 2003 and Windows XP:
        #   If the length of the formatted message exceeds 128K bytes, then FormatMessage will not automatically fail with an error of ERROR_MORE_DATA.
        # Windows 10:
        #   LocalFree is not in the modern SDK, so it cannot be used to free the result buffer. Instead, use HeapFree (GetProcessHeap(), allocatedMessage). In this case, this is the same as calling LocalFree on memory.
        #
        # Important: LocalAlloc() has different options: LMEM_FIXED, and LMEM_MOVABLE. FormatMessage() uses LMEM_FIXED, so HeapFree can be used. If LMEM_MOVABLE is used, HeapFree cannot be used.
        FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100

        # The Arguments parameter is not a va_list structure, but is a pointer to an array of values that represent the arguments.
        # This flag cannot be used with 64-bit integer values. If you are using a 64-bit integer, you must use the va_list structure.
        FORMAT_MESSAGE_ARGUMENT_ARRAY = 0x00002000

        # The lpSource parameter is a module handle containing the message-table resource(s) to search.
        # If this lpSource handle is NULL, the current process's application image file will be searched.
        # This flag cannot be used with FORMAT_MESSAGE_FROM_STRING.
        # If the module has no message table resource, the function fails with ERROR_RESOURCE_TYPE_NOT_FOUND.
        FORMAT_MESSAGE_FROM_HMODULE = 0x00000800

        # The lpSource parameter is a pointer to a null-terminated string that contains a message definition.
        # The message definition may contain insert sequences, just as the message text in a message table resource may.
        # This flag cannot be used with FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM.
        FORMAT_MESSAGE_FROM_STRING = 0x00000400

        # The function should search the system message-table resource(s) for the requested message.
        # If this flag is specified with FORMAT_MESSAGE_FROM_HMODULE, the function searches the system message table if the message is not found in the module specified by lpSource.
        # This flag cannot be used with FORMAT_MESSAGE_FROM_STRING.
        # If this flag is specified, an application can pass the result of the GetLastError function to retrieve the message text for a system-defined error.
        FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000

        # Insert sequences in the message definition are to be ignored and passed through to the output buffer unchanged.
        # This flag is useful for fetching a message for later formatting. If this flag is set, the Arguments parameter is ignored.
        FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200

        FORMAT_MESSAGE_MAX_WIDTH_MASK = 0x000000FF

        extend FFI::Library

        ffi_lib "kernel32"
        ffi_convention :stdcall

        # DWORD WINAPI GetLastError(void);
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms679360(v=vs.85).aspx
        #
        # Return value
        #   The return value is the calling thread's last-error code.
        #   The Return Value section of the documentation for each function that sets the last-error code notes the conditions under which the function sets the last-error code.
        #   Most functions that set the thread's last-error code set it when they fail. However, some functions also set the last-error code when they succeed.
        #   If the function is not documented to set the last-error code, the value returned by this function is simply the most recent last-error code to have been set; some functions set the last-error code to 0 on success and others do not.
        #
        #   To obtain an error string for system error codes, use the FormatMessage function
        attach_function :get_last_error, :GetLastError, [], :dword

        # DWORD WINAPI FormatMessage(
        #   _In_     DWORD   dwFlags,
        #   _In_opt_ LPCVOID lpSource,
        #   _In_     DWORD   dwMessageId,
        #   _In_     DWORD   dwLanguageId,
        #   _Out_    LPTSTR  lpBuffer,
        #   _In_     DWORD   nSize,
        #   _In_opt_ va_list *Arguments
        # );
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms679351(v=vs.85).aspx
        #
        # Parameters
        #   dwFlags [in]
        #     The formatting options, and how to interpret the lpSource parameter.
        #     The low-order byte of dwFlags specifies how the function handles line breaks in the output buffer.
        #     The low-order byte can also specify the maximum width of a formatted output line.
        #     This parameter can be one or more of the following values.
        #
        #     The low-order byte of dwFlags can specify the maximum width of a formatted output line.
        #     The following are possible values of the low-order byte.
        #
        #     The function ignores regular line breaks in the message definition text.
        #     The function stores hard-coded line breaks in the message definition text into the output buffer.
        #     The function generates no new line breaks.
        #
        #     If the low-order byte is a nonzero value other than FORMAT_MESSAGE_MAX_WIDTH_MASK, it specifies the maximum number of characters in an output line.
        #     The function ignores regular line breaks in the message definition text.
        #     The function never splits a string delimited by white space across a line break.
        #     The function stores hard-coded line breaks in the message definition text into the output buffer.
        #     Hard-coded line breaks are coded with the %n escape sequence.
        #   lpSource [in, optional]
        #     The location of the message definition.
        #     The type of this parameter depends upon the settings in the dwFlags parameter.
        #
        #     If neither of the FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_STRING flags is set in dwFlags, then lpSource is ignored.
        #   dwMessageId [in]
        #     The message identifier for the requested message.
        #     This parameter is ignored if dwFlags includes FORMAT_MESSAGE_FROM_STRING.
        #   dwLanguageId [in]
        #     The language identifier for the requested message. This parameter is ignored if dwFlags includes FORMAT_MESSAGE_FROM_STRING.
        #     If you pass a specific LANGID in this parameter, FormatMessage will return a message for that LANGID only.
        #     If the function cannot find a message for that LANGID, it sets Last-Error to ERROR_RESOURCE_LANG_NOT_FOUND.
        #     If you pass in zero, FormatMessage looks for a message for LANGIDs in the following order:
        #       Language neutral
        #       Thread LANGID, based on the thread's locale value
        #       User default LANGID, based on the user's default locale value
        #       System default LANGID, based on the system default locale value
        #       US English
        #     If FormatMessage does not locate a message for any of the preceding LANGIDs, it returns any language message string that is present.
        #     If that fails, it returns ERROR_RESOURCE_LANG_NOT_FOUND.
        #   lpBuffer [out]
        #     A pointer to a buffer that receives the null-terminated string that specifies the formatted message.
        #     If dwFlags includes FORMAT_MESSAGE_ALLOCATE_BUFFER, the function allocates a buffer using the LocalAlloc function, and places the pointer to the buffer at the address specified in lpBuffer.
        #     This buffer cannot be larger than 64K bytes.
        #   nSize [in]
        #     If the FORMAT_MESSAGE_ALLOCATE_BUFFER flag is not set, this parameter specifies the size of the output buffer, in TCHARs.
        #     If FORMAT_MESSAGE_ALLOCATE_BUFFER is set, this parameter specifies the minimum number of TCHARs to allocate for an output buffer.
        #     The output buffer cannot be larger than 64K bytes.
        #   Arguments [in, optional]
        #     An array of values that are used as insert values in the formatted message.
        #     A %1 in the format string indicates the first value in the Arguments array; a %2 indicates the second argument; and so on.
        #     The interpretation of each value depends on the formatting information associated with the insert in the message definition.
        #     The default is to treat each value as a pointer to a null-terminated string.
        #     By default, the Arguments parameter is of type va_list*, which is a language- and implementation-specific data type for describing a variable number of arguments.
        #     The state of the va_list argument is undefined upon return from the function. To use the va_list again, destroy the variable argument list pointer using va_end and reinitialize it with va_start.
        #     If you do not have a pointer of type va_list*, then specify the FORMAT_MESSAGE_ARGUMENT_ARRAY flag and pass a pointer to an array of DWORD_PTR values; those values are input to the message formatted as the insert values.
        #     Each insert must have a corresponding element in the array.
        # Return value
        #   If the function succeeds, the return value is the number of TCHARs stored in the output buffer, excluding the terminating null character.
        #   If the function fails, the return value is zero. To get extended error information, call GetLastError.
        attach_function :format_message_w, :FormatMessageW, [:dword, :lpcvoid, :dword, :dword, :pointer, :dword, :pointer], :dword


        # HLOCAL WINAPI LocalFree(
        #   _In_  HLOCAL hMem
        # );
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/aa366730(v=vs.85).aspx\
        attach_function :local_free, :LocalFree, [:handle], :handle

        # HANDLE WINAPI OpenProcess(DWORD dwDesiredAccess, BOOL  bInheritHandle, DWORD dwProcessId)
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms684320(v=vs.85).aspx
        #
        # Parameters
        #   dwDesiredAccess [in]
        #     The access to the process object. This access right is checked against the security descriptor for the process. This parameter can be one or more of the process access rights.
        #     If the caller has enabled the SeDebugPrivilege privilege, the requested access is granted regardless of the contents of the security descriptor.
        #   bInheritHandle [in]
        #     If this value is TRUE, processes created by this process will inherit the handle. Otherwise, the processes do not inherit this handle.
        #   dwProcessId [in]
        #     The identifier of the local process to be opened.
        #     If the specified process is the System Process (0x00000000), the function fails and the last error code is ERROR_INVALID_PARAMETER. If the specified process is the Idle process or one of the CSRSS processes, this function fails and the last error code is ERROR_ACCESS_DENIED because their access restrictions prevent user-level code from opening them.
        #     If you are using GetCurrentProcessId as an argument to this function, consider using GetCurrentProcess instead of OpenProcess, for improved performance.
        #
        # Return value
        #   If the function succeeds, the return value is an open handle to the specified process.
        #   If the function fails, the return value is NULL. To get extended error information, call GetLastError.
        attach_function :open_process, :OpenProcess, [:dword, :bool, :dword], :handle

        # BOOL WINAPI CloseHandle(
        #   _In_ HANDLE hObject
        # );
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211(v=vs.85).aspx
        #
        # Parameters
        #   hObject [in]
        #     A valid handle to an open object.
        #
        # Return value
        #   If the function succeeds, the return value is nonzero.
        #   If the function fails, the return value is zero. To get extended error information, call GetLastError.
        #   If the application is running under a debugger, the function will throw an exception if it receives either a handle value that is not valid or a pseudo-handle value.
        #   This can happen if you close a handle twice, or if you call CloseHandle on a handle returned by the FindFirstFile function instead of calling the FindClose function.
        attach_function :close_handle, :CloseHandle, [:handle], :bool

        # BOOL WINAPI ReadProcessMemory(
        #   _In_  HANDLE  hProcess,
        #   _In_  LPCVOID lpBaseAddress,
        #   _Out_ LPVOID  lpBuffer,
        #   _In_  SIZE_T  nSize,
        #   _Out_ SIZE_T  *lpNumberOfBytesRead
        # );
        #
        # https://msdn.microsoft.com/en-us/library/windows/desktop/ms680553(v=vs.85).aspx
        #
        # Parameters
        #   hProcess [in]
        #     A handle to the process with memory that is being read. The handle must have PROCESS_VM_READ access to the process.
        #   lpBaseAddress [in]
        #     A pointer to the base address in the specified process from which to read. Before any data transfer occurs, the system verifies that all data in the base address and memory of the specified size is accessible for read access, and if it is not accessible the function fails.
        #   lpBuffer [out]
        #     A pointer to a buffer that receives the contents from the address space of the specified process.
        #   nSize [in]
        #     The number of bytes to be read from the specified process.
        #   lpNumberOfBytesRead [out]
        #     A pointer to a variable that receives the number of bytes transferred into the specified buffer. If lpNumberOfBytesRead is NULL, the parameter is ignored.
        #
        # Return value
        #   If the function succeeds, the return value is nonzero.
        #
        #   If the function fails, the return value is 0 (zero). To get extended error information, call GetLastError.
        #   The function fails if the requested read operation crosses into an area of the process that is inaccessible.
        attach_function :read_process_memory, :ReadProcessMemory, [:handle, :lpcvoid, :lpvoid, :size_t, :pointer], :bool
      end
    end
  end
end
