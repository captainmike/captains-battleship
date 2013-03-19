require 'test_helper'

module P45
  class P45PlayerTest < ActiveSupport::TestCase
    test 'to play' do
      game = Game.create!

      player1, player2 = nil
      assert_difference 'Player.count', 2 do
        player1 = game.adds_player!(Players::P45Player.new)
        player2 = game.adds_player!(Players::AiPlayer.new)
      end

      assert player1.auto_play?
      assert player1.p45_player_id.present?
      assert player1.p45_next_move_x.present?
      assert player1.p45_next_move_y.present?
      assert_equal 'initial', game.reload.status

      player1.sets_up_battlefield!
      player2.sets_up_battlefield!

      assert_equal 'ready_to_start', game.reload.status
      assert_equal player1, game.reload.next_turn
      assert player1.strikes!.has_key?(:hit)

      assert_equal player2, game.reload.next_turn
      assert player2.strikes!.has_key?(:hit)

      assert_equal player1, game.reload.next_turn
      assert player1.strikes!.has_key?(:hit)
    end
  end
end