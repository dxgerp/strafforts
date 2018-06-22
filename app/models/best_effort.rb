class BestEffort < ApplicationRecord
  validates :activity_id, :athlete_id, :best_effort_type_id, presence: true
  validates :distance, :moving_time, :elapsed_time, presence: true

  belongs_to :activity, foreign_key: 'activity_id'
  belongs_to :athlete, foreign_key: 'athlete_id'
  belongs_to :best_effort_type, foreign_key: 'best_effort_type_id'

  def self.find_top_by_athlete_id_and_best_effort_type_id(athlete_id, best_effort_type_id, limit)
    results = where(athlete_id: athlete_id, best_effort_type_id: best_effort_type_id)
              .order('elapsed_time')
              .limit(limit)
    results.empty? ? [] : results
  end

  def self.find_top_one_of_each_year(athlete_id, best_effort_type_id)
    items = where(athlete_id: athlete_id, best_effort_type_id: best_effort_type_id)

    return [] if items.empty?

    results = {}
    items.each do |item|
      start_date = item.start_date_local.blank? ? item.start_date : item.start_date_local
      year = start_date.year
      if !results[year] || (results[year] && item.elapsed_time < results[year].elapsed_time)
        results[year] = item
      end
    end
    results.values
  end

  def self.find_all_pbs_by_athlete_id(athlete_id)
    results = where(athlete_id: athlete_id, pr_rank: 1)
    results.empty? ? [] : results
  end

  def self.find_all_pbs_by_athlete_id_and_best_effort_type_id(athlete_id, best_effort_type_id)
    results = where(athlete_id: athlete_id, best_effort_type_id: best_effort_type_id, pr_rank: 1)
    results.empty? ? [] : results
  end
end
