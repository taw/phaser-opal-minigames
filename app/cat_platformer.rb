require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/cat_images/cat17.png")
    $game.load.image("platform", "/images/grass_platform.png")
  end

  def add_platform(x,y)
    platform = @platforms.create(x, y, 'platform')
    platform.height = 40
    platform.width = 200
    platform.anchor.set(0.5)
    platform.body.immovable = true
  end

  def update
    $game.physics.arcade.collide(@player, @platforms)
    @player.body.velocity.x = 0
    if @cursors.left.isDown
      @player.body.velocity.x = -150
    end
    if @cursors.right.isDown
      @player.body.velocity.x = 150
    end
    # @player.body.on_floor? works with world floor, but not with platforms
    if @jumpButton.down?
      @player.body.velocity.y = -250
    end
  end

  def create
    $game.stage.background_color = "8F8"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    # Wrappers for this are not consistent with the rest of interface
    # thus isDown vs down?
    # This ought to be fixed upstream
    @cursors = $game.input.keyboard.create_cursor_keys()
    @jumpButton = $game.input.keyboard.add_key(`Phaser.Keyboard.SPACEBAR`)

    @player = $game.add.sprite($size_x/2, $size_y-100, 'cat')
    @player.anchor.set(0.5)
    @player.height = 64
    @player.width = 64
    $game.physics.enable(@player, Phaser::Physics::ARCADE)

    @player.body.gravity.y = 250
    @player.body.bounce.y = 0.5
    @player.body.collide_world_bounds = true

    @platforms = $game.add.group()
    @platforms.enable_body = true
    add_platform 200, $size_y-100
    add_platform 200, $size_y-300
    add_platform 200, $size_y-500
    add_platform 500, $size_y-200
    add_platform 500, $size_y-400
    add_platform 500, $size_y-600
    add_platform 800, $size_y-100
    add_platform 800, $size_y-300
    add_platform 800, $size_y-500
  end
end
