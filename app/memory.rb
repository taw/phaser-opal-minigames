require_relative "common"

class Tile
  attr_reader :status, :c
  def initialize(x,y,c)
    @x = x
    @y = y
    @c = c
    @status = "hidden" # matched / hidden / peek
    @bg = $game.add.graphics(@x, @y)
    @bg.line_style(2, 0x000000, 1)
    @bg.begin_fill(0xFF8888)
    @bg.draw_polygon(
      -48, -48,
      -48,  48,
       48,  48,
       48, -48,
      -48, -48,
    )
    @tile = $game.add.sprite(@x, @y, "cat#{c}")
    @tile.anchor.set(0.5, 0.5)
    @tile.height = 96
    @tile.width = 96
    @tile.visible = false
    @hidden_tile = $game.add.text(@x, @y, "?")
    @hidden_tile.anchor.set(0.5, 0.5)
  end

  def set_status(status)
    @status = status
    case status
    when "hidden"
      @tile.visible = false
      @hidden_tile.visible = true
    when "peek", "revealed"
      @tile.visible = true
      @hidden_tile.visible = false
    end
  end
end

class Board
  attr_reader :cells_x, :cells_y
  def initialize(cells_x, cells_y)
    @cells_x = cells_x
    @cells_y = cells_y
    cats = (1..20).to_a.sample(@cells_x*@cells_y/2)
    tiles = [*cats, *cats].shuffle
    @content = (0...@cells_x).map do
      (0...@cells_y).map do
        tiles.pop
      end
    end
    setup_grid
    @status = "ready"
  end

  def setup_grid
    @grid = (0...@cells_x).map do |x|
      (0...@cells_y).map do |y|
        loc_x = $size_x/2 + 96 * (x-@cells_x/2+0.5)
        loc_y = $size_y/2 + 96 * (y-@cells_y/2+0.5)
        Tile.new(loc_x, loc_y, @content[x][y])
      end
    end
  end

  def click_cell(x,y)
    return if @grid[x][y].status == "revealed"

    case @status
    when "ready"
      @grid[x][y].set_status("peek")
      @x1 = x
      @y1 = y
      @status = "one"
      nil
    when "one"
      if x == @x1 and y == @y1
        nil
      elsif @grid[x][y].c == @grid[@x1][@y1].c
        @grid[@x1][@y1].set_status("revealed")
        @grid[x][y].set_status("revealed")
        @status = "ready"
        "match"
      else
        @grid[x][y].set_status("peek")
        @x2 = x
        @y2 = y
        @status = "two"
        "miss"
      end
    when "two"
      @grid[@x1][@y1].set_status("hidden")
      @grid[@x2][@y2].set_status("hidden")
      @status = "ready"
      click_cell(x, y)
      nil
    end
  end
end

class GameState < Phaser::State
  def initialize(x,y)
    @x = x
    @y = y
  end

  def update
    @scoreText.text = "Clicks: #{@score}"
  end

  def click(x,y)
    x = ((x - $size_x / 2 + 96*(@board.cells_x/2 - 0.5)) / 96.0).round
    y = ((y - $size_y / 2 + 96*(@board.cells_y/2 - 0.5)) / 96.0).round
    if x >= 0 and x <= @board.cells_x-1 and y >= 0 and y <= @board.cells_y-1
      case @board.click_cell(x,y)
      when "match"
        @meow.play()
        @score += 1
      when "miss"
        @score += 1
      end
    end
  end

  def create
    @score = 0
    @scoreText = $game.add.text(16, 16, "", { fontSize: "32px", fill: "#fff" })
    @meow = $game.add.audio("meow")
    @button_menu = $game.add.button(16, 64, "menu") do
      $game.state.start("Menu")
    end
    $game.stage.background_color = "88F"
    @board = Board.new(@x, @y)
    $game.input.on(:tap) do
      click(
        $game.input.active_pointer.worldX,
        $game.input.active_pointer.worldY,
      )
    end
  end
end

class MenuState < Phaser::State
  def preload
    (1..20).each do |i|
      $game.load.image("cat#{i}", "../images/cat_images/cat#{i}.png")
    end
    $game.load.audio("meow", "../audio/cat_meow.mp3")
    $game.load.image("menu", "../images/buttons/menu.png")
    $game.load.image("button2x2", "../images/buttons/play2x2.png")
    $game.load.image("button4x4", "../images/buttons/play4x4.png")
    $game.load.image("button6x6", "../images/buttons/play6x6.png")
  end

  def create
    $game.stage.background_color = "F8F"
    @button22 = $game.add.button($size_x*0.5, $size_y*0.33, "button2x2") do
      $game.state.start("Game2x2")
    end
    @button22.anchor.set(0.5, 0.5)

    @button44 = $game.add.button($size_x*0.5, $size_y*0.50, "button4x4") do
      $game.state.start("Game4x4")
    end
    @button44.anchor.set(0.5, 0.5)

    @button66 = $game.add.button($size_x*0.5, $size_y*0.67, "button6x6") do
      $game.state.start("Game6x6")
    end
    @button66.anchor.set(0.5, 0.5)
  end
end

$game.state.add("Menu", MenuState.new, true)
$game.state.add("Game2x2", GameState.new(2,2))
$game.state.add("Game4x4", GameState.new(4,4))
$game.state.add("Game6x6", GameState.new(6,6))
