require_relative "common"

class Raindrop
  def initialize
    @raindrop = $game.add.sprite(
      $game.rnd.between(0,$size_x-24),
      $game.rnd.between(0,$size_x-22),
      "raindrop"
    )
    @speed = $game.rnd.between(100, 200)
  end

  def update(time)
    @raindrop.y += @speed * time
    if @raindrop.y > $size_y-5
      @raindrop.y = 0
    end
  end
end

class Cloud
  def initialize
    @cloud = $game.add.sprite(
      $game.rnd.between(0,$size_x-24),
      $game.rnd.between(0,$size_y/6),
      "cloud"
    )
    @speed = $game.rnd.between(100,200)
  end

  def update(time)
    @cloud.x += @speed * time
    if @cloud.x > $size_x-5
      @cloud.x = -256
    end
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("raindrop", "../images/raindrop.png")
    $game.load.image("cloud", "../images/cloud.png")
  end

  def create
    $game.stage.background_color = "F7825D"
    @elements = 50.times.map do
      Raindrop.new
    end
    @elements += 6.times.map do
      Cloud.new
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @elements.each do |element|
      element.update(dt)
    end
  end
end

$game.state.add(:main, MainState.new, true)
