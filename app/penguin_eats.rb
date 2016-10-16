require_relative "common"

class StarEmitter
  def initialize
    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("star3")
    @emitter.gravity = -50
    @emitter.maxParticleSpeed.x = 50
    @emitter.minParticleSpeed.x = -50
    @emitter.maxParticleSpeed.y = 50
    @emitter.minParticleSpeed.y = -50
    @emitter.set_alpha(0.2, 0.5, 0)
  end

  def burst_at(x, y)
    @emitter.x = x
    @emitter.y = y
    @emitter.start true, 2000, nil, 40
  end
end

class Snowflake
  def initialize
    @snowflake = $game.add.sprite(
      $game.rnd.between(0, $world_size_x-24),
      $game.rnd.between(0, $world_size_y-22),
      "circle"
    )
    @snowflake.height = @snowflake.width = rand*10
    @snowflake.alpha = rand*0.6
    @speed = $game.rnd.between(100, 200)
  end

  def update(time)
    @snowflake.y += @speed * time
    @snowflake.x += @speed * time
    if @snowflake.y > $world_size_y-5
      @snowflake.y = 0
    end

    if @snowflake.x > $world_size_x-5
      @snowflake.x = 0
    end
  end
end

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
    $game.load.image("star3", "../images/star3.png")
    $game.load.image("circle", "../images/circle.png")
    $game.load.image("ice_cloud", "../images/ice_cloud.png")
    $game.load.audio("pop", "../audio/pop3.mp3")
  end

  def add_platform(x, y)
    platform = $game.add.tile_sprite(x, y, 64*3, 36, "clouds2")
    platform.anchor.set(0.5)
    @platforms.add platform
    platform.body.immovable = true
  end

  def add_floor(x, y)
    floor = $game.add.tile_sprite(x, y, $world_size_x, 64, "ice_cloud")
    floor.anchor.set(0)
    @floors.add floor
    floor.body.immovable = true
  end

  def add_fruit(x, y, fruit_name)
    fruit = $game.add.sprite(x, y, fruit_name)
    fruit.anchor.set(0.5)
    @fruits.add fruit
    fruit.body.immovable = true
  end

  def add_sweet(x, y, sweet_name)
    sweet = $game.add.sprite(x, y, sweet_name)
    sweet.anchor.set(0.5)
    @sweets.add sweet
    sweet.body.immovable = true
  end

  def create
    background = $game.add.sprite(0, 0, 'mountain')
    background.height = $size_y
    background.width = $size_x
    background.fixed_to_camera = true
    @score_fruits = 0
    @score_sweets = 0
    $world_size_x = 3200
    $world_size_y = 1500
    @score_text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#FBE8D3', align: 'left' })
    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @floors = $game.add.group()
    @floors.enable_body = true
    add_floor 0, $world_size_y-64

    @platforms = $game.add.group()
    @platforms.enable_body = true
    add_platform 250, $world_size_y-150
    add_platform 400, $world_size_y-300
    add_platform 600, $world_size_y-450
    add_platform 700, $world_size_y-150
    add_platform 900, $world_size_y-300
    add_platform 1050, $world_size_y-100
    add_platform 1100, $world_size_y-400

    @fruits = $game.add.group()
    @fruits.enable_body = true
    add_fruit(275, $world_size_y-200, "cherry")
    add_fruit(675, $world_size_y-200, "grapes")
    add_fruit(725, $world_size_y-200, "apple")
    add_fruit(900, $world_size_y-350, "orange")
    add_fruit(1075, $world_size_y-450, "watermelon")
    add_fruit(1025, $world_size_y-150, "pineapple")
    add_fruit(1075, $world_size_y-150, "banana2")

    @sweets = $game.add.group()
    @sweets.enable_body = true
    add_sweet(225, $world_size_y-200, "lollipop")
    add_sweet(400, $world_size_y-350, "icecream")
    add_sweet(575, $world_size_y-500, "icelolly")
    add_sweet(625, $world_size_y-500, "cupcake")
    add_sweet(1125, $world_size_y-450, "doughnut")

    @penguin = $game.add.sprite(100, $world_size_y-100, "penguin2")
    $game.physics.enable(@penguin, Phaser::Physics::ARCADE)
    @penguin.anchor.set(0.5)
    @penguin.body.collide_world_bounds = true
    @penguin.body.gravity.y = 250

    @emitter = StarEmitter.new

    @pop = $game.add.audio("pop")

    @cursors = $game.input.keyboard.create_cursor_keys

    @snowflake = 250.times.map do
      Snowflake.new
    end
  end

  def update
    $game.physics.arcade.collide(@penguin, @platforms)
    $game.physics.arcade.overlap(@penguin, @fruits) do |c,s|
      @pop.play
      s.destroy
      @score_fruits += 1
    end

    $game.physics.arcade.overlap(@penguin, @sweets) do |c,s|
      @pop.play
      s.destroy
      @score_sweets += 2
      @emitter.burst_at(@penguin.x, @penguin.y)
    end

    @score_text.text = "Penguin ate #{@score_fruits} fruits.\nPenguin ate #{@score_sweets} sweets.\nTotal score is #{@score_fruits + @score_sweets}."

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

    dt = $game.time.physics_elapsed
    @snowflake.each do |snowflake|
      snowflake.update(dt)
    end

    $game.camera.x = @penguin.x-$size_x/2
    $game.camera.y = @penguin.y-$size_y/2

  end
end

$game.state.add(:main, MainState.new, true)
