require "bn/memory/address"
# //public const int SnoGroupInitializers = 0x01B71ABC - 4;
#       public const int SnoGroupByCode = 0x01E9B510; // 2.4.0 (was 0x01DCD048) +CE4C8
#       public const int SnoGroups = 0x01E9A148; // 2.4.0 (was 0x01DCD164) +CCFE4
# //public const int SnoGroupSearch = 0x01E2021C;
# //public const int SnoFilesAsync = 0x01E20220;
#       public const int ObjectManager = 0x01E9A234; // 2.4.0 (was 0x01DCF24C) +CAFE8
# //public const int ObjectManagerPristine = 0x01DCF250;
# //public const int MessageDescriptor = 0x01E8386C;
# //public const int MapActId = 0x01BBB348;
#       public const int LocalData = 0x01E9B4D8; // 2.4.0 (was 0x01DD04F0) +CAFE8
#       public const int LevelArea = 0x01E241F8; // 2.4.0 (was 0x01D27778) +FCA80
#       public const int LevelAreaName = 0x01E24228; // 2.4.0 (was 0x01D277A8) +FCA80
#       public const int GameplayPreferences = 0x01C58964; // 2.4.0 (was 0x01BA1F94) +B69D0
# //public const int ContainerManager = 0x01E8456C;
#       public const int BuffManager = 0x01E2DD3C; // 2.4.0 (was 0x01DB4990) +793AC
#       public const int ApplicationLoopCount = 0x01E247D8; // 2.4.0 (was 0x01DCF2C0) +55518
#       public const int AttributeDescriptors = 0x01EEA578; // 2.4.0 (was 0x01B76AC8) +373AB0
#       public const int VideoPreferences = 0x01C58410; // 2.4.0 (was 0x01BA1A50) +B69C0
# //public const int ChatPreferences = 0x01BA2024;
# //public const int SoundPreferences = 0x01BA1AE4;
# //public const int SocialPreferences = 0x01BA1FF4;
#       public const int UIHandlers = 0x01C28B20; // 2.4.0 (was 0x01B684D0) +C0650
# //public const int UIReferences = 0x01BBB8F8;
# //public const int SnoIdToEntityId = 0x00000000;
#       public const int TrickleManager = 0x01E72FA8; // 2.4.0 (was 0x01D8BF88) +E7020
# //public const int PtrSnoFiles = 0x01DD1610;
# }
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


      # 2.4.0.35616

      ADDRESSES.object_manager(offset: 0x01E9A234, size: 0xA10)

      ADDRESSES.object_manager.current_frame(offset: 0x038)

      ADDRESSES.object_manager.storage(offset: 0x798) # Unknown size

      ADDRESSES.object_manager.storage.player_data_manager(offset: 0x12C, size: 0x38 + (0xA438 * 8)) # TODO: Can have arrays FUUUCK
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0(offset: 0x38 + (0xA438 * 0), size: 0xA438)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.hero_name(offset: 0x9180, size: 49)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.hero_class(offset: 0x964C) # TODO: { none: -1, demon_hunter: 0, barbarian: 1, wizard: 2, witch_doctor: 3, monk: 4, crusader: 5 }

      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.level(offset: 0x9650)
      ADDRESSES.object_manager.storage.player_data_manager.player_data_0.alt_level(offset: 0x9654)


      ADDRESSES.object_manager.storage.game_difficulty_handicap(offset: 0x004)
      ADDRESSES.object_manager.storage.game_level(offset: 0x030)
      ADDRESSES.object_manager.storage.game_tick(offset: 0x118)



      # ADDRESSES.object_manager_pristine()
      # ADDRESSES.message_descriptor()
      # ADDRESSES.map_act_id()
      # ADDRESSES.local_data()
      # ADDRESSES.local_area()
      # ADDRESSES.local_area_name()

      ADDRESSES.gameplay_preferences(offset: 0x01C58964, size: 0x54)
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
