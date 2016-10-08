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
    $game.load.image("mountain", "../images/mountain.jpg")
  end

  def add_platform(x, y)
  	platform = @platforms.create(x, y, 'clouds2')
    platform.height = 40
    platform.width = 200
    platform.anchor.set(0.5)
    platform.body.immovable = true
  end

  def create
	background = $game.add.sprite(0, 0, 'mountain')
  	background.height = $size_y
  	background.width = $size_x
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'lollipop')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'icecream')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'icelolly')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'grapes')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'cupcake')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'doughnut')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'pineapple')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'orange')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'watermelon')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'cherry')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'apple')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'banana2')
  	$game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'clouds2')
  	@penguin = $game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'penguin2')

  	@platforms = $game.add.group()
    @platforms.enable_body = true
    add_platform 200, $size_y-100
    add_platform 200, $size_y-300
    add_platform 200, $size_y-500
    add_platform 500, $size_y-200
    add_platform 500, $size_y-400
    add_platform 500, $size_y-600
    add_platform 800, $size_y-100
    add_platform 800, $size_y-300
    add_platform 800, $size_y-500
  end

end

$game.state.add(:main, MainState.new, true)