class Game < ApplicationRecord
  belongs_to :current_track, class_name: 'Track', required: false

  def in_progress?
    state == 'in_progress'
  end

  def next_track
    update! current_track: Track.order('random()').first, buzzing_player_id: nil
    current_track
  end

  def evaluate(value)
    result = { artist_found: false, track_found: false, points: 0 }
    if is_a_match? current_track.data['artistName'], value
      result[:artist_found] = true
      result[:points] += 1
    end
    if is_a_match? current_track.data['trackName'], value
      result[:track_found] = true
      result[:points] += 1
    end
    result[:points] = 3 if result[:artist_found] && result[:track_found]
    result[:points] = -1 unless result[:artist_found] || result[:track_found]
    update! buzzing_player_id: nil
    result
  end

  def is_a_match? good_answer, guess
    good_answer.downcase.gsub(' ', '') == guess.downcase.gsub(' ', '')
  end
end
