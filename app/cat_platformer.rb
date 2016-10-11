require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "../images/cat_images/cat17.png")
    $game.load.image("platform", "../images/grass_platform.png")
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
    if @cursors.left.down?
      @player.body.velocity.x = -250
      @player.scale.x = (@player.scale.x.abs)
    end
    if @cursors.right.down?
      @player.body.velocity.x = 250
      @player.scale.x = -(@player.scale.x.abs)
    end
    if @jumpButton.down? and (@player.body.blocked.down or @player.body.touching.down)
      @player.body.velocity.y = -250
    end

    $game.camera.x = @player.x-$size_x/2
  end

  def create
    $game.stage.background_color = "8F8"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.world.set_bounds(0, 0, 3200, $size_y)
    # Wrappers for this are not consistent with the rest of interface
    # thus isDown vs down?
    # This ought to be fixed upstream
    @cursors = $game.input.keyboard.create_cursor_keys
    @jumpButton = $game.input.keyboard.add_key(`Phaser.Keyboard.SPACEBAR`)

    @player = $game.add.sprite($size_x/2, $size_y-100, 'cat')
    @player.anchor.set(0.5)
    @player.height = 64
    @player.width = 64
    $game.physics.enable(@player, Phaser::Physics::ARCADE)

    @player.body.gravity.y = 250
    @player.body.collide_world_bounds = true

    @platforms = $game.add.group()
    @platforms.enable_body = true
    10.times do  |i|
      add_platform 200+i*300, $size_y-100-100*(i%2)
      add_platform 200+i*300, $size_y-300-100*(i%2)
      add_platform 200+i*300, $size_y-500-100*(i%2)
    end
  end
end

$game.state.add(:main, MainState.new, true)
