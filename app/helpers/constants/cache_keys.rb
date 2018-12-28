module CacheKeys
  BEST_EFFORT_TYPES = 'global/best-effort-types/%{distance}'.freeze
  RACE_DISTANCES = 'global/race-distances/%{distance}'.freeze
  FAQS = 'global/faqs'.freeze
  FAQ_CATEGORIES = 'global/faq-categories'.freeze

  META = 'athletes/%{athlete_id}/meta'.freeze

  HEART_RATE_ZONES = 'athletes/%{athlete_id}/heart-rate-zones'.freeze

  RACES_OVERVIEW = 'athletes/%{athlete_id}/races/overview'.freeze
  RACES_RECENT = 'athletes/%{athlete_id}/races/recent'.freeze
  RACES_DISTANCE = 'athletes/%{athlete_id}/races/%{race_distance_id}'.freeze
end
