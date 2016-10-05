require_relative "common"
require_relative "shaders/mouse_rays"

class MainState < Phaser::State

  def create
    $game.stage.background_color = "0F8"

    @filter = Phaser::Filter.new($game, nil, ShaderMouseRays)
    @filter.set_resolution($size_x, $size_y)
    @sprite = $game.add.sprite()
    @sprite.width = $size_x
    @sprite.height = $size_y
    @sprite.filters = [ @filter ]
  end

  def update
    @filter.update($game.input.active_pointer)
  end
end

$game.state.add(:main, MainState.new, true)
