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

class Shark
  attr_reader :shark
  def initialize
    @shark = $game.add.sprite(
      $game.rnd.between(0,$world_size_x-24),
      $game.rnd.between(0,$world_size_y-22),
      "shark"
    )
    @speed = $game.rnd.between(100, 200)
    @shark.scale.x = -1
  end

  def update(time)
    @shark.x += @speed * time
    if @shark.x > $world_size_x-5
      @shark.x = 0
    end
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("sweet-1", "../images/lollipop.png")
    $game.load.image("sweet-2", "../images/icecream.png")
    $game.load.image("sweet-3", "../images/icelolly.png")
    $game.load.image("sweet-4", "../images/cupcake.png")
    $game.load.image("sweet-5", "../images/doughnut.png")

    $game.load.image("fruit-1", "../images/grapes.png")
    $game.load.image("fruit-2", "../images/pineapple.png")
    $game.load.image("fruit-3", "../images/orange.png")
    $game.load.image("fruit-4", "../images/watermelon.png")
    $game.load.image("fruit-5", "../images/cherry.png")
    $game.load.image("fruit-6", "../images/apple.png")
    $game.load.image("fruit-7", "../images/banana2.png")

    $game.load.image("penguin2", "../images/penguin2.png")
    $game.load.image("clouds2", "../images/clouds2.png")
    $game.load.image("mountain", "../images/mountain.jpg")
    $game.load.image("star3", "../images/star3.png")
    $game.load.image("circle", "../images/circle.png")
    $game.load.image("ice_cloud", "../images/ice_cloud.png")
    $game.load.image("shark", "../images/shark-icon.png")
    $game.load.audio("pop", "../audio/pop3.mp3")
  end

  def add_platform(x, y)
    platform = $game.add.tile_sprite(x, y, 64*3, 36, "clouds2")
    platform.anchor.set(0.5)
    @platforms.add platform
    platform.body.immovable = true

    # text = $game.add.text(x, y, "#{x},#{$world_size_y-y}", { font: "24px Arial", fill: "#ffffff"})
    # text.anchor.set(0.5)

    if $game.rnd.between(0,1) == 0
      number = $game.rnd.between(1,7)
      add_fruit x, y-50, "fruit-#{number}"
    else
      number = $game.rnd.between(1,5)
      add_sweet x, y-50, "sweet-#{number}"
    end
  end

  def add_floor
    floor = $game.add.tile_sprite(0, $world_size_y, $world_size_x, 30, "ice_cloud")
    floor.anchor.set(0, 1)
    @platforms.add floor
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

  def add_shark(x, y)
    shark = Shark.new
    @sharks.add shark.shark
    shark
  end

  def create
    background = $game.add.sprite(0, 0, 'mountain')
    background.height = $size_y
    background.width = $size_x
    background.fixed_to_camera = true
    @score_fruits = 0
    @score_sweets = 0
    @score_lives = 3
    $world_size_x = 3200
    $world_size_y = 1500
    @score_text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#FBE8D3', align: 'left' })
    @score_text.fixed_to_camera = true
    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.world.set_bounds(0, 0, $world_size_x, $world_size_y)

    @platforms = $game.add.group
    @platforms.enable_body = true
    @fruits = $game.add.group
    @fruits.enable_body = true
    @sweets = $game.add.group
    @sweets.enable_body = true
    @sharks = $game.add.group
    @sharks.enable_body = true

    add_floor
    add_platform 250, $world_size_y-150
    add_platform 400, $world_size_y-300
    add_platform 550, $world_size_y-420
    add_platform 700, $world_size_y-150
    add_platform 900, $world_size_y-300
    add_platform 1050, $world_size_y-100
    add_platform 1100, $world_size_y-400

    add_platform 250, $world_size_y-550
    add_platform 400, $world_size_y-750
    add_platform 600, $world_size_y-850
    add_platform 700, $world_size_y-550
    add_platform 900, $world_size_y-600
    add_platform 1050, $world_size_y-750
    add_platform 900, $world_size_y-1000
    add_platform 800, $world_size_y-1200

    add_platform 1350, $world_size_y-150
    add_platform 1750, $world_size_y-300
    add_platform 1890, $world_size_y-450
    add_platform 2000, $world_size_y-150
    add_platform 2200, $world_size_y-300
    add_platform 2350, $world_size_y-100
    add_platform 2500, $world_size_y-400
    add_platform 2600, $world_size_y-200
    add_platform 2700, $world_size_y-500

    add_platform 1350, $world_size_y-550
    add_platform 1750, $world_size_y-800
    add_platform 1890, $world_size_y-1250
    add_platform 2000, $world_size_y-550
    add_platform 2200, $world_size_y-800
    add_platform 2350, $world_size_y-1250
    add_platform 2500, $world_size_y-1600
    add_platform 2600, $world_size_y-900
    add_platform 2800, $world_size_y-700

    add_platform 2400, $world_size_y-1050
    add_platform 2100, $world_size_y-1050
    add_platform 1400, $world_size_y-950

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

    @shark = 20.times.map do
      add_shark
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

    $game.physics.arcade.overlap(@penguin, @sharks) do |c,s|
      @pop.play
      c.alpha = 0.3
      @score_lives -= 1
    end

    @score_text.text = "Penguin ate #{@score_fruits} fruits.\nPenguin ate #{@score_sweets} sweets.\nTotal score is #{@score_fruits + @score_sweets}.\nNumber of lives #{@score_lives}."

    penguin_speed = 250
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

    @shark.each do |shark|
      shark.update(dt)
    end
  end
end

$game.state.add(:main, MainState.new, true)
