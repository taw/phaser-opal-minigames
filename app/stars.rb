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

class Star
  def initialize
    @star = $game.add.sprite(rand*($size_x-24), rand*($size_y-22), 'star')
    a = rand * 2 * Math::PI
    speed = 500.0
    @dx, @dy = speed * Math.sin(a), speed * Math.cos(a)
  end

  def update(dt)
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

class MainLevel < Phaser::State
  def preload
    $game.load.image("star", "/assets/images/star.png")
  end

  def create
    @elements = 10.times.map do
      Star.new
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @elements.each do |element|
      element.update(dt)
    end
  end
end
