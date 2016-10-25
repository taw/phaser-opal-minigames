require_relative "common"

class Player
  def initialize
    @sprite = $game.add.sprite(100, $size_y/2, "kitty_potter")
    @sprite.anchor.set(0.5, 0.5)
    @sprite.animations.add("fly")
    @sprite.animations.play("fly", 15, true)
    @sprite.scale.x = -0.35
    @sprite.scale.y =  0.35
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.body.collide_world_bounds = true
  end

  def velocity_x=(v)
    @sprite.body.velocity.x = v
    if v > 0
      @sprite.scale.x = -0.35
    elsif v < 0
      @sprite.scale.x = 0.35
    end
  end

  def velocity_y=(v)
    @sprite.body.velocity.y = v
  end

  def x
    @sprite.x
  end

  def y
    @sprite.y
  end
end

class Bat
  def initialize(x)
    @sprite = $game.add.sprite(
      x,
      $game.rnd.between(40, $world_size_y-40),
      "bat"
    )
    @sprite.anchor.set(0.5)
    @sprite.scale.x = -0.25
    @sprite.scale.y =  0.25
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
  def initialize
  end
end

class GameState < Phaser::State
  def create
    $game.stage.background_color = "AAF"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    @cursors = $game.input.keyboard.create_cursor_keys

    $world_size_x = 3200
    $world_size_y = $size_y
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @player = Player.new
    @bats = []
    @spiders = []
    @candy = []

    (4..30).each do |x|
      @bats << Bat.new(x * 100)
    end

    # TODO: bats
    # TODO: spiders
    # TODO: pumpkins
    # TODO: candy
    # TODO: player
    # TODO: bg
  end

  def update
    dt = $game.time.physics_elapsed
    @bats.each do |bat|
      bat.update(dt)
    end
    @spiders.each do |spider|
      spider.update(dt)
    end

    if @cursors.up.down?
      @player.velocity_y = -150
    elsif @cursors.down.down?
      @player.velocity_y =  150
    else
      @player.velocity_y = 0
    end

    if @cursors.right.down?
      @player.velocity_x =  150
    elsif @cursors.left.down?
      @player.velocity_x = -150
    else
      @player.velocity_x = 0
    end

    $game.camera.x = @player.x-$size_x/2
    $game.camera.y = @player.y-$size_y/2
  end
end

class BootState < Phaser::State
  def preload
    $game.load.spritesheet("kitty_potter", "../images/kitty_potter.png", 348, 273, 4)
    $game.load.spritesheet("bat", "../images/animated_bat.png", 180, 149, 7)
    $game.load.image("pumpkin", "../images/pumpkin.png")
  end

  def create
    $game.stage.background_color = "AAF"
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
