class GamesController < ApplicationController
  def new
  end

  def create_p45_vs_ai
    @player = GameBuilder.build_p45_vs_ai!
    redirect_to show_game_url(id: @player.game, player_id: @player.to_param)
  end

  def create_player_vs_ai
    @player = GameBuilder.build_player_vs_ai!(player_params)
    redirect_to show_game_url(id: @player.game, player_id: @player.to_param)
  end

  def create_p45_vs_player
    @player = GameBuilder.build_p45_vs_player!(player_params)
    redirect_to show_game_url(id: @player.game, player_id: @player.to_param)
  end

  def show
    @player = Player.find(params[:player_id])
    @game = @player.game

    respond_to do |format|
      format.html
      format.js {
        if @game.playing? && @game.next_turn.auto_play?
          @game.next_turn.strikes!
          @game.reload
        end
      }
    end
  end

  def strike
    @player = Player.find(params[:player_id])
    @game = @player.game
    @player.strikes!(coordinate_params[:x].to_i, coordinate_params[:y].to_i)
    @game.reload

    render 'show.js.erb'
  end

private
  def coordinate_params
    params[:coordinate].permit(:x, :y)
  end

  def player_params
    params[:player].permit(:email, :name)
  end
end