require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Brick
  def initialize(x,y)
    brick_x_size = $size_x/18
    brick_y_size = $size_y/30
    @brick = $game.add.graphics(x*$size_x/12, y*$size_y/20)
    @brick.line_style(0)
    @brick.begin_fill(0xFF0000)
    @brick.draw_rect(-brick_x_size/2, -brick_x_size/2, brick_x_size, brick_y_size)
  end
end

class Ball
  def initialize
    @ball = $game.add.graphics(0.5*$size_x, 0.5*$size_y)
    @ball.line_style(0)
    @ball.begin_fill(0x000000)
    @ball.draw_rect(-10,-10,20,20)
  end
end

class Paddle
  def initialize
    @paddle = $game.add.graphics(0.5*$size_x, $size_y-20)
    @paddle.line_style(0)
    @paddle.begin_fill(0x0000FF)
    @paddle.draw_rect(-50, -10, 100, 20)
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "AAF"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    @paddle = Paddle.new
    @ball = Ball.new
    @bricks = (1..11).map{|x|
      (2..7).map{|y|
        Brick.new(x,y)
      }
    }.flatten
  end
end
