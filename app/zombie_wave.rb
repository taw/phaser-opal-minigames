require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("zombie", "../images/characters/zombie.png", 444, 324)
  end

  def create
    $game.stage.background_color = "008"
    @zombie = $game.add.sprite($size_x/2, $size_y/2, "zombie")
    @zombie.animations.add("appear", (1..11).to_a, 1800, true)
    @zombie.animations.add("attack", (12..18).to_a, 1800, true)
    @zombie.animations.add("die", (19..26).to_a, 1800, true)
    @zombie.animations.add("idle", (27..32).to_a, 1800, true)
    @zombie.animations.add("walk", (33..42).to_a, 1800, true)
    @i = 0
  end

  def update
    animation = %W[appear attack die idle walk]
    $game.input.on("down") do |pointer, event|
      @zombie.animations.play(animation[@i % 5], 15, true)
      @i += 1
    end
  end
end

$game.state.add(:main, MainState.new, true)
