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
  class P45Player < ::Player
    include HTTParty
    base_uri 'http://battle.platform45.com'

    class ServerConnectionError < StandardError; end
    before_create :registers_game_on_server

    def name
      'Platform 45'
    end

    def auto_play?
      true
    end

    def strikes!
      super(p45_next_move_x, p45_next_move_y)
    end

    def takes_a_hit!(x, y)
      response = post('/nuke', {id: p45_player_id, x: x, y: y})
      raise ServerConnectionError.new unless response.code == 200

      update_attributes!(p45_next_move_x: response['x'], p45_next_move_y: response['y'])
      {hit: response['status'] == 'hit', name: response['sunk'], all_sunk: response['game_status'] == 'lost'}
    end

    def sets_up_battlefield!
      super(Array.new(game.width * game.height, 0))
    end

    def ready?
      true
    end

  private
    def registers_game_on_server
      response = post('/register', {name: 'Guest', email: 'guest@example.com'})
      raise ServerConnectionError.new unless response.code == 200

      self.p45_player_id = response['id']
      self.p45_next_move_x = response['x']
      self.p45_next_move_y = response['y']
    end

    def post(path, data)
      self.class.post(path, {body: data.to_json})
    end
  end
end
