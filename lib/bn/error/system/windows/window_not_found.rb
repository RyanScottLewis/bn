require "bn/error/system/windows"

module BN
  class Error < StandardError
    class System < Error
      class Windows < System
        # RAised when a window could not be found.
        class WindowNotFound < Windows
          # @method title
          # Get the title of the window.
          #
          # @return [String]

          # @method title=
          # Set the title of the window.
          #
          # @param [#to_s] value
          # @return [String]
          attribute(:title) { |value| value.to_s }

          def to_s
            "Window '#{@title}' not found."
          end
        end
      end
    end
  end
end
