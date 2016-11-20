require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("sweet-1", "../images/lollipop.png")
    $game.load.image("sweet-2", "../images/icecream.png")
    $game.load.image("sweet-3", "../images/icelolly.png")
    $game.load.image("sweet-4", "../images/cupcake.png")
    $game.load.image("sweet-5", "../images/doughnut.png")

    $game.load.image("fruit-1", "../images/grapes.png")
    $game.load.image("fruit-2", "../images/pineapple.png")
    $game.load.image("fruit-3", "../images/orange.png")
    $game.load.image("fruit-4", "../images/watermelon.png")
    $game.load.image("fruit-5", "../images/cherry.png")
    $game.load.image("fruit-6", "../images/apple.png")
    $game.load.image("fruit-7", "../images/banana2.png")
  end

  def create
    $game.stage.background_color = "8FB"

    @emitter = $game.add.emitter(0, $size_y*0.5, 1000)
    @emitter.make_particles([
        "sweet-1", "sweet-2", "sweet-3", "sweet-4", "sweet-5",
    ])
    @emitter.gravity = 50
    @emitter.maxParticleSpeed.x = 200
    @emitter.minParticleSpeed.x = 300
    @emitter.maxParticleSpeed.y = -150
    @emitter.minParticleSpeed.y = -200
    @emitter.height = $size_y/2
    @emitter.bounce = 1

    $game.physics.arcade.enable(@emitter)
    @emitter.start(false, 10000, 50)
  end

  def update
    $game.physics.arcade.collide(@emitter, @emitter)
  end
end

$game.state.add(:main, MainState.new, true)
