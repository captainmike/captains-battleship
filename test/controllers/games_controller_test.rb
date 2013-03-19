require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get show' do
    player = GameBuilder.build_player_vs_ai!(name: 'Guest', email: 'Guest@example.com')
    get :show, id: player.game.to_param, player_id: player.to_param
    assert_response :success
  end

  test 'should create player vs ai game' do
    assert_difference 'Game.count' do
      assert_difference 'Player.count', 2 do
        post :create_player_vs_ai, player: {name: 'Guest', email: 'Guest@example.com'}
        assert assigns(:player)
        assert_equal 'ready_to_start', assigns(:player).game.reload.status
      end
    end
  end

  test 'should create p45 vs ai game' do
    assert_difference 'Game.count' do
      assert_difference 'Player.count', 2 do
        post :create_p45_vs_ai
        assert assigns(:player)
        assert_equal 'ready_to_start', assigns(:player).game.reload.status
      end
    end
  end

  test 'should create p45 vs player game' do
    assert_difference 'Game.count' do
      assert_difference 'Player.count', 2 do
        post :create_p45_vs_player, player: {name: 'Guest', email: 'Guest@example.com'}
        assert assigns(:player)
        assert_equal 'ready_to_start', assigns(:player).game.reload.status
      end
    end
  end

  test 'should strike' do
    assert_difference 'Game.count' do
      assert_difference 'Player.count', 2 do
        player = GameBuilder.build_player_vs_ai!(name: 'Guest', email: 'Guest@example.com')
        post :strike, id: player.game.to_param, player_id: player.to_param, coordinate: {x: '1', y: '2'}, :format => 'js'
        assert_response :success
      end
    end
  end
end