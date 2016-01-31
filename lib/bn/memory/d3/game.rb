require "bn/system/windows"
require "bn/memory/address"

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

          address = D3::ADDRESSES.find_child(address) if address.is_a?(String)
          size ||= address.size if address.is_a?(Address)

          address = address.to_i
          size = size.nil? ? 4 : size.to_i

          output_pointer_type = case size
            when 4 then :int
            when 8 then :float
            else;       :pointer
          end

          output_pointer = if output_pointer_type == :pointer # TODO: Better way to do this?
            FFI::MemoryPointer.new(output_pointer_type, size)
          else
            FFI::MemoryPointer.new(output_pointer_type)
          end
          address_pointer = FFI::MemoryPointer.new(:uint, address)

          result = System::Windows::Kernel32.read_process_memory(@process_handle, address_pointer, output_pointer, size, nil)
          raise "Read memory at address '#{address.to_s}' failed." unless result

          case output_pointer_type
            when :int then output_pointer.get_int(0)
            when :float then output_pointer.get_float(0)
            when :pointer then output_pointer.get_string(0)
          end
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
