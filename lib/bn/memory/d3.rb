require "bn/memory/address"

module BN
  module Memory
    # The container method for Diablo 3 memory classes.
    module D3
      ADDRESSES = Address.new(name: :root)

      # NOTE: See Enigma.D3.Eng ine.Addr

      # ADDRESSES.sno_group_initializers()
      # ADDRESSES.sno_group_by_code()
      # ADDRESSES.sno_group_s()
      # ADDRESSES.sno_group_search()
      # ADDRESSES.sno_files_async()



      ADDRESSES.object_manager(offset: 0x01DCF22C, size: 0xA10)

      ADDRESSES.object_manager.current_frame(offset: 0x038)

      ADDRESSES.object_manager.storage(offset: 0x798, size: 0x1A4)

      ADDRESSES.object_manager.storage.player_data_manager(offset: 0x12C, size: 0x38 + (0xA438 * 8)) # TODO: Can have arrays FUUUCK
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0(offset: 0x38 + (0xA438 * 0), size: 0xA438)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.hero_name(offset: 0x9180, size: 49)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.hero_class(offset: 0x964C)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.level(offset: 0x9650)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.alt_level(offset: 0x9654)


      ADDRESSES.object_manager.game_difficulty_handicap(offset: 0x004)
      ADDRESSES.object_manager.game_level(offset: 0x030)
      ADDRESSES.object_manager.game_tick(offset: 0x118)



      # ADDRESSES.object_manager_pristine()
      # ADDRESSES.message_descriptor()
      # ADDRESSES.map_act_id()
      # ADDRESSES.local_data()
      # ADDRESSES.local_area()
      # ADDRESSES.local_area_name()

      ADDRESSES.gameplay_preferences(offset: 0x01BA1F74, size: 0x54)
      ADDRESSES.gameplay_preferences.items_on_ground(offset: 0x00)
      ADDRESSES.gameplay_preferences.item_tags_as_icons(offset: 0x04)
      ADDRESSES.gameplay_preferences.show_item_tooltip_on_drop(offset: 0x08)
      # ..
      ADDRESSES.gameplay_preferences.show_clock(offset: 0x40) # default: 1, min: 0, max: 1

      # ADDRESSES.container_manager()
      # ADDRESSES.buff_manager()
      # ADDRESSES.application_loop_count()
      # ADDRESSES.attribute_descriptors()
      # ADDRESSES.video_preferences()
      # ADDRESSES.chat_preferences()
      # ADDRESSES.sound_preferences()
      # ADDRESSES.social_preferences()
      # ADDRESSES.ui_handlers()
      # ADDRESSES.ui_references()
      # ADDRESSES.sno_id_to_entity_id()
      # ADDRESSES.trickle_manager()
      # ADDRESSES.ptr_sno_files()
    end
  end
end

require "bn/memory/d3/game"
