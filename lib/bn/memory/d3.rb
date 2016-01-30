require "bn/memory/address"

module BN
  module Memory
    # The container method for Diablo 3 memory classes.
    module D3
      ADDRESSES = Address.new(name: :root)

      ADDRESSES.object_manager(offset: 0x01DCF22C, size: 0xA10)
      ADDRESSES.object_manager.current_frame(offset: 0x038)
      ADDRESSES.object_manager.storage(offset: 0x798, size: 0x1A4)
      ADDRESSES.object_manager.game_difficulty_handicap(offset: 0x004)
      ADDRESSES.object_manager.game_level(offset: 0x030)
      ADDRESSES.object_manager.game_tick(offset: 0x118)
    end
  end
end

require "bn/memory/d3/game"
