require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Ball
  def initialize(x,y)
    @x = x
    @y = y
    @dx = 0
    @dy = 0
    ensure_bounds
    random_direction
    @graphics = $game.add.graphics(@x, @y)
    @graphics.line_style(0)
    @graphics.begin_fill(Math.rand(0x1_00_00_00))
    @graphics.draw_circle(0, 0, 10)
    @graphics.end_fill
  end

  def random_direction
    angle = $game.math.deg_to_rad($game.rnd.between(0, 360))
    speed = $game.rnd.between(200, 600)
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed
  end

  def ensure_bounds
    new_x = $game.math.clamp(@x, 10, $size_x-10)
    new_y = $game.math.clamp(@y, 10, $size_y-10)
    if [@x,@y] != [new_x,new_y]
      @dx = -@dx if new_x != @x
      @dy = -@dy if new_y != @y
      @x, @y = new_x, new_y
      # Make sure objects lose some energy on bounce so they eventually stop
      @dx *= 0.8
      @dy *= 0.8
    end
  end

  def update(dt)
    @dy += 20.0*dt # gravity
    @x  += @dx*dt
    @y  += @dy*dt
    ensure_bounds
    @graphics.x = @x
    @graphics.y = @y
  end
end

class MainState < Phaser::State
  def create
    @balls = []
    $game.stage.background_color = "88F"
    $game.input.on("down") do |pointer, event|
      @balls << Ball.new(`pointer.x`, `pointer.y`)
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @balls.each do |ball|
      ball.update(dt)
    end
  end
end
