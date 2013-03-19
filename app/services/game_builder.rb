class GameBuilder
  def self.build_player_vs_ai!(player_attributes)
    Game.transaction do
      game = Game.create!
      player1 = game.adds_player!(Players::HumanPlayer.new(player_attributes))
      player1.sets_up_battlefield!(RandomBattlefieldGenerator.generate(width: game.width, height: game.height, markers: game.ships))
      player2 = game.adds_player!(Players::AiPlayer.new)
      player2.sets_up_battlefield!
      player1
    end
  end

  def self.build_p45_vs_ai!
    Game.transaction do
      game = Game.create!
      player1 = game.adds_player!(Players::P45Player.new)
      player2 = game.adds_player!(Players::AiPlayer.new)
      player1.sets_up_battlefield!
      player2.sets_up_battlefield!
      player2
    end
  end

  def self.build_p45_vs_player!(player_attributes)
    Game.transaction do
      game = Game.create!
      player1 = game.adds_player!(Players::P45Player.new)
      player2 = game.adds_player!(Players::HumanPlayer.new(player_attributes))
      player1.sets_up_battlefield!
      player2.sets_up_battlefield!(RandomBattlefieldGenerator.generate(width: game.width, height: game.height, markers: game.ships))
      player2
    end
  end
end