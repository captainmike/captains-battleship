require 'test_helper'

class RandomBattlefieldGeneratorTest < ActiveSupport::TestCase
  test 'battlefield is randomised and contains all the ships' do
    100.times do
      battlefield = RandomBattlefieldGenerator.generate(width: 8, height: 8, markers: [
        {:id => 1, :name => 'Marker 1', :size => 3},
        {:id => 2, :name => 'Marker 2', :size => 5},
        {:id => 3, :name => 'Marker 3', :size => 1}
      ])

      assert_equal 3, battlefield.count { |x| x == 1 }
      assert_equal 5, battlefield.count { |x| x == 2 }
      assert_equal 1, battlefield.count { |x| x == 3 }
    end
  end
end