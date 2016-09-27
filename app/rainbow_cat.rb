require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end


class MainState < Phaser::State
  def preload
    $game.load.image('cat', '/images/cat_images/cat4.png')
    $game.load.audio("nyan", "/audio/nyan.mp3")
  end

  def create
    $game.stage.background_color = "008"
    @cat = @cookie = $game.add.sprite($size_x/2, $size_y/2, "cat")
    @cat.anchor.set(0.5, 0.5)
    @nyan_music = $game.add.audio("nyan")
    @nyan_music.play
    @nyan_music.loop = true
  end
end
