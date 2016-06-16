require_relative "common"

class Game
  def initialize
    run
  end

  def run
    $size_x = `window.innerWidth`
    $size_y = `window.innerHeight`
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    state = MainLevel.new($game)
    $game.state.add(:main, state, true)
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
    @graphics = $game.add.text(@x, @y, @c, {fontSize: "20px", fill: "#8F8"})
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
end

class MainLevel < Phaser::State
  def update
    dt = $game.time.physicsElapsed
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
