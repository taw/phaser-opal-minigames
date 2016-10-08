require_relative "common"

class MainState < Phaser::State
  def preload
	$game.load.image("lollipop", "../images/lollipop.png")
    $game.load.image("icecream", "../images/icecream.png")
    $game.load.image("icelolly", "../images/icelolly.png")
    $game.load.image("grapes", "../images/grapes.png")
    $game.load.image("cupcake", "../images/cupcake.png")
    $game.load.image("doughnut", "../images/doughnut.png")
    $game.load.image("pineapple", "../images/pineapple.png")
    $game.load.image("orange", "../images/orange.png")
    $game.load.image("watermelon", "../images/watermelon.png")
    $game.load.image("cherry", "../images/cherry.png")
    $game.load.image("apple", "../images/apple.png")
    $game.load.image("banana2", "../images/banana2.png")
    $game.load.image("penguin2", "../images/penguin2.png")
    $game.load.image("clouds2", "../images/clouds2.png")
  end

  def create
  	$game.stage.background_color = "#DFF09D"
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'lollipop')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'icecream')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'icelolly')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'grapes')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'cupcake')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'doughnut')
  	@penguin = $game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'penguin2')
  end

end

$game.state.add(:main, MainState.new, true)