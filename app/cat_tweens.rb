require_relative "common"

class MainState < Phaser::State
  def preload
    (1..20).each do |i|
      $game.load.image("cat#{i}", "../images/cat_images/cat#{i}.png")
    end
  end

  def rand_x
    $game.rnd.between(100, $size_x - 100)
  end

  def rand_y
    $game.rnd.between(100, $size_y - 100)
  end

  def random_size
    $game.rnd.between(32, 128)
  end

  def create
    $game.stage.background_color = "F88"
    (1..20).each do |i|
      new_cat_and_tween(i)
    end
  end

  def new_tween(cat)
    tween = $game.add.tween(cat)
    tween.on(:complete) do
      new_tween(cat)
    end
    size = random_size
    tween.to(
      properties: {
        x: rand_x,
        y: rand_y,
        height: size,
        width: size,
      },
      duration: $game.rnd.between(500, 5000),
      auto_start: true
    )
  end

  def new_cat_and_tween(i)
    cat = $game.add.sprite(rand_x, rand_y, "cat#{i}")
    cat.anchor.set(0.5, 0.5)
    cat.width = cat.height = random_size
    new_tween(cat)
  end
end

$game.state.add(:main, MainState.new, true)
