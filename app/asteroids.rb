require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class SpaceShip
  attr_reader :x, :y
  def initialize
    @x = $size_x / 2
    @y = $size_y / 2
    @angle = 0
    @dx = 0
    @dy = 0
    @graphics = $game.add.graphics(@x, @y)
    @graphics.begin_fill(0x00FF00)
    @graphics.draw_polygon([
      0,   -20,
      15,   10,
      15,   20,
      -15,  20,
      -15,  10,
    ])
  end

  def ensure_bounds
    @dx = -@dx if @x < 20 and @dx < 0
    @dx = -@dx if @x > $size_x-20 and @dx > 0
    @dy = -@dy if @y < 20 and @dy < 0
    @dy = -@dy if @y > $size_y-20 and @dy > 0
  end

  def update(dt)
    @x += @dx * dt
    @y += @dy * dt
    @graphics.x = @x
    @graphics.y = @y
    @graphics.angle = @angle
    ensure_bounds
  end

  def dir_x
    Math.sin($game.math.deg_to_rad(@angle))
  end

  def dir_y
    -Math.cos($game.math.deg_to_rad(@angle))
  end

  def limit_speed
    dl = (@dx*@dx + @dy*@dy) ** 0.5
    max_speed = 250.0
    if dl > max_speed
      @dx *= (max_speed/dl)
      @dy *= (max_speed/dl)
    end
  end

  def speed_up(dir, dt)
    speed_gain_per_second = 100.0
    @dx += dir_x * dt * speed_gain_per_second * dir
    @dy += dir_y * dt * speed_gain_per_second * dir
    limit_speed
  end

  def turn(dir, dt)
    degrees_per_second = 400.0
    @angle += dir * dt * degrees_per_second
  end
end

class Asteroid
  attr_reader :x, :y
  def initialize(x,y)
    @x  = x
    @y  = y
    angle = $game.rnd.between(0,360)
    speed = $game.rnd.between(50, 200)
    @dx = Math.cos($game.math.deg_to_rad(angle)) * speed
    @dy = Math.sin($game.math.deg_to_rad(angle)) * speed
    @graphics = $game.add.graphics(@x, @y)
    @graphics.begin_fill(0xFF0000)
    @graphics.draw_circle(0, 0, 20)
  end

  def update(dt)
    @x += @dx * dt
    @y += @dy * dt
    @graphics.x = @x
    @graphics.y = @y
    ensure_bounds
  end

  def ensure_bounds
    @dx = -@dx if @x < 20 and @dx < 0
    @dx = -@dx if @x > $size_x-20 and @dx > 0
    @dy = -@dy if @y < 20 and @dy < 0
    @dy = -@dy if @y > $size_y-20 and @dy > 0
  end
end

class MainState < Phaser::State
  def create
    @score = 0.0
    @score_text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#000', align: "center" })
    @active = true
    $game.stage.background_color = "448"
    @space_ship = SpaceShip.new
    @asteroids = 10.times.map do
      while true
        x = $game.rnd.between(100, $size_x-100)
        y = $game.rnd.between(100, $size_y-100)
        # Make sure it's not too close to the spaceship
        break if (x-$size_x/2).abs + (y-$size_y/2).abs > 600
      end
      Asteroid.new(x, y)
    end
  end

  def update
    return unless @active

    dt = $game.time.physics_elapsed
    @space_ship.speed_up(+1.0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.UP`)
    @space_ship.speed_up(-1.0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.DOWN`)
    @space_ship.turn(-1.0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
    @space_ship.turn(+1.0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)

    @score += dt
    @score_text.text = "You survived %.3fs" % [@score]

    @space_ship.update(dt)
    @asteroids.each do |a|
      a.update(dt)
      if collision?(@space_ship, a)
        @active = false
      end
    end
  end

  def collision?(a, b)
    dx = a.x - b.x
    dy = a.y - b.y
    Math.sqrt((dx*dx) + (dy*dy)) < 25
  end
end
