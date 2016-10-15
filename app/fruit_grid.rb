require_relative "common"

class FruitGrid
  def initialize
    @spacing = [$size_x, $size_y].min / 24.0
    @cells = 20.times.map do |y|
      20.times.map do |x|
        graphics = $game.add.graphics(
          grid_x_to_screen_x(x),
          grid_y_to_screen_y(y),
        )
        graphics.begin_fill(0x55FFCC)
        graphics.draw_rect(-@spacing*0.45, -@spacing*0.45, @spacing*0.9, @spacing*0.9)
        graphics
      end
    end
    @fruits = 20.times.map do |y|
      20.times.map do |x|
        n = $game.rnd.between(1, 12)
        sprite = $game.add.sprite(
          grid_x_to_screen_x(x),
          grid_y_to_screen_y(y),
          "fruit-#{n}"
        )
        sprite.anchor.set(0.5)
        sprite.height = sprite.width = @spacing * 0.8
        sprite
      end
    end
  end

  def grid_x_to_screen_x(x)
    @spacing*(x-9.5) + $size_x/2
  end

  def grid_y_to_screen_y(y)
    @spacing*(y-9.5) + $size_y/2
  end

  def screen_x_to_grid_x(x)
    ((x - $size_x/2) / @spacing + 9.5).round
  end

  def screen_y_to_grid_y(y)
    ((y - $size_y/2) / @spacing + 9.5).round
  end

  def set_highlight(mouse_x, mouse_y)
    x = screen_x_to_grid_x(mouse_x)
    y = screen_y_to_grid_y(mouse_y)
    @cells.flatten.each do |cell|
      cell.visible = false
    end
    @cells[y][x].visible = true
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("fruit-1", "../images/lollipop.png")
    $game.load.image("fruit-2", "../images/icecream.png")
    $game.load.image("fruit-3", "../images/icelolly.png")
    $game.load.image("fruit-4", "../images/grapes.png")
    $game.load.image("fruit-5", "../images/cupcake.png")
    $game.load.image("fruit-6", "../images/doughnut.png")
    $game.load.image("fruit-7", "../images/pineapple.png")
    $game.load.image("fruit-8", "../images/orange.png")
    $game.load.image("fruit-9", "../images/watermelon.png")
    $game.load.image("fruit-10", "../images/cherry.png")
    $game.load.image("fruit-11", "../images/apple.png")
    $game.load.image("fruit-12", "../images/banana2.png")
  end

  def create
    $game.stage.background_color = "2A6"
    @grid = FruitGrid.new
  end

  def update
    @grid.set_highlight(
      $game.input.mouse_pointer.worldX,
      $game.input.mouse_pointer.worldY
    )
  end
end

$game.state.add(:main, MainState.new, true)
