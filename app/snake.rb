require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("snake", "../images/snake.png")
  end

  def point_xy(i, snake_phase)
    # snake takes half a circle
    segment_phase = snake_phase - Math::PI * i / 20

    [
      Math.sin(segment_phase) * @radius * (1 + 0.1*Math.sin(segment_phase*5)),
      Math.cos(segment_phase) * @radius * (1 + 0.1*Math.sin(segment_phase*5)),
    ]
  end

  def create
    @radius = [$size_x, $size_y].min * 0.35

    points = (0...20).map{|i| {x:0, y:0} }
    #   {x:i*918/20, y:0}
    # }
    @rope = $game.add.rope($size_x/2, $size_y/2, "snake", nil, points)

    @phase = 0
    @rope.updateAnimation = proc do
      @phase -= 0.05
      (0...20).each do |i|
        (x, y) = point_xy(i, @phase)
        # @rope.points[i].y = Math.sin(i * 0.5 + @count) * 20
        @rope.points[i].x = x
        @rope.points[i].y = y
      end
    end
  end
end

$game.state.add(:main, MainState.new, true)
