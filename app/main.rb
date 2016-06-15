require 'opal'
require 'opal-phaser'

# This needs to be PRed upstream
module Phaser
  class Time
    alias_native :elapsed
    alias_native :elapsedMS
    alias_native :physicsElapsed
    alias_native :physicsElapsedMS
  end
end

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
    a = rand* 2 * `Math.PI`
    speed = 200.0
    @dx, @dy = speed * `Math.sin(a)`, speed * `Math.cos(a)`
  end

  def update
    dt = $game.time.physicsElapsed
    @star.x += @dx * dt
    @star.y += @dy * dt
    if @star.x >= 200 or @star.x <= 0
      @dx = -@dx
    end
    if @star.y >= 200 or @star.y <= 0
      @dy = -@dy
    end
  end
end
