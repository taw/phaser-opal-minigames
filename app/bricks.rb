require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Brick
  attr_reader :brick_x_size, :brick_y_size
  attr_reader :x, :y, :destroyed
  def initialize(x,y)
    @destroyed = false
    @brick_x_size = $size_x/18
    @brick_y_size = $size_y/30
    @x = x*$size_x/12
    @y = y*$size_y/20
    @brick = $game.add.graphics(@x, @y)
    @brick.line_style(0)
    @brick.begin_fill(0xFF0000)
    @brick.draw_rect(-@brick_x_size/2, -@brick_x_size/2, @brick_x_size, @brick_y_size)
  end

  def destroy
    @brick.destroy
    @destroyed = true
  end
end

class Ball
  attr_accessor :dx, :dy
  def initialize
    @ball = $game.add.graphics(0.5*$size_x, 0.8*$size_y)
    @ball.line_style(0)
    @ball.begin_fill(0x000000)
    @ball.draw_rect(-10,-10,20,20)
    @dx = 300
    @dy = -300
  end

  def update(dt)
    @ball.x += @dx*dt
    @ball.y += @dy*dt
    if @ball.x <= 10 and @dx < 0
      @dx = - @dx
    end
    if @ball.x >= $size_x-10 and @dx > 0
      @dx = - @dx
    end
    if @ball.y <= 10 and @dy < 0
      @dy = - @dy
    end
    if @ball.y >= $size_y-10 and @dy > 0
      @dy = - @dy
    end
  end

  def x
    @ball.x
  end

  def y
    @ball.y
  end
end

class Paddle
  def initialize
    @paddle = $game.add.graphics(0.5*$size_x, $size_y-20)
    @paddle.line_style(0)
    @paddle.begin_fill(0x0000FF)
    @paddle.draw_rect(-50, -10, 100, 20)
  end

  def update(dt, direction)
    @paddle.x += dt * direction * 200
    @paddle.x = $game.math.clamp(@paddle.x, 55, $size_x-55)
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "AAF"
    @paddle = Paddle.new
    @ball = Ball.new
    @bricks = (1..11).map{|x|
      (2..7).map{|y|
        Brick.new(x,y)
      }
    }.flatten
  end

  def handle_brick_colission(brick)
    return if brick.destroyed
    distance_x = (brick.x - @ball.x) / (10 + brick.brick_x_size/2)
    distance_y = (brick.y - @ball.y) / (10 + brick.brick_y_size/2)
    if distance_x.abs <= 1.0 and distance_y.abs <= 1.0
      brick.destroy
      if distance_x.abs < distance_y.abs
        @ball_bounce_x = true
      else
        @ball_bounce_y = true
      end
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @ball.update(dt)

    if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)
      @paddle.update(dt, 1)
    elsif $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
      @paddle.update(dt, -1)
    end
    @ball_bounce_x = false
    @ball_bounce_y = false
    @bricks.each do |brick|
      handle_brick_colission(brick)
    end
    if @ball_bounce_x
      @ball.dx = -@ball.dx
    end
    if @ball_bounce_y
      @ball.dy = -@ball.dy
    end
  end
end
