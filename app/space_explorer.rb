require_relative "common"

class Star
  def initialize(group)
    @graphics = group.create(
      $game.rnd.between(0, 5_000),
      $game.rnd.between(0, 5_000),
      "star"
    )
    @graphics.anchor.set(0.5)
    @graphics.body.immovable = true
  end
end

class Alien
  attr_accessor :target
  def initialize(group)
    @home_x = $game.rnd.between(0, 5_000)
    @home_y = $game.rnd.between(0, 5_000)
    @graphics = group.create(
      @home_x,
      @home_y,
      "ufo"
    )
    @graphics.anchor.set(0.5)
    @graphics.body.collide_world_bounds = true
  end

  # Go towards target if it's close
  # Otherwise go toward home
  # (there's surely easier way to do this that this block of math)
  def update(dt)
    target_x, target_y = @home_x, @home_y
    if target
      distance_to_target = ((target.x - @graphics.x)**2 + (target.y - @graphics.y)**2)**0.5
      if distance_to_target < 400
        target_x, target_y = target.x, target.y
      end
    end
    dx = (target_x - @graphics.x)
    dy = (target_y - @graphics.y)
    dz = (dx ** 2 + dy ** 2) ** 0.5
    if dz > 0 and dz > 10
      dx = 200*dx/dz
      dy = 200*dy/dz
    else
      # Slow down to avoid oscilations
      dx = 10*dx/dz
      dx = 10*dy/dz
    end
    @graphics.body.velocity.x = dx
    @graphics.body.velocity.y = dy
  end
end

class Donut
  def initialize(group)
    @home_x = $game.rnd.between(0, 5_000)
    @home_y = $game.rnd.between(0, 5_000)
    @graphics = group.create(
      @home_x,
      @home_y,
      "doughnut"
    )
    @graphics.anchor.set(0.5)
    @graphics.body.collide_world_bounds = true
    @phase = 0
  end

  def update(dt)
    @phase += 1 * dt
    @graphics.x = @home_x + Math.sin(@phase) * 40
    @graphics.y = @home_y + Math.cos(@phase) * 40
  end
end

class SpaceShip
  attr_reader :graphics
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
    @speed += dt * 500
  end

  def slow_down(dt)
    @speed -= dt * 300
  end

  def update(dt)
    @speed -= dt * 100 # 4s to autostop
    @speed = $game.math.clamp(@speed, 0, 400)
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
    $game.load.image("ufo", "../images/ufo.png")
  end

  def create
    $game.stage.background_color = "003"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @stars_group = $game.add.group
    @stars_group.enable_body = true
    @stars = 200.times.map do
      Star.new(@stars_group)
    end
    @donuts_group = $game.add.group
    @donuts_group.enable_body = true
    @donuts = 50.times.map do
      Donut.new(@donuts_group)
    end
    @aliens_group = $game.add.group
    @aliens_group.enable_body = true
    @aliens = 20.times.map do
      Alien.new(@aliens_group)
    end
    $game.world.set_bounds(0, 0, 5_000, 5_000)
    @spaceship = SpaceShip.new
    @aliens.each do |alien|
      alien.target = @spaceship
    end
    @cursors = $game.input.keyboard.create_cursor_keys
  end

  def update
    $game.physics.arcade.collide(@spaceship.graphics, @stars_group)
    $game.physics.arcade.collide(@aliens_group, @stars_group)
    $game.physics.arcade.collide(@donuts_group, @stars_group)

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
    @aliens.each do |alien|
      alien.update(dt)
    end
    @donuts.each do |donut|
      donut.update(dt)
    end
  end
end

$game.state.add(:main, MainState.new, true)
