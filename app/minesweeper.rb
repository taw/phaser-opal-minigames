require_relative "common"

class Cell
  attr_reader :revealed, :marked_mine
  def initialize(x,y,c)
    @x = x
    @y = y
    @c = c
    @marked_mine = false
    @revealed = false
    @grid_hidden = $game.add.graphics(@x, @y)
    @grid_hidden.line_style(2, 0x000000, 1)
    @grid_hidden.begin_fill(0x888888)
    @grid_hidden.draw_rect(-20, -20, 40, 40)

    @grid_visible = $game.add.graphics(@x, @y)
    @grid_visible.line_style(2, 0x000000, 1)
    if @c == "X"
      @grid_visible.begin_fill(0xFFAAAA)
    else
      @grid_visible.begin_fill(0xAAAAAA)
    end
    @grid_visible.draw_rect(-20, -20, 40,  40)
    @grid_visible.visible = false

    label = @c
    style = {align: "center", fontSize: "16px"}
    case @c
    when 0
      label = ""
    when 1, 5
      style["fill"] = "#0000FF"
    when 2, 6
      style["fill"] = "#00FF00"
    when 3, 7
      style["fill"] = "#FF0000"
    when 4, 8
      style["fill"] = "#FF00FF"
    end
    @text = $game.add.text(@x, @y, label, style)
    @text.anchor.set(0.5)
    @text.visible = false

    @mine_mark = $game.add.text(@x, @y, "M", style)
    @mine_mark.anchor.set(0.5)
    @mine_mark.visible = false
  end

  def reveal
    @revealed = true
    @text.visible = true
    @grid_hidden.visible = false
    @grid_visible.visible = true
  end

  def flip_mine_mark
    @marked_mine = !@marked_mine
    @mine_mark.visible = !@mine_mark.visible
  end

  def empty?
    @c == 0
  end
end

class Board
  attr_reader :size_x, :size_y, :grid
  def initialize
    @size_x = 10
    @size_y = 10
    @mines = 10
    @content = (0...@size_x).map{|x| (0...@size_y).map{|y| nil}}
    setup_mines
    setup_numbers
    setup_grid
  end

  def auto_propagate_reveal(x, y)
    return if x < 0 or x >= @size_x
    return if y < 0 or y >= @size_y
    return if @grid[x][y].revealed
    click_cell(x,y)
  end

  def click_cell(x,y)
    return if @grid[x][y].revealed
    return if @grid[x][y].marked_mine
    @grid[x][y].reveal()
    if @grid[x][y].empty?
      auto_propagate_reveal(x-1, y-1)
      auto_propagate_reveal(x-1, y  )
      auto_propagate_reveal(x-1, y+1)
      auto_propagate_reveal(x  , y-1)
      auto_propagate_reveal(x  , y+1)
      auto_propagate_reveal(x+1, y-1)
      auto_propagate_reveal(x+1, y  )
      auto_propagate_reveal(x+1, y+1)
    end
  end

  def right_click_cell(x,y)
    return if @grid[x][y].revealed
    @grid[x][y].flip_mine_mark
  end

  def setup_grid
    @grid = (0...@size_x).map do |x|
      (0...@size_y).map do |y|
        loc_x = ($size_x/2 - 180) + 40 * x
        loc_y = ($size_y/2 - 180) + 40 * y
        Cell.new(loc_x, loc_y, @content[x][y])
      end
    end
  end

  def setup_mines
    mines_left = @mines
    while mines_left > 0
      x = $game.rnd.between(0, @size_x-1)
      y = $game.rnd.between(0, @size_y-1)
      if @content[x][y] == nil
        @content[x][y] = "X"
        mines_left -= 1
      end
    end
  end

  def mines_near_xy(x, y)
    total = 0
    [x-1, x, x+1].each do |xx|
      next if xx < 0 or xx >= @size_x
      [y-1, y, y+1].each do |yy|
        next if yy < 0 or yy >= @size_y
        total += 1 if @content[xx][yy] == "X"
      end
    end
    total
  end

  def setup_numbers
    (0...@size_x).each do |x|
      (0...@size_y).each do |y|
        next if @content[x][y] == "X"
        @content[x][y] = mines_near_xy(x, y)
      end
    end
  end
end

class MainState < Phaser::State
  def preload
    $game.load.audio("meow", "../audio/cat_meow.mp3")
  end

  def click(x, y, right_button)
    x = ((x - $size_x / 2 + 200) / 40).floor
    y = ((y - $size_y / 2 + 200) / 40).floor
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      if right_button
        @board.right_click_cell(x,y)
      else
        @board.click_cell(x,y)
        if @board.grid[x][y].revealed and @board.grid[x][y].c == "X"
          @meow.play()
        end
      end
    end
  end

  def create
    `document.getElementsByTagName("body")[0].oncontextmenu = function(){return false;}`
    @result = $game.add.text(16, 16, "Have fun playing", { fontSize: '32px', fill: '#fff' })
    $game.stage.background_color = "8F8"
    @board = Board.new
    @meow = $game.add.audio("meow")
    $game.input.on(:down) do |pointer, event|
      click(event.x, event.y, event.buttons != 1)
    end
  end
end

$game.state.add(:main, MainState.new, true)
