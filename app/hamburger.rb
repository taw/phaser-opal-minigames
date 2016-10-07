require_relative "common"

class Hamburger
  def initialize
    @graphics = $game.add.sprite(0, 0, "hamburger")
    @graphics.anchor.set(0.5, 0.5)
    @graphics.height = 64
    @graphics.width = 64
    reset_hamburger_position
  end

  def update(time)
    @graphics.y += @speed_x * time
    @graphics.x += @speed_y * time
    unless @graphics.y.between?(32, $size_y-32) and @graphics.x.between?(32, $size_x-32)
      reset_hamburger_position
    end
  end

  def reset_hamburger_position
    @graphics.x = $game.rnd.between(32, $size_x - 32)
    @graphics.y = $game.rnd.between(32, $size_y - 32)
    angle = $game.math.deg_to_rad($game.rnd.between(0, 360))
    speed = $game.rnd.between(22, 200)
    @speed_x = Math.cos(angle) * speed
    @speed_y = Math.sin(angle) * speed
  end

  def x
    @graphics.x
  end

  def y
    @graphics.y
  end
end

class Smiley
  def initialize
    @graphics_smiley = $game.add.sprite($size_x/2, $size_y/2, "smiley")
    @graphics_smiley.anchor.set(0.5, 0.5)
    @graphics_smiley.height = 80
    @graphics_smiley.width = 80
  end

  def move(direction_x, direction_y, time)
    @graphics_smiley.x += time * direction_x * 300
    @graphics_smiley.x = $game.math.clamp(@graphics_smiley.x, 40, $size_x-40)
    @graphics_smiley.y += time * direction_y * 300
    @graphics_smiley.y = $game.math.clamp(@graphics_smiley.y, 40, $size_y-40)
  end

  def x
    @graphics_smiley.x
  end

  def y
    @graphics_smiley.y
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("hamburger", "../images/hamburger.png")
    $game.load.image("smiley", "../images/smiley.png")
  end

  def create
    @score = 0
    @score_text = $game.add.text(10, 10, "", { fontSize: '16px', fill: '#FA4659', align: 'center' })
    $game.stage.background_color = "#FFC47F"
    @hamburgers = 15.times.map do
      Hamburger.new
    end
    @smiley = Smiley.new
  end

  def burger_eaten?(burger)
    # a**2 + b**2 == c**2
    distance = ((burger.x - @smiley.x) ** 2 + (burger.y - @smiley.y) ** 2) ** 0.5
    distance < 40 + 32
  end

  def update
    dt = $game.time.physics_elapsed
    @hamburgers.each do |hamburger|
      hamburger.update(dt)
    end
    @smiley.move(1, 0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)
    @smiley.move(-1, 0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
    @smiley.move(0, 1, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.DOWN`)
    @smiley.move(0, -1, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.UP`)
    @score_text.text = "Burgers eaten: #{@score}"
    @hamburgers.each do |burger|
      if burger_eaten?(burger)
        burger.reset_hamburger_position
        @score += 1
      end
    end
  end
end

$game.state.add(:main, MainState.new, true)
