require_relative "common"

class FruitGrid
  def initialize
    @size    = [$size_x, $size_y].min / 30.0
    @spacing = [$size_x, $size_y].min / 24.0
    @fruits = 20.times.map do |y|
      20.times.map do |x|
        n = $game.rnd.between(1, 12)
        sprite = $game.add.sprite(@spacing*(x-9.5) + $size_x/2, @spacing*(y-9.5) + $size_y/2, "fruit-#{n}")
        sprite.anchor.set(0.5)
        sprite.height = sprite.width = @size
        sprite
      end
    end
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("fruit-1", "../images/lollipop.png")
    $game.load.image("fruit-2", "../images/icecream.png")
    $game.load.image("fruit-3", "../images/icelolly.png")
    $game.load.image("fruit-4", "../images/grapes.png")
    $game.load.image("fruit-5", "../images/cupcake.png")
    $game.load.image("fruit-6", "../images/doughnut.png")
    $game.load.image("fruit-7", "../images/pineapple.png")
    $game.load.image("fruit-8", "../images/orange.png")
    $game.load.image("fruit-9", "../images/watermelon.png")
    $game.load.image("fruit-10", "../images/cherry.png")
    $game.load.image("fruit-11", "../images/apple.png")
    $game.load.image("fruit-12", "../images/banana2.png")
  end

  def create
    $game.stage.background_color = "2A6"
    @grid = FruitGrid.new
  end
end

$game.state.add(:main, MainState.new, true)
