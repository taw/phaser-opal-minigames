require_relative "common"

class Game
  def initialize
    run
  end

  def run
    $size_x = `window.innerWidth`
    $size_y = `window.innerHeight`
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    state = MainLevel.new($game)
    $game.state.add(:main, state, true)
  end
end

class MainLevel < Phaser::State
  def preload
    $game.load.image("star", "/assets/images/star.png")
  end

  def create
    @star = $game.add.sprite(rand*$size_x, rand*$size_y, 'star')
    a = rand * 2 * Math::PI
    speed = 500.0
    @dx, @dy = speed * Math.sin(a), speed * Math.cos(a)
  end

  def update
    dt = $game.time.physicsElapsed
    @star.x += @dx * dt
    @star.y += @dy * dt
    if @star.x >= $size_x-24 or @star.x <= 0
      @dx = -@dx
    end
    if @star.y >= $size_y-22 or @star.y <= 0
      @dy = -@dy
    end
  end
end
