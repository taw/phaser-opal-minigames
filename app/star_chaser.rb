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
    $game.load.image("star", "/images/star.png")
    $game.load.image("chaser", "/images/cat-cupid-love-icon2.png")
    $game.load.audio("coin", "/audio/coin4.mp3")
  end

  def add_star(x=nil,y=nil)
    x ||= $game.rnd.between(20, $size_x - 20)
    y ||= $game.rnd.between(20, $size_y - 20)
    star = @star_group.create(x, y, "star")
    star.body.immovable = true
    @stars << star
  end

  def eat_star(star)
    star.kill
    # identity not preserved here :-/
    @stars.delete_if{|s| s.x == star.x and s.y == star.y}
    @coin.play
  end

  def create
    $game.stage.background_color = "AAF"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @star_group = $game.add.group
    @star_group.enable_body = true
    @stars = []

    10.times do
      add_star
    end

    $game.input.on("down") do |pointer, event|
      add_star(`pointer.x`, `pointer.y`)
    end

    @chaser = $game.add.sprite(20, $size_y/2, "chaser")
    $game.physics.enable(@chaser, Phaser::Physics::ARCADE)
    @chaser.body.collide_world_bounds = true

    @coin = $game.add.audio("coin")
  end

  def clamped_vector(a, b, max_len)
    return [0,0] if b == nil
    dx = b.x - a.x
    dy = b.y - a.y
    l = (dx**2 + dy**2) ** 0.5
    dx = dx*max_len/l
    dy = dy*max_len/l
    [dx, dy]
  end

  def update
    nearest_star = @stars.min_by{|star|
      (star.x - @chaser.x) ** 2 + (star.y - @chaser.y) ** 2
    }
    dx,dy = clamped_vector(@chaser, nearest_star, 200.0)
    @chaser.body.velocity.x = dx
    @chaser.body.velocity.y = dy
    $game.physics.arcade.overlap(@chaser, @star_group) do |c,s|
      eat_star(s)
    end
  end
end