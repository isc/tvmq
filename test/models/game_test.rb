require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'is_a_match?' do
    g = Game.new
    assert g.is_a_match?('Lara Fabian', 'Lara Fabian')
    refute g.is_a_match?('Lara Fabian', 'Sylvie Vartan')
    assert g.is_a_match?('Lara Fabian', 'lara fabian')
    assert g.is_a_match?('Lara Fabian', 'larafabian')
    assert g.is_a_match?('Lara Fabian', 'Làra Fábiân')
    assert g.is_a_match?('Lara Fabian', 'fabian lara')
    assert g.is_a_match?('Ms. Jackson', 'ms jackson')
    assert g.is_a_match?('Ma B*nz', 'Ma Benz')
    assert g.is_a_match?('P!nk', 'pink')
    assert g.is_a_match?('Fais-moi une place', 'fait moi une place')
    assert g.is_a_match?("It Wasn't Me (feat. Ricardo Ducent)",
      'it wasnt me')
    assert g.is_a_match?('Bob Marley & The Wailers',
      'bob marley the wailers one love')
    refute g.is_a_match?('Admiral T', 'admiral z')
  end

  test 'evaluate' do
    track = Track.create(data: {artistName: 'Tryö', trackName: 'L\'hymne de nos çampagnes'})
    game = Game.create current_track: track
    result = game.evaluate 'hymne de nos tryo campagnes'
    assert_equal({artist_found: true, track_found: true, points: 3, track_done: true}, result)
    assert game.artist_found
    game.next_track
    refute game.artist_found
  end

  test 'evaluate persist found parts' do
    track = Track.new(data: {artistName: 'A', trackName: 'B'})
    game = Game.new current_track: track
    result = game.evaluate 'A'
    assert_equal(true, result[:artist_found])
    result = game.evaluate 'A'
    assert_equal(false, result[:artist_found])
    result = game.evaluate 'B'
    assert_equal(true, result[:track_found])
    result = game.evaluate 'A'
    assert_equal(false, result[:artist_found])
  end
end
