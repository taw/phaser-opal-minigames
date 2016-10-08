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
    platform = $game.add.tile_sprite(x, y, 64*3, 64, "clouds2")
    platform.anchor.set(0.5)
    @platforms.add platform
    platform.body.immovable = true
  end

  def add_fruit(x, y, fruit_name)
    fruit = $game.add.sprite(x, y, fruit_name)
    @fruits.add fruit
    fruit.body.immovable = true
  end

  def create
	  $game.physics.start_system(Phaser::Physics::ARCADE)
    background = $game.add.sprite(0, 0, 'mountain')
  	background.height = $size_y
  	background.width = $size_x
    @fruits = $game.add.group()
  	@fruits.enable_body = true
    add_fruit(rand*$size_x/2, rand*$size_y-100, 'lollipop')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'icecream')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'icelolly')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'grapes')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'cupcake')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'doughnut')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'pineapple')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'orange')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'watermelon')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'cherry')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'apple')
  	add_fruit(rand*$size_x/2, rand*$size_y-100, 'banana2')
  	@penguin = $game.add.sprite(rand*$size_x/2, rand*$size_y-100, 'penguin2')

    $game.physics.enable(@penguin, Phaser::Physics::ARCADE)

  	@platforms = $game.add.group()
    @platforms.enable_body = true
    add_platform 400, $size_y-100
    add_platform 400, $size_y-300
    add_platform 400, $size_y-500
    add_platform 700, $size_y-200
    add_platform 700, $size_y-400
    add_platform 700, $size_y-600
    add_platform 1000, $size_y-100
    add_platform 1000, $size_y-300
    add_platform 1000, $size_y-500

   
    @cursors = $game.input.keyboard.create_cursor_keys
  end

  def update
      $game.physics.arcade.collide(@penguin, @platforms)
      $game.physics.arcade.overlap(@penguin, @fruits) do |c,s|
        # @coin.play
        s.destroy
      end
      penguin_speed = 200
      @penguin.body.velocity.x = if @cursors.right.down?
        penguin_speed
      elsif @cursors.left.down?
        -penguin_speed
      else
        0
      end
      @penguin.body.velocity.y = if @cursors.down.down?
        penguin_speed
      elsif @cursors.up.down?
        -penguin_speed
      else
        0
      end
    end


end

$game.state.add(:main, MainState.new, true)
