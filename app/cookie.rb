require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("cookie", "../images/cookie.png")
    $game.load.image("banana", "../images/banana.png")
    $game.load.audio("coin", "../audio/balsa.mp3")
  end

  def update
    dt = $game.time.physics_elapsed
    if @cookie.x < 60 or @cookie.x >= $size_x-60
      @dx = -@dx
    end
    if @cookie.y < 60 or @cookie.y >= $size_y-60
      @dy = -@dy
    end
    @cookie.x += @dx*dt
    @cookie.y += @dy*dt
    @scoreText.text = "Score: #{@score}"

    dl = (@dx**2 + @dy**2) ** 0.5

    @cookie_shadow.x = @cookie.x - 10 * @dx/dl
    @cookie_shadow.y = @cookie.y - 10 * @dy/dl
  end

  def create
    $game.stage.background_color = "4993FA"

    @score = 0
    @scoreText = $game.add.text(16, 16, "", { fontSize: "32px", fill: "#fff" })

    @cookie_shadow = $game.add.sprite(0, 0, "cookie")
    @cookie_shadow.tint = 0x000000
    @cookie_shadow.anchor.set(0.5, 0.5)
    @cookie_shadow.alpha = 0.2

    @cookie = $game.add.sprite(
      $game.rnd.between(60, $size_x-60),
      $game.rnd.between(60, $size_y-60),
      "cookie",
    )
    @cookie.anchor.set(0.5, 0.5)

    @coin = $game.add.audio("coin")
    @cookie.input_enabled = true
    @cookie.events.on(:down) do
      @score += 1
      @emitter.x = @cookie.x
      @emitter.y = @cookie.y
      @emitter.start true, 2000, nil, 1
      @coin.play
    end
    angle = $game.math.deg_to_rad($game.rnd.between(0, 360))
    speed = 200.0
    @dx = Math.cos(angle) * speed
    @dy = Math.sin(angle) * speed

    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("banana")
    @emitter.gravity = -50
    @emitter.minParticleSpeed.x = -0.1 * @dx
    @emitter.minParticleSpeed.y = -0.1 * @dy
    @emitter.maxParticleSpeed.x = -0.4 * @dx
    @emitter.maxParticleSpeed.y = -0.4 * @dy
    @emitter.set_alpha(0.5, 0.8, 0)
  end
end

$game.state.add(:main, MainState.new, true)
