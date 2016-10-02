require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Hamburger
  def initialize
    @graphics = $game.add.sprite(0, 0, "hamburger")
    @graphics.height = 64
    @graphics.width = 64
    reset_hamburger_position
  end

  def update(time)
    @graphics.y += @speed_x * time
    @graphics.x += @speed_y * time
    if @graphics.y < 0 or @graphics.x < 0 or @graphics.y >= $size_y or @graphics.x >= $size_x
      reset_hamburger_position
    end
  end

  def reset_hamburger_position
    @graphics.x = $game.rnd.between(0, $size_x - 64)
    @graphics.y = $game.rnd.between(0, $size_y - 64)
    angle = $game.math.deg_to_rad($game.rnd.between(0, 360))
    speed = $game.rnd.between(22, 200)
    @speed_x = Math.cos(angle) * speed
    @speed_y = Math.sin(angle) * speed
  end
end

class Smiley
  def initialize
    @graphics_smiley = $game.add.sprite(45, 23, "smiley")
    @graphics_smiley.height = 80
    @graphics_smiley.width = 80
  end

  def move(direction_x, direction_y, time)
    @graphics_smiley.x += time * direction_x * 300
    @graphics_smiley.y += time * direction_y * 300
  end

end

class MainState < Phaser::State
  def preload
    $game.load.image("hamburger", "/images/hamburger.png")
    $game.load.image("smiley", "/images/smiley.png")
  end

  def create
    $game.stage.background_color = "#FFC47F"
    @hamburger = 15.times.map do
      Hamburger.new      
    end
    @smiley = Smiley.new
  end

  def update
    dt = $game.time.physics_elapsed
    @hamburger.each do |hamburger|
      hamburger.update(dt)
    end
    @smiley.move(1, 0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)
    @smiley.move(-1, 0, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
    @smiley.move(0, 1, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.DOWN`)
    @smiley.move(0, -1, dt) if $game.input.keyboard.down?(`Phaser.KeyCode.UP`)
  end

end