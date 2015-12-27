module BN
  # The API requestors.
  module API
    # The valid regions for the API.
    # Contains name, host, and valid locales for each region.
    REGIONS = {
      us:  { name: "US",              uri: "https://us.api.battle.net",    locales: %w(en_US es_MX pt_BR) },
      eu:  { name: "Europe",          uri: "https://us.api.battle.net",    locales: %w(en_GB es_ES fr_FR ru_RU de_DE pt_PT it_IT) },
      kr:  { name: "Korea",           uri: "https://kr.api.battle.net",    locales: %w(ko_KR) },
      tw:  { name: "Taiwan",          uri: "https://tw.api.battle.net",    locales: %w(zh_TW) },
      cn:  { name: "China",           uri: "https://api.battlenet.com.cn", locales: %w(zh_CN) },
      sea: { name: "South East Asia", uri: "https://sea.api.battle.net",   locales: %w(en_US) }
    }
  end
end

require "bn/api/d3"
require "bn/api/sc2"
require "bn/api/wow"
