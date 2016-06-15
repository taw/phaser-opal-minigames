require 'opal'
require 'opal-phaser'

class Game
  def initialize
    run
  end

  def run
    $game = Phaser::Game.new
    state = MainLevel.new($game)
    $game.state.add(:main, state, true)
  end
end

class MainLevel < Phaser::State
  def preload
    $game.load.image("star", "/assets/images/star.png")
  end

  def create
    @star = $game.add.sprite(100, 100, 'star')
  end

  def update
  end
end
