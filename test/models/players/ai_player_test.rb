require 'test_helper'

class Players::AiPlayerTest < ActiveSupport::TestCase
  test 'player is ready on initialise' do
    game = Game.create!(width: 6, height: 6)

    player = game.adds_player!(Players::AiPlayer.new)
    refute player.ready?

    player.sets_up_battlefield!
    assert player.ready?
  end
end