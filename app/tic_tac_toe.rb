require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class MainState < Phaser::State
  def create
    @winner = nil
    @winnerText = $game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    @content = (0..2).map{ (0..2).map{ "?" }}
    @content_cells = (0..2).map{|x| (0..2).map{|y| new_cell(x,y) }}
    $game.stage.background_color = "F88"
    @grid = $game.add.graphics($size_x / 2, $size_y / 2)
    @grid.line_style(5, "red")
    @grid.move_to(-300,  100)
    @grid.line_to( 300,  100)
    @grid.move_to(-300, -100)
    @grid.line_to( 300, -100)
    @grid.move_to(-100, -300)
    @grid.line_to(-100,  300)
    @grid.move_to( 100, -300)
    @grid.line_to( 100,  300)
    @grid.end_fill()
    $game.input.on(:down) do |pointer, ev|
      click `pointer.x`, `pointer.y`
    end
  end

  def new_cell(x,y)
    text = $game.add.text($size_x/2 - 200 + 200*x, $size_y/2 - 200 + 200*y, "",
      { font: "64px Arial", fill: "000", align: "center" })
    text.anchor.set(0.5)
    text
  end

  def click(x,y)
    if @winner == nil
      cell_x = ((x - $size_x / 2 + 300) / 200).floor
      cell_y = ((y - $size_y / 2 + 300) / 200).floor
      p [x,y,cell_x,cell_y]
      if (0..2).include?(cell_x) and (0..2).include?(cell_y)
        click_cell(cell_x, cell_y)
      end
    else
      $game.state.restart
    end
  end

  def click_cell(x,y)
    return if @winner != nil
    if @content[x][y] == "?"
      @content[x][y] = "X"
      check_who_won()
      ai_movement()
      check_who_won()
    end
  end

  def ai_movement
    return if @winner != nil
    while true
      x = $game.rnd.between(0,2)
      y = $game.rnd.between(0,2)
      if @content[x][y] == "?"
        @content[x][y] = "O"
        break
      end
    end
  end

  def update
    (0..2).each do |x|
      (0..2).each do |y|
        @content_cells[x][y].text = @content[x][y]
      end
    end
    case @winner
    when "X"
      @winnerText.text = "X won"
    when "O"
      @winnerText.text = "O won"
    when "Draw"
      @winnerText.text = "DRAW"
    else
      @winnerText.text = "Game goes on"
    end
  end

  def check_who_won
    lines = [
      [[0,0], [1,0], [2,0]],
      [[0,1], [1,1], [2,1]],
      [[0,2], [1,2], [2,2]],
      [[0,0], [0,1], [0,2]],
      [[1,0], [1,1], [1,2]],
      [[2,0], [2,1], [2,2]],
      [[0,0], [1,1], [2,2]],
      [[2,0], [1,1], [0,2]],
    ]
    lines.each do |line|
      values = line.map{|x,y| @content[y][x]}
      @winner = "X" if values == ["X", "X", "X"]
      @winner = "O" if values == ["O", "O", "O"]
    end
    if @winner == nil
      @winner = "Draw"
      (0..2).each do |y|
        (0..2).each do |x|
          @winner = nil if @content[y][x] == "?"
        end
      end
    end
  end
end
