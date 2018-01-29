class Game < ApplicationRecord
  belongs_to :current_track, class_name: 'Track', required: false

  def in_progress?
    state == 'in_progress'
  end

  def next_track
    current_track = Track.where.not(id: track_ids).order('random()').first
    update! current_track: current_track, track_ids: track_ids.push(current_track.id),
      buzzing_player_id: nil, artist_found: false, track_found: false
    current_track
  end

  def self.current_game
    game = where.not(state: 'ended').first
    if game && game.updated_at < 15.minutes.ago
      Player.delete_all
      game.update! state: 'ended'
      game = nil
    end
    game || create(state: 'lobby')
  end

  def evaluate(value)
    result = { artist_found: false, track_found: false, points: 1 }
    if !artist_found && is_a_match?(current_track.data['artistName'], value)
      result[:artist_found] = true
    end
    if !track_found && is_a_match?(current_track.data['trackName'], value)
      result[:track_found] = true
    end
    result[:points] = 3 if result[:artist_found] && result[:track_found]
    result[:points] = -1 unless result[:artist_found] || result[:track_found]
    update! buzzing_player_id: nil,
      artist_found: (artist_found || result[:artist_found]),
      track_found: (track_found || result[:track_found])
    result[:track_done] = artist_found && track_found
    result
  end

  def is_a_match? good_answer, guess
    good_answer = good_answer.gsub(/[\(\[].*/, '')
    return true if normalize(good_answer) == normalize(guess)
    answer_tokens = tokenize good_answer
    guess_tokens = tokenize guess
    answer_tokens.delete_if do |answer_term|
      guess_tokens.any? do |guess_term|
        if answer_term.size == 1
          answer_term == guess_term
        else
          Levenshtein.distance(answer_term, guess_term) <= 1
        end
      end
    end.empty?
  end

  def normalize value
    I18n.transliterate(value.downcase).gsub(/[^a-z0-9]/, '')
  end

  def tokenize value
    value.split(/[ \-]/).map {|t| normalize(t)}
      .map(&:presence).compact
  end
end
