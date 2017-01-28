require_relative "common"

class Cat
  def initialize(x, y)
    @sprite = $game.add.sprite(x, y, "cat")
    $game.physics.enable(@sprite, Phaser::Physics::ARCADE)
    @sprite.anchor.set(0.5)
    @sprite.scale.set(-0.2, 0.2)
    # @sprite.animations.add("dead", (0..9).to_a, 15, false)
    # @sprite.animations.add("fall", (10..17).to_a, 15, false)
    # @sprite.animations.add("hurt", (18..27).to_a, 15, false)
    @sprite.animations.add("idle", (28..37).to_a, 15, true)
    @sprite.animations.add("jump", (38..45).to_a, 15, true)
    @sprite.animations.add("run",  (46..53).to_a, 15, true)
    # @sprite.animations.add("slide",(54..63).to_a, 15, false)
    @sprite.animations.add("walk", (64..73).to_a, 15, true)
  end

  def update(dt)
  end

  def left!
    @sprite.scale.set(-0.2, 0.2)
    @sprite.body.velocity.x = -200
    @sprite.animations.play("walk")
  end

  def right!
    @sprite.scale.set(0.2, 0.2)
    @sprite.body.velocity.x = 200
    @sprite.animations.play("walk")
  end

  def stop!
    @sprite.body.velocity.x = 0
    @sprite.animations.play("idle")
  end
end

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("cat", "../images/characters/cat.png", 556, 504, 74)
  end

  def create
    $game.stage.background_color = "008"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @cursors = $game.input.keyboard.create_cursor_keys
    @cat = Cat.new($size_x/2, $size_y/2)
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
    # if @cursors.up.down? and (@player.body.blocked.down or @player.body.touching.down)
    #   @player.body.velocity.y = -500
    # end
    @cat.update(dt)
  end
end

$game.state.add(:main, MainState.new, true)
