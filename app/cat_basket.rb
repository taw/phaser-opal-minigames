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
    @cat = $game.add.sprite(0, 0, "cat")
    @cat.anchor.set(0.5, 0.5)
    send_new_cat!
  end

  def send_new_cat!
    @cat.x = $game.rnd.between(100, $size_x-100)
    @cat.y = 0
  end

  def update(dt)
    @cat.y += dt * 250
  end

  def x
    @cat.x
  end

  def y
    @cat.y
  end
end

class Basket
  def initialize
    @basket = $game.add.sprite($size_x/2, $size_y, "basket")
    @basket.anchor.set(0.5, 0.7)
  end

  def update(dt)
    if $game.input.keyboard.down?(`Phaser.KeyCode.LEFT`)
      @basket.x -= dt * 600
    end
    if $game.input.keyboard.down?(`Phaser.KeyCode.RIGHT`)
      @basket.x += dt * 600
    end
    @basket.x = $game.math.clamp(@basket.x, 110, $size_x-110)
  end

  def x
    @basket.x
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/happy_cat.png")
    $game.load.image("basket", "/images/basket.png")
    $game.load.audio("meow2", "/audio/cat_meow_2.mp3")
    $game.load.audio("coin", "/audio/coin4.mp3")
  end

  def create
    @coin = $game.add.audio("coin")
    @meow = $game.add.audio("meow2")
    $game.stage.background_color = "8FB"
    @score_val = 0
    @score = $game.add.text($size_x / 8, $size_y / 8, @score_val, { fontSize: "100px", fill: "#000", align: "center" })
    @score.anchor.set(0.5)
    @basket = Basket.new
    @cat = Cat.new
  end

  def cat_in_basket!
    @score_val += 1
    @coin.play
    @cat.send_new_cat!
  end

  def cat_fell_out!
    @score_val -= 1
    @meow.play
    @cat.send_new_cat!
  end

  def update
    dt = $game.time.physics_elapsed
    @cat.update(dt)
    @basket.update(dt)
    if @cat.y >= $size_y-10
      if (@cat.x - @basket.x).abs <= 100
        cat_in_basket!
      else
        cat_fell_out!
      end
    end
    @score.text  = @score_val
  end
end
