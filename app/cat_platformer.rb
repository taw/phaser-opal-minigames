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
      @player.body.velocity.y = -500
    end
  end

  def create
    @world_size_y = 1500

    $game.stage.background_color = "8F8"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.world.set_bounds(0, 0, 3200, 1500)
    @cursors = $game.input.keyboard.create_cursor_keys
    @jumpButton = $game.input.keyboard.add_key(`Phaser.Keyboard.SPACEBAR`)

    @player = $game.add.sprite($size_x/2, @world_size_y-100, 'cat')
    @player.anchor.set(0.5)
    @player.height = 64
    @player.width = 64
    $game.physics.enable(@player, Phaser::Physics::ARCADE)

    @player.body.gravity.y = 1000
    @player.body.max_velocity.y = 500
    @player.body.collide_world_bounds = true

    @platforms = $game.add.group()
    @platforms.enable_body = true
    10.times do  |i|
      (0..5).to_a.sample(4).each do |j|
        add_platform 200+i*300, @world_size_y-100-200*j-(i%2)*100
      end
    end
    $game.camera.follow(@player)
    $game.camera.deadzone = Phaser::Rectangle.new($size_x*0.25, $size_y*0.25, $size_x*0.5, $size_y*0.5)
  end
end

$game.state.add(:main, MainState.new, true)
