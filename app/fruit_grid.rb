require_relative "common"
require "set"

class FruitGrid
  def initialize
    @spacing = [$size_x, $size_y].min / 24.0
    @cells = {}
    @fruits = {}
    20.times.map do |y|
      20.times.map do |x|
        graphics = $game.add.graphics(
          grid_x_to_screen_x(x),
          grid_y_to_screen_y(y),
        )
        graphics.begin_fill(0x55FFCC)
        graphics.draw_rect(-@spacing*0.45, -@spacing*0.45, @spacing*0.9, @spacing*0.9)
        graphics.visible = false
        @cells[[x,y]] = graphics
      end
    end
    # Don't use all fruit every time
    fruit_selection = (1..12).to_a.sample(6)
    20.times.map do |y|
      20.times.map do |x|
        n = fruit_selection.sample
        sprite = $game.add.sprite(
          grid_x_to_screen_x(x),
          grid_y_to_screen_y(y),
          "fruit-#{n}"
        )
        sprite.anchor.set(0.5)
        sprite.height = sprite.width = @spacing * 0.8
        @fruits[[x,y]] = sprite
      end
    end

    @highlighted = Set[]
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

  def find_cells_to_highlight(x,y)
    @highlighted << [x,y]
    [[x-1,y], [x+1,y], [x,y-1], [x,y+1]].each do |xx,yy|
      next unless @cells.has_key? [xx,yy]
      next if @highlighted.include? [xx,yy]
      next if @fruits[[xx,yy]].key == nil
      if @fruits[[xx,yy]].key == @fruits[[x,y]].key
        find_cells_to_highlight(xx,yy)
      end
    end
  end

  def click(mouse_x, mouse_y)
    set_highlight(mouse_x, mouse_y)
    @highlighted.each do |x,y|
      @fruits[[x,y]].destroy
      @fruits[[x,y]].key = nil
    end
  end

  def set_highlight(mouse_x, mouse_y)
    x = screen_x_to_grid_x(mouse_x)
    y = screen_y_to_grid_y(mouse_y)
    @cells.each_value do |cell|
      cell.visible = false
    end
    return unless x.between?(0, 19) and y.between?(0, 19)
    @highlighted = []
    find_cells_to_highlight(x, y)
    @highlighted.each do |x,y|
      @cells[[x,y]].visible = true
    end
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
    $game.input.on(:tap) do
      @grid.click(
        $game.input.active_pointer.world_x,
        $game.input.active_pointer.world_y,
      )
    end
  end

  def update
    @grid.set_highlight(
      $game.input.mouse_pointer.world_x,
      $game.input.mouse_pointer.world_y,
    )
  end
end

$game.state.add(:main, MainState.new, true)
