require 'test_helper'

class Players::HumanPlayerTest < ActiveSupport::TestCase
  setup do
    game = Game.create!(width: 3, height: 3)
    @player = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
    @player.sets_up_battlefield!([1,0,0,
                                  1,0,2,
                                  1,0,0])
  end

  test 'miss' do
    assert_equal({hit: false}, @player.reload.takes_a_hit!(2, 0))
    assert_equal({hit: false}, @player.reload.takes_a_hit!(2, 2))
  end

  test 'takes a hit when boat is of size 1' do
    assert_equal({hit: true, ship_id: 2}, @player.reload.takes_a_hit!(2, 1))
  end

  test 'takes a hit when boat is of size 3' do
    assert_equal({hit: true}, @player.reload.takes_a_hit!(0, 0))
    assert_equal({hit: true}, @player.reload.takes_a_hit!(0, 1))
    assert_equal({hit: true, ship_id: 1}, @player.reload.takes_a_hit!(0, 2))
  end

  test 'all boats are hit' do
    assert_equal({hit: true}, @player.reload.takes_a_hit!(0, 0))
    assert_equal({hit: true}, @player.reload.takes_a_hit!(0, 1))
    assert_equal({hit: true, ship_id: 2}, @player.reload.takes_a_hit!(2, 1))
    assert_equal({hit: true, ship_id: 1,  all_sunk: true}, @player.reload.takes_a_hit!(0, 2))
  end

  test 'battlefield raises exception on incorrect size' do
    assert_raise Player::InvalidInitialisation do
      game = Game.create!(width: 3, height: 2)
      player = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
      player.sets_up_battlefield!([1,0,0,
                                   1,0,2,
                                   1,0,0])
    end

    assert_raise Player::InvalidInitialisation do
      game = Game.create!(width: 3, height: 3)
      player = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
      player.sets_up_battlefield!([1,0,
                                   1,0])
    end
  end
end