require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("snake", "../images/snake.png")
  end

  def create
    points = (0...20).map{|i|
      {x:i*918/20, y:0}
    }
    @rope = $game.add.rope($size_x/4, $size_y/2, "snake", nil, points)

    @count = 0
    @rope.updateAnimation = proc do
      @count += 0.1
      (0...20).each do |i|
        @rope.points[i].y = Math.sin(i * 0.5 + @count) * 20
      end
    end
  end
end

$game.state.add(:main, MainState.new, true)
