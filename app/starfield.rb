require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("star", "../images/star.png")
  end

  def create
    $game.stage.background_color = "008"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @stars = 200.times.map{ new_star }
  end

  def reset_star_position(star)
    star.x = $size_x/2 + $game.rnd.between(-20, 20)
    star.y = $size_y/2 + $game.rnd.between(-20, 20)
  end

  def new_star
    star = $game.add.sprite(0, 0, "star")
    $game.physics.arcade.enable_body(star)
    star.x = $size_y/2 + [1,-1].sample * $game.rnd.between(0, ($size_x/2)**0.5)**2
    star.y = $size_y/2 + [1,-1].sample * $game.rnd.between(0, ($size_y/2)**0.5)**2
    star
  end

  def update
    @stars.each do |star|
      if star.x < 0 or star.y < 0 or star.x >= $size_x or star.y >= $size_y
        reset_star_position(star)
      end
      rx = star.x - $size_x/2
      ry = star.y - $size_y/2
      size = 4 + 60 * [(rx / $size_x).abs, (ry / $size_y).abs].min
      star.body.velocity.x = 1 * (star.x - $size_x/2)
      star.body.velocity.y = 1 * (star.y - $size_y/2)
      star.width = star.height = size
    end
  end
end

$game.state.add(:main, MainState.new, true)
