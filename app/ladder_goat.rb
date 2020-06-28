require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("goat", "../images/goat.png", 128, 128, 32)

    # Placeholders:
    $game.load.image("mountain", "../images/mountain.jpg")
    $game.load.image("clouds2", "../images/clouds2.png")
  end

  def add_platform(x, y)
    platform = $game.add.tile_sprite(x, y, 64*3, 10, "clouds2")
    platform.anchor.set(0.5)
    @platforms.add platform
    platform.body.immovable = true

    # text = $game.add.text(x, y, "#{x},#{$world_size_y-y}", { font: "24px Arial", fill: "#ffffff"})
    # text.anchor.set(0.5)
  end

  def create
    background = $game.add.sprite(0, 0, 'mountain')
    background.height = $size_y
    background.width = $size_x
    background.fixed_to_camera = true

    $world_size_x = 3200
    $world_size_y = 1500

    @cursors = $game.input.keyboard.create_cursor_keys
    @jump_button = $game.input.keyboard.add_key(`Phaser.Keyboard.SPACEBAR`)

    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @goat = $game.add.sprite(100, $world_size_y-100, "goat")
    $game.physics.enable(@goat, Phaser::Physics::ARCADE)
    @goat.anchor.set(0.5)
    @goat.body.collide_world_bounds = true
    @goat.body.gravity.y = 750

    @goat.body.set_size(60, 50, 35, 40)

    @goat.animations.add("left", [4,5,6,7], 1800, true)
    @goat.animations.add("right", [12,13,14,15], 1800, true)
    @goat.frame = 4

    $game.camera.x = @goat.x-$size_x/2
    $game.camera.y = @goat.y-$size_y/2

    @platforms = $game.add.group
    @platforms.enable_body = true

    add_platform 250, $world_size_y-50
    add_platform 250, $world_size_y-10
    add_platform 250, $world_size_y-150
    add_platform 250, $world_size_y-200

    add_platform 400, $world_size_y-200
    add_platform 400, $world_size_y-250
    add_platform 400, $world_size_y-300
    add_platform 400, $world_size_y-350
    add_platform 400, $world_size_y-400
  end

  def update
    if @cursors.right.down?
      @goat.body.velocity.x = 200
      @goat.animations.play("right")
    elsif @cursors.left.down?
      @goat.body.velocity.x = -200
      @goat.animations.play("left")
    else
      @goat.body.velocity.x = 0
      @goat.animations.stop
    end

    # Fine jump control
    # add double jump ?
    @goat.body.gravity.y = 1000
    if @jump_button.down?
      if (@goat.body.blocked.down or @goat.body.touching.down)
        @goat.body.velocity.y = -300
      end

      if @goat.body.velocity.y < 0
        @goat.body.gravity.y = 500
      end
    end

    # Can pass through platforms on way up, not down
    if @goat.body.velocity.y > 0
      $game.physics.arcade.overlap(@goat, @platforms) do |c,s|
        dy = c.y-s.y
        puts "hi", dy
        if dy < 0
          @goat.body.velocity.y = 0
        end
      end
    else
      $game.physics.arcade.collide(@goat, @platforms)
    end
  end

  # This can be used to debug hitboxes
  def render
    $game.debug.body(@goat)
  end
end

$game.state.add(:main, MainState.new, true)
