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
  class HumanPlayer < ::Player
    validates :name, presence: true
    validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}

    def name
      self[:name]
    end

    def auto_play?
      false
    end

    def strikes!(x, y)
      super(x, y)
    end

    def sets_up_battlefield!(battlefield)
      super(battlefield)
    end
  end
end
