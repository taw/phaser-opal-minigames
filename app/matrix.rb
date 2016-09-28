require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Character
  attr_reader :active

  def initialize
    @active = true
    @c = $game.rnd.between(0x30A0, 0x30FF).chr
    @x = $game.rnd.between(0, $size_x)
    @y = $game.rnd.between(0, $size_y/4)
    @speed = $game.rnd.between(30, 200)
    @graphics = $game.add.text(@x, @y, @c, {
      fontSize: random_size,
      fill: random_color,
      stroke: random_outline_color,
      strokeThickness: $game.rnd.between(0, 5),
    })
  end

  def update(dt)
    @y += @speed*dt
    @graphics.x = @x
    @graphics.y = @y
    if @y >= $size_y
      @active = false
      @graphics.destroy
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
    if @characters.length < 1000
      @characters << Character.new
    end
    @characters.each do |character|
      character.update(dt)
    end
    @characters.select!(&:active)
  end

  def create
    @characters = []
    $game.stage.background_color = "444"
  end
end
