require_relative "common"

class StarEmitter
  def initialize
    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("star3")
    @emitter.gravity = -50
    @emitter.maxParticleSpeed.x = 50
    @emitter.minParticleSpeed.x = -50
    @emitter.maxParticleSpeed.y = 50
    @emitter.minParticleSpeed.y = -50
    @emitter.set_alpha(0.2, 0.5, 0)
  end

  def burst_at(x, y)
    @emitter.x = x
    @emitter.y = y
    @emitter.start true, 2000, nil, 40
  end
end

class Brick
  attr_reader :brick_x_size, :brick_y_size
  attr_reader :x, :y, :destroyed
  def initialize(x,y)
    colors_by_row = {
      2 => 0xFF0000,
      3 => 0xFF0080,
      4 => 0xFF00FF,
      5 => 0xFF80FF,
      6 => 0x8080FF,
      7 => 0x80FFFF,
    }

    @destroyed = false
    @brick_x_size = $size_x/18
    @brick_y_size = $size_y/30
    @x = x*$size_x/12
    @y = y*$size_y/20
    @brick = $game.add.graphics(@x, @y)
    @brick.begin_fill(colors_by_row[y])
    @brick.draw_rect(-@brick_x_size/2, -@brick_y_size/2, @brick_x_size, @brick_y_size)
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
    @paddle.begin_fill(0x0000FF)
    @paddle.draw_rect(-50, -10, 100, 20)
  end

  def update(dt, direction)
    @paddle.x += dt * direction * 500
    @paddle.x = $game.math.clamp(@paddle.x, 55, $size_x-55)
  end

  def x
    @paddle.x
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("star3", "../images/star3.png")
  end

  def create
    @active = true
    $game.stage.background_color = "AAF"
    @paddle = Paddle.new
    @ball = Ball.new
    @bricks = (1..11).map{|x|
      (2..7).map{|y|
        Brick.new(x,y)
      }
    }.flatten
    @emitter = StarEmitter.new
  end

  def handle_brick_colission(brick)
    return if brick.destroyed
    distance_x = (brick.x - @ball.x) / (10 + brick.brick_x_size/2)
    distance_y = (brick.y - @ball.y) / (10 + brick.brick_y_size/2)
    if distance_x.abs <= 1.0 and distance_y.abs <= 1.0
      brick.destroy
      @emitter.burst_at(@ball.x, @ball.y)
      if distance_x.abs < distance_y.abs
        @ball_bounce_y = true
      else
        @ball_bounce_x = true
      end
    end
  end

  def update
    return unless @active
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
    @ball.dx = -@ball.dx if @ball_bounce_x
    @ball.dy = -@ball.dy if @ball_bounce_y

    paddle_distance = (@paddle.x - @ball.x).abs
    bottom_distance = $size_y - @ball.y

    if @ball.dy > 0
      if bottom_distance <= 30 and paddle_distance <= 60
        @ball.dy = -@ball.dy
      elsif bottom_distance <= 10 and paddle_distance >= 60
        $game.stage.background_color = "FAA"
        @active = false
      end
    end

    if @bricks.all?(&:destroyed)
      $game.stage.background_color = "FFF"
      @active = false
    end
  end
end

$game.state.add(:main, MainState.new, true)
