require_relative "common"

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
    @text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#FBE8D3', align: 'left', font: "Creepster" })
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
  def initialize(x)
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
    @dy = 200
  end

  def update(dt)
    @sprite.y += @dy * dt
    if @sprite.y < 40
      @dy = 200
    end
    if @sprite.y > $world_size_y - 40
      @dy = -200
    end
  end
end

class Spider
  attr_reader :sprite
  def initialize(x)
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
    $game.stage.background_color = "8A8"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    $world_size_x = 3200
    $world_size_y = $size_y
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @player = Player.new
    @bats = []
    @spiders = []
    @candy = []

    (4..30).each do |x|
      case $game.rnd.between(0, 1)
      when 0
        @bats << Bat.new(x * 100)
      when 1
        @candy << Candy.new(x * 100)
      end
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

    # TODO: bats
    # TODO: spiders
    # TODO: bg
    # TODO: music
  end

  def update
    $game.physics.arcade.overlap(@player.sprite, @candy_group) do |_,candy|
      @emitter.burst_at(candy.x, candy.y)
      candy.destroy
      @pop.play
      @score.value += 1
    end

    dt = $game.time.physics_elapsed
    @bats.each do |bat|
      bat.update(dt)
    end
    @spiders.each do |spider|
      spider.update(dt)
    end
    @player.update(dt)
  end
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

    # FIXME: make it work with keyboard as well
    # $game.input.keyboard.onDownCalback = proc{ $game.state.start(:game) }
    $game.input.on(:down) { $game.state.start(:game) }
  end
end

$game.state.add(:game, GameState.new)
$game.state.add(:boot, BootState.new, true)
