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
    $game.load.image('cat', '/assets/images/cat-cupid-love-icon2.png')
  end

  def create
    $game.stage.background_color = "8FA"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles('cat')
    @emitter.gravity = 200

    $game.input.on("down") do |pointer, event|
      @emitter.x = `pointer.x`
      @emitter.y = `pointer.y`

      # The first parameter sets the effect to "explode" which means all particles are emitted at once
      # The second gives each particle a 2000ms lifespan
      # The third is ignored when using burst/explode mode
      # The final parameter (10) is how many particles will be emitted in this single burst
      @emitter.start true, 5000, nil, 10
    end
  end
end
