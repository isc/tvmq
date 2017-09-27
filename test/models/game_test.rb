require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "is_a_match?" do
    g = Game.new
    assert g.is_a_match?('Lara Fabian', 'Lara Fabian')
    refute g.is_a_match?('Lara Fabian', 'Sylvie Vartan')
    assert g.is_a_match?('Lara Fabian', 'lara fabian')
    assert g.is_a_match?('Lara Fabian', 'larafabian')
  end
end
