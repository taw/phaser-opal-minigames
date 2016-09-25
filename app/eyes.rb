require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Eye
  def initialize(cell_x, cell_y)
    cx = cell_x * $size_x / 4
    cy = cell_y * $size_y / 4
    max_eye_size = [$size_x, $size_y].min / 4.0
    @eyesize = $game.rnd.between(max_eye_size*0.3, max_eye_size*0.8)
    @x = $game.rnd.between(cx + 50, cx + $size_x / 4 - 50)
    @y = $game.rnd.between(cy + 50, cy + $size_y / 4 - 50)
    @max_eye_movement = @eyesize * 0.2
    @eye = $game.add.graphics(@x, @y)
    @eye.begin_fill(0xFFFFFF)
    @eye.line_style(3, 0x000000, 1)
    @eye.draw_circle(0, 0, @eyesize)
    @eye.end_fill
    @retina = $game.add.graphics(@x, @y)
    @retina.begin_fill(rand_retina_color)
    # @retina.line_style(1, 0x000000, 1)
    @retina.draw_circle(0, 0, @eyesize*0.5)
    @retina.end_fill
  end

  def rand_retina_color
    ("%02x%02x%02x" % [
      $game.rnd.between(140, 255),
      $game.rnd.between(90, 140),
      $game.rnd.between(90, 140),
    ]).to_i(16)
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

class MainState < Phaser::State
  def create
    $game.stage.background_color = "F88"
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
