require_relative "common"

class MainState < Phaser::State
  def preload
    # All seem to be off by 1 pixel :-/
    $game.load.spritesheet("angel", "../images/characters/angel-blue-2.png", 24+2, 32+2, 12)
  end

  def create
    $game.stage.background_color = "4A6"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @player = $game.add.sprite($size_x/2, $size_y/2, "angel")
    @player.anchor.set(0.5)
    @player.animations.add("up", [0,1,2], 1800, true)
    @player.animations.add("right", [3,4,5], 1800, true)
    @player.animations.add("down", [6,7,8], 1800, true)
    @player.animations.add("left", [9,10,11], 1800, true)
    @player.scale.set(2)
    $game.physics.enable(@player, Phaser::Physics::ARCADE)
    @player.body.collide_world_bounds = true
    @cursors = $game.input.keyboard.create_cursor_keys
  end

  def update
    animation = nil

    if @cursors.up.down?
      animation = "up"
      @player.body.velocity.y = -100
    elsif @cursors.down.down?
      animation = "down"
      @player.body.velocity.y = 100
    else
      @player.body.velocity.y = 0
    end

    if @cursors.left.down?
      animation = "left"
      @player.body.velocity.x = -100
    elsif @cursors.right.down?
      animation = "right"
      @player.body.velocity.x = 100
    else
      @player.body.velocity.x = 0
    end

    if animation
      @player.animations.play(animation, 15, true)
    else
      @player.animations.stop
    end
  end
end

$game.state.add(:main, MainState.new, true)
