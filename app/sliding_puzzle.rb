require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Tile
  attr_accessor :c, :tile
  def initialize(x, y, c)
    @c = c
    @bg = $game.add.graphics(x, y)
    @bg.line_style(2, 0x000000, 1)
    @bg.draw_polygon(
      -96, -54,
      -96,  54,
       96,  54,
       96, -54,
      -96, -54,
    )
    if c == 15
      @tile = $game.add.text(x, y, "")
    else
      @tile = $game.add.sprite(x, y, "tile#{c}")
      @tile.height = 108
      @tile.width = 192
    end
    @tile.anchor.set(0.5, 0.5)
  end
end

class Board
  attr_reader :game_won, :size_x, :size_y
  def initialize
    @size_x = 4
    @size_y = 4
    if true # Normal mode
      tiles = (0..15).to_a.shuffle
    else # Debug mode
      tiles = [0,4,8,12,1,5,9,13,2,6,10,14,3,7,15,11]
    end
    @content = (0...@size_x).map{
      (0...@size_y).map{ tiles.shift }
    }
    setup_grid
    @status = "ready"
    @game_won = false
  end

  def click_cell(x,y)
    # check 4 surrounding tiles
    [[x-1,y], [x+1,y], [x,y-1], [x,y+1]].each do |xx,yy|
      next if xx < 0 or yy < 0 or xx >= @size_x or yy >= @size_y
      if @grid[xx][yy].c == 15
        flip_cells(@grid[x][y], @grid[xx][yy])
        check_if_completed()
        return true
      end
    end
    false
  end

  def keyboard_move_cell(dx,dy)
    empty_x = nil
    empty_y = nil
    (0...@size_x).each do |x|
      (0...@size_y).each do |y|
        if @grid[x][y].c == 15
          empty_x = x
          empty_y = y
        end
      end
    end
    x = empty_x - dx
    y = empty_y - dy
    return false if x < 0 or y < 0 or x >= @size_x or y >= @size_y
    return click_cell(x,y)
  end

  def flip_cells(a,b)
    a.c, b.c = b.c, a.c
    a.tile, b.tile = b.tile, a.tile
    a.tile.x, a.tile.y, b.tile.x, b.tile.y = b.tile.x, b.tile.y, a.tile.x, a.tile.y
  end

  def check_if_completed(x,y)
    if @grid.map{|row| row.map(&:c) } == [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]]
      @game_won = true
    end
  end

  def setup_grid
    @grid = (0...@size_x).map do |x|
      (0...@size_y).map do |y|
        loc_x = ($size_x/2 - 192*1.5) + 192 * x
        loc_y = ($size_y/2 - 108*1.5) + 108 * y
        Tile.new(loc_x, loc_y, @content[x][y])
      end
    end
  end
end

class MainState < Phaser::State
  def update
    if @board.game_won
      @scoreText.text = "Completed in #{@score} moves!"
    else
      @scoreText.text = "Clicks: #{@score}"
    end
  end

  def preload
    16.times do |i|
      $game.load.image("tile#{i}", "../images/sliding_puzzle/tile#{i}.jpg")
    end
  end

  def create
    @score = 0
    @scoreText = $game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    $game.stage.background_color = "F88"
    @board = Board.new
    $game.input.on(:down) do |pointer, ev|
      click(`pointer.x`, `pointer.y`)
    end

    left_key  = $game.input.keyboard.add_key(`Phaser.KeyCode.LEFT`)
    left_key.on(:down) do
      break if @board.game_won
      @score += 1 if @board.keyboard_move_cell(-1,0)
    end

    right_key = $game.input.keyboard.add_key(`Phaser.KeyCode.RIGHT`)
    right_key.on(:down) do
      break if @board.game_won
      @score += 1 if @board.keyboard_move_cell(1,0)
    end

    up_key = $game.input.keyboard.add_key(`Phaser.KeyCode.UP`)
    up_key.on(:down) do
      break if @board.game_won
      @score += 1 if @board.keyboard_move_cell(0,-1)
    end

    down_key = $game.input.keyboard.add_key(`Phaser.KeyCode.DOWN`)
    down_key.on(:down) do
      break if @board.game_won
      @score += 1 if @board.keyboard_move_cell(0,1)
    end
  end

  def click(x,y)
    return if @board.game_won
    x = ((x - $size_x / 2 + 192*1.5) / 192).round
    y = ((y - $size_y / 2 + 108*1.5) / 108).round
    if x >= 0 and x <= @board.size_x-1 and y >= 0 and y <= @board.size_y-1
      if @board.click_cell(x,y)
        @score += 1
      end
    end
  end
end
