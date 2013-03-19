require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'game between human player and human player' do
    game = Game.create!(width: 2, height: 2)
    assert_equal 2, game.width
    assert_equal 2, game.height

    player1, player2 = nil
    assert_difference 'Player.count', 2 do
      player1 = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
      player2 = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
    end

    player1.reload; player2.reload
    assert_equal 'initial', game.status

    player1.sets_up_battlefield!([0,2,
                                  1,2])

    assert_equal 'initial', game.reload.status
    player2.sets_up_battlefield!([2,0,
                                  2,1])

    assert_equal 'ready_to_start', game.reload.status

    assert_equal player1, game.next_turn
    assert_equal({hit: true}, player1.strikes!(0,0))

    assert_equal 'in_progress', game.reload.status

    assert_equal player2, game.reload.next_turn
    assert_raise Game::NotYourTurn do
      player1.strikes!(0,0)
    end
    assert_equal({hit: false}, player2.strikes!(0,0))

    assert_equal player1, game.reload.next_turn
    assert_equal({hit: true, ship_id: 2}, player1.strikes!(0,1))

    assert_equal player2, game.reload.next_turn
    assert_equal({hit: true, ship_id: 1}, player2.strikes!(0,1))

    assert_equal player1, game.reload.next_turn
    assert_equal({hit: true, ship_id: 1, all_sunk: true}, player1.strikes!(1,1))

    assert_equal player1, game.reload.winner
    assert_equal 'finished', game.reload.status
  end

  test 'game between human player and AI player' do
    game = Game.create!(width: 3, height: 3)
    game.stubs(:ships).returns([
      {id: 1, name: 'Adventurer 201', size: 2},
      {id: 2, name: 'Loner 7', size: 1}
    ])
    assert_equal 3, game.width
    assert_equal 3, game.height

    player1 = game.adds_player!(Players::HumanPlayer.new(name: 'Guest', email: 'guest@example.com'))
    player2 = game.adds_player!(Players::AiPlayer.new)

    assert_equal 'initial', game.status

    player1.sets_up_battlefield!(
      [0,0,0,
       0,1,1,
       0,2,0])

    RandomBattlefieldGenerator.stubs(:generate).returns([0,0,0,
                                                         1,0,0,
                                                         1,0,2])
    player2.sets_up_battlefield!

    assert_equal 'ready_to_start', game.reload.status
    assert_equal player1, game.next_turn
    assert_equal({hit: true}, player1.strikes!(0, 1))

    assert player2.strikes!.has_key?(:hit)

    assert_equal player1, game.reload.next_turn
    assert_equal({hit: true, ship_id: 1}, player1.strikes!(0, 2))

    assert player2.strikes!.has_key?(:hit)

    assert_equal player1, game.reload.next_turn
    assert_equal({hit: true, ship_id: 2, all_sunk: true}, player1.strikes!(2, 2))

    assert_equal player1, game.reload.winner
    assert_equal 'finished', game.status
  end

  #test 'game between P45 player and AI player' do
  #  flunk 'work in progress'
  #
  #  game = Game.new
  #  assert_equal 10, game.width
  #  assert_equal 10, game.height
  #
  #  player1 = Players::P45Player.new(game)
  #  player2 = Players::AiPlayer.new(game, DumbAiStrategy.new, RandomBattlefieldGenerator.new)
  #
  #  assert_equal :finished, game.status
  #end

private
  # having problem with mocha, possibly Ruby 2 related.
  def dummy_generator(result)
    Object.new.tap { |o| o.define_singleton_method(:generate) { |*args| result } }
  end
end
