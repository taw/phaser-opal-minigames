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
    $game.load.image('cookie', '/assets/images/cookie.png')
  end

  def update
    dt = $game.time.physics_elapsed
    if @cookie.x < 0 or @cookie.x >= $size_x-120
      @dx = -@dx
    end
    if @cookie.y < 0 or @cookie.y >= $size_y-120
      @dy = -@dy
    end
    @cookie.x += @dx*dt
    @cookie.y += @dy*dt
    @scoreText.text = "Score: #{@score}"
  end

  def create
    @score = 0
    @scoreText = $game.add.text(16, 16, '', { fontSize: '32px', fill: '#fff' })
    $game.stage.background_color = "F8F"
    @cookie = $game.add.sprite(
      $game.rnd.between(0, $size_x-120),
      $game.rnd.between(0, $size_y-120),
      'cookie',
    )
    @cookie.input_enabled = true
    @cookie.events.on(:down) do
      @score += 1
    end
    angle = $game.math.deg_to_rad($game.rnd.between(0, 360))
    speed = 200.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed
  end
end
