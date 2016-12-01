require_relative "common"

class MainState < Phaser::State
  def create
    $game.stage.background_color = 0xfbf6d5

    @text = $game.add.text($game.world.center_x, 250, "  dynamic shadows  ")
    @text.anchor.set(0.5)
    @text.align = "center"

    @text.font = "Arial Black"
    @text.font_size = 70
    @text.font_weight = "bold"
    @text.fill = "#ec008c"

    @text.set_shadow(0, 0, "rgba(0, 0, 0, 0.5)", 0)
  end

  def update
    offset_x, offset_y = move_opposite($game.input.active_pointer, @text, 8)
    distance = distance_between($game.input.active_pointer, @text)
    @text.set_shadow(offset_x, offset_y, "rgba(0, 0, 0, 0.5)", distance / 30)
  end

  def distance_between(source, target)
    ((source.x - target.x) ** 2 + (source.y - target.y) ** 2) ** 0.5
  end

  def move_opposite(source, target, speed)
    angle = Math.atan2(source.y - target.y, source.x - target.y)
    speed = [speed, distance_between(source, target)].min
    [
      -Math.cos(angle) * speed,
      -Math.sin(angle) * speed,
    ]
  end
end

$game.state.add(:main, MainState.new, true)
