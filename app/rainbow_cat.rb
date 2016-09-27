require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Star
  def initialize(pos)
    @star = $game.add.sprite(
      pos*$size_x,
      $game.rnd.between(0, $size_y),
      'star'
    )
    @star.anchor.set(0.5, 0.5)
  end

  def update(dt)
    @star.x += dt*100
    if @star.x > $size_x
      @star.x -= $size_x
      @star.y = $game.rnd.between(0, $size_y)
    end
  end
end

class Cat
  def initialize
    @cat = $game.add.sprite(0, 0, "cat")
    @cat.anchor.set(0.5, 0.5)
    @phase = 0
  end

  def update(dt)
    @phase += dt
    @cat.x = ( 0.5 + 0.1 * Math.sin(@phase*2) ) * $size_x
    @cat.y = ( 0.5 + 0.05 * Math.cos(@phase*2) ) * $size_y
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/cat_images/cat4.png")
    $game.load.image("star", "/images/star-icon.png")
    $game.load.audio("nyan", "/audio/nyan.mp3")
  end

  def create
    $game.stage.background_color = "006"
    @nyan_music = $game.add.audio("nyan")
    @nyan_music.play
    @nyan_music.loop = true
    @stars = 50.times.map{|i| Star.new(i/50.0) }
    @cat = Cat.new
  end

  def update
    dt = $game.time.physics_elapsed
    @cat.update(dt)
    @stars.each do |star|
      star.update(dt)
    end
  end
end
