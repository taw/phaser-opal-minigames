require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("angel", "../images/characters/angel-blue-2.png", 24+2, 32+2, 12)
    # 128 x 30
    $game.load.spritesheet("angband", "../images/angband.png", 32+2, 32+2)
  end

  def create_map
    40.times do |x|
      40.times do |y|
        if rand > 0.5
          # Plains
          frame = 23*128 + [9,10,11].sample
        else
          # Trees
          frame = 23*128 + 54 + (0..8).to_a.sample
        end
        tile = $game.add.sprite(x*64, y*64, "angband")
        tile.scale.set(2)
        tile.frame = frame
      end
    end
  end

  def create_player
    @player = $game.add.sprite($size_x/2, $size_y/2, "angel")
    @player.anchor.set(0.5)
    @player.animations.add("up", [0,1,2], 1800, true)
    @player.animations.add("right", [3,4,5], 1800, true)
    @player.animations.add("down", [6,7,8], 1800, true)
    @player.animations.add("left", [9,10,11], 1800, true)
    @player.scale.set(2)
    $game.physics.enable(@player, Phaser::Physics::ARCADE)
    @player.body.collide_world_bounds = true
  end

  def create
    $game.physics.start_system(Phaser::Physics::ARCADE)
    create_map
    create_player
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
