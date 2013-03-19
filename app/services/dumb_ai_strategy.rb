class DumbAiStrategy
  class NoValidPositionFound < StandardError; end

  def self.gets_next_move(width: width, height: height, previous_strikes: previous_strikes)
    index = previous_strikes.find_index { |x| x == 0 }
    raise DumbAiStrategy::NoValidPositionFound.new if index.nil?
    [index % width, index / width]
  end
end