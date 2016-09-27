require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Cat
  def initialize
    @cat = $game.add.sprite($size_x/2, 0, "cat")
  end

  def update(dt)
    @cat.y += dt * 100
  end
end

class Basket
  def initialize
    @basket = $game.add.graphics($size_x/2, $size_y)
    @basket.line_style(5, "white")
    @basket.line_style(0)
    @basket.begin_fill(0x000)
    @basket.draw_rect(-100, -20, 200, 10)
  end

  def update(dt)
    if $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
      @basket.x -= dt * 600
    end
    if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)
      @basket.x += dt * 600
    end
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/cat_images/cat17.png")
  end

  def create
    $game.stage.background_color = "8FB"
    @cat = Cat.new
    @basket = Basket.new
  end

  def update
    dt = $game.time.physics_elapsed
    @cat.update(dt)
    @basket.update(dt)
  end
end
