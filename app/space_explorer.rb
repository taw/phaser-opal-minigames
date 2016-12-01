require_relative "common"

class Score
  def initialize
    @text = $game.add.text(10, 10, "", { fontSize: "32px", fill: "#FBE8D3", align: "left", font: "Audiowide"})
    @text.fixed_to_camera = true
    @value = value
    self.value = 0
  end

  attr_reader :value
  def value=(v)
    @value = v
    @text.text = "Score: #{@value}"
  end
end

class Star
  def initialize(group)
    @sprite = group.create(
      $game.rnd.between(0, 5_000),
      $game.rnd.between(0, 5_000),
      "star"
    )
    @sprite.anchor.set(0.5)
    @sprite.body.immovable = true
  end
end

class Alien
  attr_accessor :target
  attr_reader :sprite
  def initialize(group)
    @home_x = $game.rnd.between(0, 5_000)
    @home_y = $game.rnd.between(0, 5_000)
    @sprite = group.create(
      @home_x,
      @home_y,
      "ufo"
    )
    @sprite.anchor.set(0.5)
    @sprite.body.collide_world_bounds = true
    @sprite.body.set_size(48, 48, 8, 8)
  end

  # Go towards target if it's close
  # Otherwise go toward home
  # (there's surely easier way to do this that this block of math)
  def update(dt)
    target_x, target_y = @home_x, @home_y
    if target
      distance_to_target = ((target.x - @sprite.x)**2 + (target.y - @sprite.y)**2)**0.5
      if distance_to_target < 400
        target_x, target_y = target.x, target.y
      end
    end
    dx = (target_x - @sprite.x)
    dy = (target_y - @sprite.y)
    dz = (dx ** 2 + dy ** 2) ** 0.5
    if dz > 0 and dz > 10
      dx = 200*dx/dz
      dy = 200*dy/dz
    else
      # Slow down to avoid oscilations
      dx = 10*dx/dz
      dx = 10*dy/dz
    end
    @sprite.body.velocity.x = dx
    @sprite.body.velocity.y = dy
  end
end

class Donut
  def initialize(group)
    @home_x = $game.rnd.between(0, 5_000)
    @home_y = $game.rnd.between(0, 5_000)
    @sprite = group.create(
      @home_x,
      @home_y,
      "doughnut"
    )
    @sprite.anchor.set(0.5)
    @sprite.body.collide_world_bounds = true
    @phase = 0
  end

  def update(dt)
    @phase += 1 * dt
    @sprite.x = @home_x + Math.sin(@phase) * 40
    @sprite.y = @home_y + Math.cos(@phase) * 40
  end
end

class SpaceShip
  attr_reader :sprite
  def initialize
    @sprite = $game.add.sprite(2500, 2500, "rocket")
    @sprite.anchor.set(0.5)
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.body.collide_world_bounds = true
    @sprite.body.set_size(48, 48, 8, 8)
    @angle = 0
    @speed = 0
  end

  def x
    @sprite.x
  end

  def y
    @sprite.y
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
    @sprite.angle = @angle
    @sprite.body.velocity.x =  Math.sin($game.math.deg_to_rad(@angle)) * @speed
    @sprite.body.velocity.y = -Math.cos($game.math.deg_to_rad(@angle)) * @speed
  end
end

class GameOverState < Phaser::State
  def init(game_won, final_score)
    @game_won = game_won
    @final_score = final_score
  end

  def game_over_text
    if @game_won
      "You won!\nScore: #{@final_score}\n"
    else
      "Game over\nScore: #{@final_score}\n"
    end
  end

  def create
    $game.stage.background_color = "003"
    @text = $game.add.text($size_x/2, $size_y/2, game_over_text, { fontSize: "64px", fill: "#FFF", align: "center", font: "Audiowide" })
    @text.anchor.set(0.5)
    @text.fixed_to_camera = true
    @forced_wait = true
    @time = 0
  end

  def update
    if @forced_wait
      @time += $game.time.physics_elapsed
      if @time > 1
        @forced_wait = false
        @text.text += "Press any key to start again"
        $game.input.keyboard.on_down_callback = proc{ start_game }
        $game.input.on(:down) { start_game }
      end
    end
  end

  def start_game
    $game.input.keyboard.on_down_callback = nil
    $game.state.start(:game)
  end
end

class GameState < Phaser::State
  def preload
    $game.load.image("star", "../images/star.png")
    $game.load.image("rocket", "../images/rocket.png")
    $game.load.image("doughnut", "../images/doughnut.png")
    $game.load.image("ufo", "../images/ufo.png")
    $game.load.audio("pop", "../audio/pop3.mp3")
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
    @score = Score.new
    @pop = $game.add.audio("pop")
  end

  def game_over(game_won)
    $game.state.start(:game_over, true, false, game_won, @score.value)
  end

  def update
    $game.physics.arcade.collide(@spaceship.sprite, @stars_group)
    $game.physics.arcade.collide(@aliens_group, @stars_group)
    $game.physics.arcade.collide(@aliens_group, @aliens_group)
    $game.physics.arcade.overlap(@spaceship.sprite, @donuts_group) do |s, g|
      g.destroy
      @pop.play
      @score.value += 1
      if @score.value == @donuts.size
        game_over(true)
      end
    end
    $game.physics.arcade.overlap(@spaceship.sprite, @aliens_group) do |s, g|
      game_over(false)
    end

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

$game.state.add(:game_over, GameOverState.new, true)
$game.state.add(:game, GameState.new, true)
