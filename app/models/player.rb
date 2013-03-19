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

class Player < ActiveRecord::Base
  class InvalidInitialisation < StandardError; end
  HIT = 1
  MISS = -1

  def auto_play?
    raise "'auto_play?' must be overridden in class of #{self.class.to_s} < Player"
  end

  def name
    raise "'name' must be overridden in class of #{self.class.to_s} < Player"
  end

  def game
    Game.where('player1_id = ? or player2_id = ?', id, id).first
  end

  def takes_a_hit!(x, y)
    update_attributes!(battlefield_casualties: battlefield_casualties.dup.tap { |casualties|
      casualties[get_position(x, y)] = battlefield[get_position(x, y)] == 0 ? MISS : HIT
    })

    {hit: battlefield_casualties[get_position(x, y)] == HIT}.tap { |result|
      result[:ship_id] = battlefield[get_position(x, y)]  if battlefield.zip(battlefield_casualties)
                                                              .select { |ship, hit| ship == battlefield[get_position(x, y)] }
                                                              .all? { |ship, hit| hit == HIT }
      result[:all_sunk] = true                            if battlefield.zip(battlefield_casualties)
                                                              .select { |ship, hit| ship > 0 }
                                                              .all? { |ship, hit| hit == HIT }
    }
  end

  def ready?
    battlefield.present?
  end

protected
  def strikes!(x=nil, y=nil)
    game.strikes_opposing_player(self, x, y).tap { |result|
      update_attributes!(previous_strikes: previous_strikes.dup.tap { |strikes|
        strikes[get_position(x, y)] = result[:hit] ? HIT : MISS
      })
    }
  end

  def sets_up_battlefield!(battlefield=nil)
    if (game.width * game.height) != battlefield.length
      raise InvalidInitialisation.new('Dimension specified must match battlefield.')
    end

    update_attributes!(battlefield: battlefield,
                       battlefield_casualties: Array.new(battlefield.length, 0),
                       previous_strikes: Array.new(battlefield.length, 0))

    game.player_ready(self)
  end

  def get_position(x, y)
    y * game.height + x
  end
end
