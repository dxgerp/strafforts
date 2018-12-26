module CacheKeys
  BEST_EFFORT_TYPES = "global/best-effort-types/%{distance}"
  RACE_DISTANCES = "global/race-distances/%{distance}"
  FAQS = "global/faqs"
  FAQ_CATEGORIES = "global/faq-categories"

  META = "athletes/%{athlete_id}/meta"

  HEART_RATE_ZONES = "athletes/%{athlete_id}/heart-rate-zones"

  RACES_OVERVIEW = "athletes/%{athlete_id}/races/overview"
  RACES_RECENT = "athletes/%{athlete_id}/races/recent"
  RACES_DISTANCE = "athletes/%{athlete_id}/races/%{race_distance_id}"
end
