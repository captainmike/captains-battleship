require 'test_helper'

class DumbAiStrategyTest < ActiveSupport::TestCase
  test 'strategy' do
    assert_equal [0, 0], DumbAiStrategy.gets_next_move(width: 3,
                                                       height: 2,
                                                       previous_strikes: [0,0,0,
                                                                          0,0,0])

    assert_equal [0, 1], DumbAiStrategy.gets_next_move(width: 3,
                                                       height: 2,
                                                       previous_strikes: [1,-1,1,
                                                                          0,0,0])

    assert_equal [2, 1], DumbAiStrategy.gets_next_move(width: 3,
                                                       height: 2,
                                                       previous_strikes: [1,-1,-1,
                                                                          1,1,0])
  end
end