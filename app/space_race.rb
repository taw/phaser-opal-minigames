require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("star", "../images/star.png")
    $game.load.image("spaceship", "../images/spaceship.png")
  end

  def create
    $game.stage.background_color = "003"
    @a = $game.add.sprite(100, 100, "spaceship")
    @a.tint = 0xFF8888
    @b = $game.add.sprite(200, 150, "spaceship")
    @b.tint = 0x88FF88
    @c = $game.add.sprite(300, 100, "spaceship")
    @c.tint = 0x8888FF
    @d = $game.add.sprite(400, 150, "spaceship")
    @d.tint = 0xFFFF80
  end
end

$game.state.add(:main, MainState.new, true)
