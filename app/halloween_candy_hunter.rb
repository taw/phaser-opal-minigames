require_relative "common"

class Snowflake
  def initialize
    @sprite = $game.add.sprite(
      $game.rnd.between(0, $world_size_x),
      $game.rnd.between(0, $world_size_y),
      "circle"
    )
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.height = @sprite.width = rand*10
    @sprite.alpha = rand*0.6
    speed = $game.rnd.between(100, 200)
    @sprite.body.velocity.x = speed
    @sprite.body.velocity.y = speed
  end

  def update(dt)
    if @sprite.y > $world_size_y-5
      @sprite.y = 0
    end
    if @sprite.x > $world_size_x-5
      @sprite.x = 0
    end
  end
end

class PumpkinEmitter
  def initialize
    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("pumpkin")
    @emitter.gravity = -50
    @emitter.maxParticleSpeed.x = 50
    @emitter.minParticleSpeed.x = -50
    @emitter.maxParticleSpeed.y = 50
    @emitter.minParticleSpeed.y = -50
    @emitter.set_alpha(0.2, 0.5, 0)
    @emitter.scale.set(1 / 2)
  end

  def burst_at(x, y)
    @emitter.x = x * 2
    @emitter.y = y * 2
    @emitter.start true, 2000, nil, 40
  end
end

class Score
  def initialize
    @text = $game.add.text(10, 10, "", { fontSize: '32px', fill: '#FBE8D3', align: 'left', font: "Creepster" })
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

class Player
  attr_reader :sprite
  def initialize
    @sprite = $game.add.sprite(100, $size_y/2, "kitty_potter")
    @sprite.anchor.set(0.5, 0.5)
    @sprite.animations.add("fly")
    @sprite.animations.play("fly", 15, true)
    @sprite.scale.x = -0.35
    @sprite.scale.y =  0.35
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.body.collide_world_bounds = true
    @cursors = $game.input.keyboard.create_cursor_keys
    @sprite.body.set_size(180, 150, 50, 60)
  end

  def velocity_x=(v)
    @sprite.body.velocity.x = 200*v
    if v > 0
      @sprite.scale.x = -0.35
    elsif v < 0
      @sprite.scale.x = 0.35
    end
  end

  def velocity_y=(v)
    @sprite.body.velocity.y = 200 * v
  end

  def update(dt)
    if @cursors.up.down?
      self.velocity_y = -1
    elsif @cursors.down.down?
      self.velocity_y =  1
    else
      self.velocity_y =  0
    end

    if @cursors.right.down?
      self.velocity_x =  1
    elsif @cursors.left.down?
      self.velocity_x = -1
    else
      self.velocity_x =  0
    end

    $game.camera.x = @sprite.x-$size_x/2
    $game.camera.y = @sprite.y-$size_y/2
  end
end

class Bat
  attr_reader :sprite
  def initialize(x, speed)
    @sprite = $game.add.sprite(
      x,
      $game.rnd.between(40, $world_size_y-40),
      "bat"
    )
    @sprite.anchor.set(0.5)
    @sprite.scale.x = -0.35
    @sprite.scale.y =  0.35
    @sprite.animations.add("fly")
    @sprite.animations.play("fly", 15, true)
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.body.collide_world_bounds = true
    @speed = speed
    @sprite.body.velocity.y = @speed
    @sprite.body.set_size(100, 60, 40, 50)
  end

  def update(dt)
    if @sprite.y < 40
      @sprite.body.velocity.y = @speed
    end
    if @sprite.y > $world_size_y - 40
      @sprite.body.velocity.y = -@speed
    end
  end
end

class Candy
  attr_reader :sprite
  def initialize(x)
    @sprite = $game.add.sprite(
      x,
      $game.rnd.between(40, $world_size_y-40),
      "candy#{ $game.rnd.between(1, 4) }"
    )
    @sprite.anchor.set(0.5)
    @sprite.scale.x = -0.35
    @sprite.scale.y =  0.35
  end
end

class GameState < Phaser::State
  def create
    background = $game.add.sprite(0, 0, 'darkforest')
    background.height = $size_y
    background.width = $size_x
    background.fixed_to_camera = true

    $game.stage.background_color = "8A8"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    $world_size_x = 100*(200+2)
    $world_size_y = $size_y
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @player = Player.new
    @bats = []
    @candy = []

    (4..200).each do |x|
      case $game.rnd.between(0, 1)
      when 0
        @bats << Bat.new(x * 100, 200 + x)
      when 1
        @candy << Candy.new(x * 100)
      end
    end

    @snowflakes  = []
    @snowflakes = 1000.times.map do
      Snowflake.new
    end

    @candy_group = $game.add.group
    @candy_group.enable_body = true
    @candy.each do |candy|
      @candy_group.add candy.sprite
    end

    @bats_group = $game.add.group
    @bats_group.enable_body = true
    @bats.each do |bat|
      @bats_group.add bat.sprite
    end

    @emitter = PumpkinEmitter.new
    @pop = $game.add.audio("pop")
    @score = Score.new
  end

  def game_over
    $game.state.start(:game_over, true, false, @score.value)
  end

  def update
    dt = $game.time.physics_elapsed
    [@player, *@bats, *@snowflakes].each do |object|
      object.update(dt)
    end

    $game.physics.arcade.overlap(@player.sprite, @candy_group) do |_,candy|
      @emitter.burst_at(candy.x, candy.y)
      candy.destroy
      @pop.play
      @score.value += 1
    end

    $game.physics.arcade.overlap(@player.sprite, @bats_group) do |_,_|
      game_over
    end
  end

  # Debug FPS
  # def render
  #   $game.debug.text($game.time.fps, 500, 100, "white")
  # end

  # This can be used to debug hitboxes
  # def render
  #   $game.debug.body(@player.sprite)
  #   @bats.each do |bat|
  #     $game.debug.body(bat.sprite)
  #   end
  #   @candy.each do |candy|
  #     $game.debug.body(candy.sprite)
  #   end
  # end
end

class BootState < Phaser::State
  def preload
    $game.load.spritesheet("kitty_potter", "../images/kitty_potter.png", 348, 273, 4)
    $game.load.spritesheet("bat", "../images/animated_bat.png", 180, 149, 7)
    $game.load.image("pumpkin", "../images/pumpkin.png")
    $game.load.image("candy1", "../images/candy/candy1.png")
    $game.load.image("candy2", "../images/candy/candy2.png")
    $game.load.image("candy3", "../images/candy/candy3.png")
    $game.load.image("candy4", "../images/candy/candy4.png")
    $game.load.audio("pop", "../audio/pop3.mp3")
    $game.load.image("darkforest", "../images/darkforest.jpg")
    $game.load.image("circle", "../images/circle.png")
  end

  def create
    $game.stage.background_color = "8A8"
    [
      [0.25, 0.15], [0.50, 0.10], [0.75, 0.15],
      [0.25, 0.85], [0.50, 0.90], [0.75, 0.85],
      [0.10, 0.35], [0.90, 0.35],
      [0.10, 0.65], [0.90, 0.65],
    ].each do |xf,yf|
      pumpkin = $game.add.sprite(xf*$size_x, yf*$size_y, "pumpkin")
      pumpkin.anchor.set(0.5)
    end

    text = $game.add.text($size_x/2, $size_y/2, "Collect candy\nAvoid creepy things\nPress any key to start", { fontSize: "64px", fill: "#000", align: "center", font: "Creepster" })
    text.anchor.set(0.5)

    $game.input.keyboard.on_down_callback = proc{ start_game }
    $game.input.on(:down) { start_game }

    $game.time.advanced_timing = true
  end

  def start_game
    $game.input.keyboard.on_down_callback = nil
    $game.state.start(:game)
  end
end

class GameOverState < Phaser::State
  def init(final_score)
    @final_score = final_score
  end

  def create
    $game.stage.background_color = "8A8"
    [
      [0.25, 0.15], [0.50, 0.10], [0.75, 0.15],
      [0.25, 0.85], [0.50, 0.90], [0.75, 0.85],
      [0.10, 0.35], [0.90, 0.35],
      [0.10, 0.65], [0.90, 0.65],
    ].each do |xf,yf|
      pumpkin = $game.add.sprite(xf*$size_x, yf*$size_y, "pumpkin")
      pumpkin.anchor.set(0.5)
    end

    @text = $game.add.text($size_x/2, $size_y/2, "Game over\nYou collected #{@final_score} candy\n", { fontSize: "64px", fill: "#000", align: "center", font: "Creepster" })
    @text.anchor.set(0.5)
    @text.fixed_to_camera = true
    @forced_wait = true
    @time = 0
  end

  def update
    if @forced_wait
      @time += $game.time.physics_elapsed
      if @time > 0.5
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

$game.state.add(:game_over, GameOverState.new)
$game.state.add(:game, GameState.new)
$game.state.add(:boot, BootState.new, true)
