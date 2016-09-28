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
  def create
    $game.stage.background_color = "008"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @stars = 100.times.map{ new_star }
  end

  def reset_star_position(star_sprite)
    star_sprite.x = $size_x/2 + $game.rnd.between(-50, 50)
    star_sprite.y = $size_y/2 + $game.rnd.between(-50, 50)
  end

  def new_star
    star = $game.add.graphics(0, 0)
    star.line_style(0)
    star.begin_fill(0xFFFFEE)
    star.draw_circle(0, 0, 5)
    star_sprite = $game.add.sprite(0,0)
    star_sprite.add_child(star)
    $game.physics.arcade.enable_body(star_sprite)
    star_sprite.x = $game.rnd.between(0, $size_x)
    star_sprite.y = $game.rnd.between(0, $size_y)
    star_sprite
  end

  def update
    @stars.each do |star_sprite|
      star_sprite.body.velocity.x = 1 * (star_sprite.x - $size_x/2)
      star_sprite.body.velocity.y = 1 * (star_sprite.y - $size_y/2)
      if star_sprite.x < 0 or star_sprite.y < 0 or star_sprite.x >= $size_x or star_sprite.y >= $size_y
        reset_star_position(star_sprite)
      end
    end
  end
end
