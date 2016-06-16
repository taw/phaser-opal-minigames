require_relative "common"

class Game
  def initialize
    run
  end

  def run
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    state = MainLevel.new($game)
    $game.state.add(:main, state, true)
  end
end

class Eye
  def initialize(cell_x, cell_y)
    cx = cell_x * $size_x / 4
    cy = cell_y * $size_y / 4

    @x = $game.rnd.between(cx + 50, cx + $size_x / 4 - 50)
    @y = $game.rnd.between(cy + 50, cy + $size_y / 4 - 50)
    @eyesize = $game.rnd.between(50,200)
    @max_eye_movement = @eyesize * 0.2
    @eye = $game.add.graphics(@x, @y)
    @eye.begin_fill(0xFFFFFF)
    @eye.line_style(5, 0x000000, 1)
    @eye.draw_circle(0, 0, @eyesize)
    @eye.end_fill
    @retina = $game.add.graphics(@x, @y)
    @retina.begin_fill(0x000000)
    @retina.line_style(3, 0x000000, 1)
    @retina.draw_circle(0, 0, @eyesize*0.5)
    @retina.end_fill
  end

  def update(mx, my)
    dx = mx - @x
    dy = my - @y
    dl = Math.sqrt(dx*dx + dy*dy)
    if dl > @max_eye_movement
      dx = @max_eye_movement*dx/dl
      dy = @max_eye_movement*dy/dl
    end
    @retina.x = @x + dx
    @retina.y = @y + dy
  end
end

class MainLevel < Phaser::State
  def create
    @game.stage.background_color = "F88"
    @eyes = (0..3).map{|x| (0..3).map{|y| Eye.new(x,y)}}.flatten
  end

  def update
    @eyes.each do |eye|
      eye.update(
        $game.input.active_pointer.worldX,
        $game.input.active_pointer.worldY,
      )
    end
  end
end
