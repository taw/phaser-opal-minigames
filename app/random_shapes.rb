require_relative "common"

class Shape
  def random_color
    $game.rnd.between(0, 0x1_00_00_00)
  end

  def initialize
    @graphics = $game.add.graphics(
      $game.rnd.between(0, $size_x),
      $game.rnd.between(0, $size_y)
    )
    @graphics.begin_fill(random_color)
    case $game.rnd.between(0, 1)
    when 0
      @graphics.draw_circle(0, 0, $game.rnd.between(10, 100))
    when 1
      # Randomly deformed 60x60 square
      @graphics.draw_polygon([
         30 + $game.rnd.between(-20, 20),  30 + $game.rnd.between(-20, 20),
         30 + $game.rnd.between(-20, 20), -30 + $game.rnd.between(-20, 20),
        -30 + $game.rnd.between(-20, 20), -30 + $game.rnd.between(-20, 20),
        -30 + $game.rnd.between(-20, 20),  30 + $game.rnd.between(-20, 20),
      ])
    end
  end

  def destroy
    @graphics.destroy
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "002"
    @shapes = 200.times.map{ Shape.new }
  end

  def update
    dt = $game.time.physics_elapsed
    # Every shape lives on average 2s
    @shapes = @shapes.map do |shape|
      if rand*2 < dt
        shape.destroy
        Shape.new
      else
        shape
      end
    end
  end
end

$game.state.add(:main, MainState.new, true)
