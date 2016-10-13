require_relative "common"

class Character
  def initialize
    @graphics = $game.add.text(0, 0, "", {})
    reset_character
    # Start with characters scattered all over the screen
    @y = $game.rnd.between(0, $size_y)
  end

  # When we reset, we place it on top
  def reset_character
    @y = -24
    @x = $game.rnd.between(0, $size_x)
    # Between 4s to 10s to fall all the way
    @speed = $game.rnd.between($size_y/10, $size_y/4)
    @graphics.text = $game.rnd.between(0x30A0, 0x30FF).chr
    @graphics.font_size = random_size
    @graphics.fill = random_color
    @graphics.stroke = random_outline_color
    @graphics.stroke_thickness = $game.rnd.between(0, 3)
  end

  def update(dt)
    @y += @speed*dt
    @graphics.x = @x
    @graphics.y = @y
    if @y >= $size_y
      reset_character
    end
  end

  def random_size
    "%dpx" % [$game.rnd.between(16, 24)]
  end

  def random_color
    "#%02x%02x%02x" % [
      $game.rnd.between(90, 140),
      $game.rnd.between(140, 255),
      $game.rnd.between(90, 140),
    ]
  end

  def random_outline_color
    "#%02x%02x%02x" % [
      $game.rnd.between(140, 255),
      $game.rnd.between(90, 140),
      $game.rnd.between(90, 140),
    ]
  end
end

class MainState < Phaser::State
  def update
    dt = $game.time.physics_elapsed
    @characters.each do |character|
      character.update(dt)
    end
  end

  def create
    @characters = 1000.times.map do
      Character.new
    end
    $game.stage.background_color = "020"
  end
end

$game.state.add(:main, MainState.new, true)
