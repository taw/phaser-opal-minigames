require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

# javascript classes are open, so this kind of hack is normal there
# it's fairly weird in ruby
class Phaser::Sprite
  attr_accessor :c
end

class Board
  attr_reader :matches
  def initialize
    @size_x = 8
    @size_y = 8
    @active = true
    @grid = (0...@size_x).map do |x|
      (0...@size_y).map do |y|
        loc_x = $size_x/2 + 80*(x-3.5)
        loc_y = $size_y/2 + 80*(y-3.5)
        c = $game.rnd.between(0, 6)
        tile = $game.add.sprite(loc_x, loc_y, "cat#{c}")
        tile.c = c
        tile.anchor.set(0.5, 0.5)
        tile.height = 64
        tile.width = 64
        tile
      end
    end
  end

  def set_tile(x,y,c)
    @grid[x][y].c = c
    @grid[x][y].load_texture("cat#{c}")
  end

  def rotate(x, y)
    return unless @active
    t0 = @grid[x][y]
    t1 = @grid[x+1][y]
    t2 = @grid[x+1][y+1]
    t3 = @grid[x][y+1]
    $game.add.tween(t0).to(properties: {x: t0.x+80}, duration: 500, auto_start: true)
    $game.add.tween(t1).to(properties: {y: t1.y+80}, duration: 500, auto_start: true)
    $game.add.tween(t2).to(properties: {x: t2.x-80}, duration: 500, auto_start: true)
    $game.add.tween(t3).to(properties: {y: t3.y-80}, duration: 500, auto_start: true)
    @grid[x][y]     = t3
    @grid[x+1][y]   = t0
    @grid[x+1][y+1] = t1
    @grid[x][y+1]   = t2
    @active = false
    # Same time as animations
    $game.time.events.add(500) do
      @active = true
    end
  end

  def remove_matches
    false
  end

  def find_matches
    @matches = []
    (0...@size_x).each do |x|
      (0...@size_y).each do |y|
        (x+1...@size_x).each do |xx|
          break if @grid[xx][y].c != @grid[x][y].c
          if xx - x >= 3
            @matches.push("#{x},#{y} - #{xx-1},#{y}")
          end
        end
        (y+1...@size_y).each do |yy|
          break if @grid[x][yy].c != @grid[x][y].c
          if yy - y >= 3
            @matches.push("#{x},#{y} - #{x},#{yy-1}")
          end
        end
      end
    end
  end
end

class MainState < Phaser::State
  def preload
    [3, 4, 11, 13, 17, 18, 20].each_with_index do |i,j|
      $game.load.image("cat#{j}", "../images/cat_images/cat#{i}.png")
    end
  end

  def rotation_position
    mx = $game.input.mouse_pointer.worldX
    my = $game.input.mouse_pointer.worldY
    cx = (((mx - $size_x/2) / 80) + 3.5).floor
    cy = (((my - $size_y/2) / 80) + 3.5).floor
    cx = $game.math.clamp(cx, 0, 6)
    cy = $game.math.clamp(cy, 0, 6)
    [cx, cy]
  end

  def update
    (cx, cy) = rotation_position()
    @rotation.x = $size_x/2 + 80*(cx-3)
    @rotation.y = $size_y/2 + 80*(cy-3)
  end

  def create
    $game.stage.background_color = "F88"
    @board = Board.new

    @rotation = $game.add.graphics(0, 0)
    @rotation.line_style(5, 0xFF0000)
    @rotation.draw_circle(0, 0, 160)

    $game.input.on(:tap) do
      (cx, cy) = rotation_position
      @board.rotate(cx, cy)
      @board.find_matches()
      p @board.matches
    end
  end
end
