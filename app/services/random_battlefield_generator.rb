class RandomBattlefieldGenerator
  InitialBattlefieldValue = 0

  def self.generate(width: width, height: height, markers: markers)
    @width = width
    @height = height

    data = Array.new(width * height, 0)
    markers.each do |marker|
      get_positions(data, marker[:size]).each do |position|
        data[position] = marker[:id]
      end
    end

    data
  end

  class << self

  private
    def get_positions(data, size)
      coordinate = [rand(@width - (size - 1)), rand(@height - (size - 1))]
      direction = rand(2) == 1 ? [1, 0] : [0, 1]

      result = size.times.map { |x| (coordinate[1] + direction[1] * x) * @height + (coordinate[0] + direction[0] * x) }
      result.all? { |x| data[x] == InitialBattlefieldValue } ? result : get_positions(data, size)
    end
  end
end