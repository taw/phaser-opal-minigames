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
    $game.load.image("star", "/images/star2.png")
    $game.load.image("cat", "/images/cat-cupid-love-icon2.png")
    $game.load.audio("coin", "/audio/coin4.mp3")
  end

  def create
    $game.stage.background_color = "8FA"
    $game.physics.start_system(Phaser::Physics::ARCADE)

    @emitter2 = $game.add.emitter(0, 0, 1000)
    @emitter2.make_particles("star")
    @emitter2.gravity = -50
    @emitter2.maxParticleSpeed.x = 50
    @emitter2.minParticleSpeed.x = -50
    @emitter2.maxParticleSpeed.y = 50
    @emitter2.minParticleSpeed.y = -50
    @emitter2.set_alpha(0.2, 0.5, 0)

    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("cat")
    @emitter.gravity = 200

    @coin = $game.add.audio("coin")

    $game.input.on("down") do |pointer, event|
      @emitter2.x = `pointer.x`
      @emitter2.y = `pointer.y`
      @emitter2.start true, 2000, nil, 40

      @emitter.x = `pointer.x`
      @emitter.y = `pointer.y`
      # The first parameter sets the effect to "explode" which means all particles are emitted at once
      # The second gives each particle a 2000ms lifespan
      # The third is ignored when using burst/explode mode
      # The final parameter (10) is how many particles will be emitted in this single burst
      @emitter.start true, 5000, nil, 5
      @coin.play
      @coin.volume = 0.2
    end
  end
end
