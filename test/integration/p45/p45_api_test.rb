require 'test_helper'

module P45
  class P45ApiTest < ActiveSupport::TestCase
    test 'to register' do
      response = HTTParty.post('http://battle.platform45.com/register', {body: {name: 'Guest', email: 'guest@example.com'}.to_json})
      assert_equal 200, response.code
      assert response.has_key?('id')
      assert response.has_key?('x')
      assert response.has_key?('y')
    end

    test 'to nuke' do
      response = HTTParty.post('http://battle.platform45.com/register', {body: {name: 'Guest', email: 'guest@example.com'}.to_json})
      assert_equal 200, response.code
      response = HTTParty.post('http://battle.platform45.com/nuke', {body: {id: response['id'], x: '1', y: response['1']}.to_json})
      assert_equal 200, response.code
      assert response.has_key?('x')
      assert response.has_key?('y')
      assert response.has_key?('status')
    end
  end
end