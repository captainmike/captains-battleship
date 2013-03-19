# == Schema Information
#
# Table name: players
#
#  id                     :integer          not null, primary key
#  type                   :string(255)
#  name                   :string(255)
#  email                  :string(255)
#  battlefield            :integer
#  battlefield_casualties :integer
#  previous_strikes       :integer
#  p45_player_id          :integer
#  p45_next_move_x        :integer
#  p45_next_move_y        :integer
#  created_at             :datetime
#  updated_at             :datetime
#

module Players
  class AiPlayer < ::Player
    attr_writer :strategy

    def name
      'Computer'
    end

    def auto_play?
      true
    end

    def strikes!
      super(*strategy.gets_next_move(width: game.width, height: game.height, previous_strikes: previous_strikes))
    end

    def sets_up_battlefield!
      super(RandomBattlefieldGenerator.generate(width: game.width,
                                                height: game.height,
                                                markers: game.ships))
    end

    def strategy
      @strategy || DumbAiStrategy
    end
  end
end
