require_relative "common"

class Star
  def initialize
    @graphics = $game.add.sprite(
      $game.rnd.between(0, 5_000),
      $game.rnd.between(0, 5_000),
      "star"
    )
    @graphics.anchor.set(0.5)
  end
end

class SpaceShip
  def initialize
    @graphics = $game.add.sprite(2500, 2500, "rocket")
    @graphics.anchor.set(0.5)
    $game.physics.enable(@graphics, Phaser::Physics::ARCADE)
    @graphics.body.collide_world_bounds = true
    @angle = 0
    @speed = 0
  end

  def x
    @graphics.x
  end

  def y
    @graphics.y
  end

  def turn(direction, dt)
    @angle += direction * dt * 360
  end

  def speed_up(dt)
    @speed += dt * 250
  end

  def slow_down(dt)
    @speed -= dt * 250
  end

  def update(dt)
    @speed -= dt * 125 # 4s to autostop anyway
    @speed = $game.math.clamp(@speed, 0, 500)
    @graphics.angle = @angle
    @graphics.body.velocity.x =  Math.sin($game.math.deg_to_rad(@angle)) * @speed
    @graphics.body.velocity.y = -Math.cos($game.math.deg_to_rad(@angle)) * @speed
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("star", "../images/star.png")
    $game.load.image("rocket", "../images/rocket.png")
    $game.load.image("doughnut", "../images/doughnut.png")
  end

  def create
    $game.stage.background_color = "003"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @stars = 200.times.map do
      Star.new
    end
    $game.world.set_bounds(0, 0, 5_000, 5_000)
    @spaceship = SpaceShip.new
    @cursors = $game.input.keyboard.create_cursor_keys
  end

  def update
    dt = $game.time.physics_elapsed
    $game.camera.x = @spaceship.x - $size_x/2
    $game.camera.y = @spaceship.y - $size_y/2

    if @cursors.up.down?
      @spaceship.speed_up(dt)
    end
    if @cursors.down.down?
      @spaceship.slow_down(dt)
    end
    if @cursors.left.down?
      @spaceship.turn(-1.0, dt)
    end
    if @cursors.right.down?
      @spaceship.turn(+1.0, dt)
    end

    @spaceship.update(dt)
  end
end

$game.state.add(:main, MainState.new, true)
