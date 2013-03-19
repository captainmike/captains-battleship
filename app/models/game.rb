# == Schema Information
#
# Table name: games
#
#  id           :integer          not null, primary key
#  player1_id   :integer
#  player2_id   :integer
#  winner_id    :integer
#  next_turn_id :integer
#  status       :string(255)      not null
#  height       :integer          not null
#  width        :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Game < ActiveRecord::Base
  class AlreadyRequiredNumOfPlayers < StandardError; end
  class PlayerNotReady < StandardError; end
  class InValidStateForStrike < StandardError; end
  class NotYourTurn < StandardError; end

  belongs_to :player1, class_name: '::Player', foreign_key: 'player1_id'
  belongs_to :player2, class_name: '::Player', foreign_key: 'player2_id'
  belongs_to :winner, class_name: '::Player', foreign_key: 'winner_id'
  belongs_to :next_turn, class_name: '::Player', foreign_key: 'next_turn_id'

  before_validation :set_defaults, :on => :create

  DefaultHeight = 10
  DefaultWidth = 10
  Ships = [
    {id: 1, name: 'Carrier', size: 5},
    {id: 2, name: 'Battleship', size: 4},
    {id: 3, name: 'Destroyer', size: 3},
    {id: 4, name: 'Submarines', size: 2},
    {id: 5, name: 'Submarines', size: 2},
    {id: 6, name: 'Patrol Boats', size: 1},
    {id: 7, name: 'Patrol Boats', size: 1}
  ]

  def adds_player!(player)
    raise AlreadyRequiredNumOfPlayers.new if player1.present? && player2.present?

    if self.player1.blank?
      self.player1 = player
    elsif self.player2.blank?
      self.player2 = player
    end

    self.save! and player
  end

  def player_ready(player)
    raise PlayerNotReady.new unless player.ready?
    return if player1.blank? || player2.blank?

    if status == 'initial' && player1.ready? && player2.ready?
      update_attributes!(status: 'ready_to_start', next_turn: player1)
    end
  end

  def strikes_opposing_player(player, x, y)
    raise NotYourTurn.new unless player == next_turn
    raise InValidStateForStrike.new unless playing?
    opponent_of(player).takes_a_hit!(x, y).tap { |result|
      if result[:all_sunk]
        update_attributes!(status: 'finished', next_turn: nil, winner: player)
      else
        next_turn = opponent_of(player)
        update_attributes!(status: 'in_progress', next_turn: next_turn)
      end
    }
  end

  def ships
    Ships
  end

  def playing?
    %w(in_progress ready_to_start).include?(status)
  end

private
  def set_defaults
    self.status = 'initial'
    self.width ||= DefaultWidth
    self.height ||= DefaultHeight
  end

  def opponent_of(player)
    [player1, player2].detect { |x| x != player }
  end
end
