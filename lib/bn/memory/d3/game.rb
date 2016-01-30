require "bn/system/windows"

module BN
  module Memory
    module D3
      # A running instance of Diablo 3.
      class Game
        WINDOW_TITLE = "Diablo III"

        def initialize(&block)
          @open = false

          open(&block) if block_given?
        end

        def open?
          @open
        end

        def open(&block)
          @process_handle = System::Windows.open_process_by_title(WINDOW_TITLE)

          @open = true

          if block_given?
            begin
              block.arity == 1 ? block.call(self) : instance_eval(&block)
            ensure
              close
            end
          end
        end

        def read(address, size=nil)
          raise "Process not opened." unless @open

          if address.is_a?(String)
            memory_address = MEMORY_ADDRESSES[address]

            size = size || memory_address.size
            address = memory_address.to_i
          end

          address = address.to_i
          size = size.nil? ? 8 : size.to_i

          output_pointer = FFI::MemoryPointer.new(:pointer)
          bytes_read_pointer = FFI::MemoryPointer.new(:pointer)
          address_pointer = FFI::Pointer.new(:pointer, address)

          puts ?! * 80
          p @process_handle

          result = System::Windows::Kernel32.read_process_memory(@process_handle, address_pointer, output_pointer, size, nil)
          raise "Read memory at address 0x'#{address.to_s(16)}' failed." unless result

          p output_pointer.get_int(0)
          p output_pointer
          puts ?! * 80

          output_pointer
        end

        def close
          return unless @open

          System::Windows::Kernel32.close_handle(@process_handle)
          @open = false
        end
      end
    end
  end
end
