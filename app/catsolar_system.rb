require_relative "common"
require_relative "shaders/sun"

class Cat
  def initialize
    @cat = $game.add.sprite(0, 0, "cat")
    @cat.anchor.set(0.5, 0.5)
    @cat.width = @cat.height = [$size_x, $size_y].min * 0.05
    @phase = 0
  end

  def update(dt)
    @phase -= dt
    @cat.x = ( 0.5 + 0.4 * Math.sin(@phase/5) ) * $size_x
    @cat.y = ( 0.5 + 0.4 * Math.cos(@phase/5) ) * $size_y
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "../images/cat_images/cat4.png")
  end

  def create
    $game.stage.background_color = "000"

    @filter = Phaser::Filter.new($game, nil, ShaderSun)
    @filter.set_resolution($size_x, $size_y)
    @sprite = $game.add.sprite($size_x/2, $size_y/2)
    @sprite.anchor.set(0.5, 0.5)
    @sprite.width = $size_x/2
    @sprite.height = $size_y/2
    @sprite.filters = [ @filter ]

    @cat = Cat.new
  end

  def update
    dt = $game.time.physics_elapsed
    @cat.update(dt)
    @filter.update
  end
end

$game.state.add(:main, MainState.new, true)
