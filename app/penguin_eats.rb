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
    fruit.anchor.set(0.5)
    @fruits.add fruit
    fruit.body.immovable = true
  end

  def create
    background = $game.add.sprite(0, 0, 'mountain')
    background.height = $size_y
    background.width = $size_x
    @score = 0
    @score_text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#FBE8D3', align: 'center' })
	  $game.physics.start_system(Phaser::Physics::ARCADE)


    @platforms = $game.add.group()
    @platforms.enable_body = true
    add_platform 250, $size_y-150
    add_platform 400, $size_y-300
    add_platform 600, $size_y-450

    add_platform 700, $size_y-150
    add_platform 900, $size_y-300

    add_platform 1050, $size_y-100
    add_platform 1100, $size_y-400

    @fruits = $game.add.group()
  	@fruits.enable_body = true
    add_fruit(225, $size_y-200, "lollipop")
  	add_fruit(275, $size_y-200, "cherry")

    add_fruit(400, $size_y-350, "icecream")

  	add_fruit(575, $size_y-500, "icelolly")
    add_fruit(625, $size_y-500, "cupcake")

    add_fruit(675, $size_y-200, "grapes")
  	add_fruit(725, $size_y-200, "apple")

    add_fruit(900, $size_y-350, "orange")

    add_fruit(1075, $size_y-450, "watermelon")
    add_fruit(1125, $size_y-450, "doughnut")

    add_fruit(1025, $size_y-150, "pineapple")
  	add_fruit(1075, $size_y-150, "banana2")

  	@penguin = $game.add.sprite(100, $size_y-100, 'penguin2')
    $game.physics.enable(@penguin, Phaser::Physics::ARCADE)

    @penguin.body.collide_world_bounds = true

    @penguin.body.gravity.y = 250

    @cursors = $game.input.keyboard.create_cursor_keys
  end

  def update
    $game.physics.arcade.collide(@penguin, @platforms)
    $game.physics.arcade.overlap(@penguin, @fruits) do |c,s|
      # @coin.play
      s.destroy
      @score += 1
    end
    @score_text.text = "Penguin ate #{@score} fruits/sweets."
    penguin_speed = 200
    @penguin.body.velocity.x = if @cursors.right.down?
      penguin_speed
    elsif @cursors.left.down?
      -penguin_speed
    else
      0
    end

    if @cursors.up.down? and (@penguin.body.blocked.down or @penguin.body.touching.down)
      @penguin.body.velocity.y = -350
    end
  end
end

$game.state.add(:main, MainState.new, true)
