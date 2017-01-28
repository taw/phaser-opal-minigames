require_relative "common"

class Cat
  attr_reader :sprite
  def initialize(x, y)
    @sprite = $game.add.sprite(x, y, "cat")
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.body.gravity.y = 1000
    @sprite.body.max_velocity.y = 500
    @sprite.body.collide_world_bounds = true
    @sprite.anchor.set(0.5)
    @sprite.scale.set(-0.2, 0.2)
    # @sprite.animations.add("dead", (0..9).to_a, 15, false)
    # @sprite.animations.add("fall", (10..17).to_a, 15, false)
    # @sprite.animations.add("hurt", (18..27).to_a, 15, false)
    @sprite.animations.add("idle", (28..37).to_a, 15, true)
    @sprite.animations.add("jump", (38..45).to_a, 15, false)
    @sprite.animations.add("run",  (46..53).to_a, 15, true)
    # @sprite.animations.add("slide",(54..63).to_a, 15, false)
    @sprite.animations.add("walk", (64..73).to_a, 15, true)
    @sprite.animations.play("idle")
  end

  def update(dt)
    if jumping?
      # continue jump animation
    elsif moving?
      @sprite.animations.play("run")
    else
      @sprite.animations.play("idle")
    end
  end

  def jumping?
    @sprite.body.velocity.y != 0 or !can_jump?
  end

  def moving?
    @sprite.body.velocity.x != 0 or @sprite.body.velocity.y != 0
  end

  def can_jump?
    @sprite.body.blocked.down or @sprite.body.touching.down
  end

  def jump!
    @sprite.body.velocity.y = -500
    # start once as it does not loop
    @sprite.animations.play("jump")
  end

  def left!
    @sprite.scale.set(-0.2, 0.2)
    @sprite.body.velocity.x = -200
  end

  def right!
    @sprite.scale.set(0.2, 0.2)
    @sprite.body.velocity.x = 200
  end

  def stop!
    @sprite.body.velocity.x = 0
  end
end

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("cat", "../images/characters/cat.png", 556, 504, 74)
  end

  def create
    @world_size_y = 1500
    $game.world.set_bounds(0, 0, 3200, 1500)

    $game.stage.background_color = "008"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @cursors = $game.input.keyboard.create_cursor_keys
    @cat = Cat.new($size_x/2, $size_y/2)
    $game.camera.follow(@cat.sprite)
  end

  def update
    dt = $game.time.physics_elapsed
    if @cursors.left.down?
      @cat.left!
    elsif @cursors.right.down?
      @cat.right!
    else
      @cat.stop!
    end
    if @cursors.up.down? and @cat.can_jump?
      @cat.jump!
    end
    @cat.update(dt)
  end
end

$game.state.add(:main, MainState.new, true)
