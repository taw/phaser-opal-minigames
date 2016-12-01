require_relative "common"

class Character
  def initialize
    @graphics = $game.add.text(0, 0, "", {})
    reset_character(false)
  end

  # When we reset, we place it on top
  def reset_character(top_of_screen_only)
    if top_of_screen_only
      # New characters all start on top
      @graphics.y = -24*5
    else
      # When starting the game, scatter characters all over the screen
      @graphics.y = $game.rnd.between(0, $size_y)
    end
    @graphics.x = $game.rnd.between(0, $size_x)
    # Between 4s to 10s to fall all the way
    @speed = $game.rnd.between($size_y/10, $size_y/4)
    size = $game.rnd.between(1, 6)
    @graphics.text = size.times.map{ $game.rnd.between(0x30A0, 0x30FF).chr }.join("\n")
    @graphics.font_size = random_size
    @graphics.fill = random_color
    @graphics.stroke = random_outline_color
    @graphics.stroke_thickness = $game.rnd.between(0, 3)
  end

  def update(dt)
    @graphics.y += @speed*dt
    if @graphics.y >= $size_y
      reset_character(true)
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
  def create
    $game.stage.background_color = "020"
    @characters = 250.times.map do
      Character.new
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @characters.each do |character|
      character.update(dt)
    end
  end
end

$game.state.add(:main, MainState.new, true)
