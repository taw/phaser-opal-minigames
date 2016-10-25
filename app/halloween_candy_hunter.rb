require_relative "common"

class GameState < Phaser::State
  def create
    $game.stage.background_color = "AAF"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    @chaser = $game.add.sprite($size_x/2, $size_y/2, "kitty_potter")
    @chaser.anchor.set(0.5, 0.5)
    @chaser.animations.add("fly")
    @chaser.animations.play("fly", 15, true)
    @chaser.width *= 0.5
    @chaser.height *= 0.5
    $game.physics.enable(@chaser, Phaser::Physics::ARCADE)
    @chaser.body.collide_world_bounds = true


    @bat = $game.add.sprite($size_x/4, $size_y/4, "bat")
    @bat.anchor.set(0.5, 0.5)
    @bat.animations.add("fly")
    @bat.animations.play("fly", 15, true)
    $game.physics.enable(@bat, Phaser::Physics::ARCADE)
    @bat.body.collide_world_bounds = true

    # TODO: bats
    # TODO: spiders
    # TODO: pumpkins
    # TODO: candy
    # TODO: player
    # TODO: bg
  end
end

# TODO: creepy font
# TODO: some random pumpkins
class BootState < Phaser::State
  def preload
    $game.load.spritesheet("kitty_potter", "../images/kitty_potter.png", 348, 273, 4)
    $game.load.spritesheet("bat", "../images/animated_bat.png", 180, 149, 7)
  end

  def create
    $game.stage.background_color = "AAF"

    text = $game.add.text($size_x/2, $size_y/2, "Collect candy\nAvoid creepy things\nPress any key to start", { fontSize: "64px", fill: "#000", align: "center" })
    text.anchor.set(0.5)

    # FIXME: make it work with keyboard as well
    # $game.input.keyboard.onDownCalback = proc{ $game.state.start(:game) }
    $game.input.on(:down) { $game.state.start(:game) }
  end
end

$game.state.add(:game, GameState.new)
$game.state.add(:boot, BootState.new, true)
