require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Shape
  def random_color
    $game.rnd.between(0, 0x1_00_00_00)
  end

  def initialize
    @active = true
    @x = $game.rnd.between(0, $size_x)
    @y = $game.rnd.between(0, $size_y)
    @graphics = $game.add.graphics(@x, @y)
    @graphics.line_style(0)
    @graphics.begin_fill(random_color)
    case $game.rnd.between(0, 1)
    when 0
      @graphics.draw_circle(0, 0, $game.rnd.between(5, 100))
    when 1
      @graphics.draw_polygon([
        0,
        0,
        $game.rnd.between(-50, 50),
        $game.rnd.between(-50, 50),
        $game.rnd.between(-50, 50),
        $game.rnd.between(-50, 50),
      ])
    end
    @graphics.end_fill
  end

  def destroy
    @graphics.destroy
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "002"
    @shapes = []
    @shape_timer = 0
  end

  def update
    dt = $game.time.physics_elapsed
    @shape_timer += dt
    # Only update after enough time elapsed, not every frame
    if @shape_timer > 0.1 or @shapes.size < 50
      if @shapes.size >= 100
        @shapes.shift.destroy
      end
      @shapes << Shape.new
      @shape_timer = 0
    end
  end
end

__END__

random_color = ->
  Math.random() * 0xFFFFFF

class Shape
