require_relative "common"

class Game
  def initialize
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Paddle
  def initialize(position)
    @paddle = $game.add.graphics(position, $size_y / 2)
    @paddle.begin_fill(0x000)
    @paddle.draw_rect(0, -65, 30, 130)
  end

  def hit?(ball)
    (@paddle.y - ball.y).abs < 65 + 25
  end

  def y
    @paddle.y
  end

  def y=(v)
    # ensure paddle boundaries
    @paddle.y  = $game.math.clamp(v,  75, $size_y - 75)
  end
end

class Ball
  def initialize(state)
    @ball = $game.add.sprite(0, 0, "cat")
    @ball.height = 50
    @ball.width = 50
    @ball.anchor.set(0.5, 0.5)
    @state = state
    reset!
  end

  def launch!(speed, angle)
    @dx = Math.cos($game.math.deg_to_rad(angle)) * speed
    @dy = Math.sin($game.math.deg_to_rad(angle)) * speed
  end

  def speed
    (@dx**2 + @dy**2)**0.5
  end

  def reset!
    @ball.x = $size_x / 2
    @ball.y = $size_y / 2
    if $game.rnd.between(0,1) == 0
      # Right
      angle = $game.rnd.between(-45, 45)
    else
      # Left
      angle = $game.rnd.between(180-45, 180+45)
    end
    launch!(300.0, angle)
  end

  def x
    @ball.x
  end

  def y
    @ball.y
  end

  def ball_reached_right_side!
    if @right_paddle.hit?(@ball)
      bounce_right_paddle!
    else
      @left_score.value += 1
      fail_effects!
    end
  end

  def update(dt)
    @ball.x += dt * @dx
    @ball.y += dt * @dy
    if @ball.x < 65 and @dx < 0
      @state.ball_reached_left_side!
    elsif @ball.x > $size_x-65 and @dx > 0
      @state.ball_reached_right_side!
    elsif @ball.y < 25 and @dy < 0
      @dy = -@dy
    elsif @ball.y > $size_y-25 and @dy > 0
      @dy = -@dy
    end
  end
end

class ScoreDisplay
  attr_reader :value
  def initialize(x,y,v=0)
    @label = $game.add.text(x*$size_x, y*$size_y, "", { fontSize: "100px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
    self.value = v
  end

  def value=(v)
    @value = v
    @label.text = @value
  end
end

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/cat_images/cat17.png")
    $game.load.image("star", "/images/star-icon.png")
    $game.load.audio("meow", "/audio/cat_meow.mp3")
    $game.load.audio("meow2", "/audio/cat_meow_2.mp3")
  end

  def create
    $game.stage.background_color = "AAFFAA"
    @grid = $game.add.graphics($size_x / 2, $size_y / 2)
    @grid.line_style(5, "white")

    # middle dashed vertical line
    (-$size_y/2..$size_y/2).step(20) do |y|
      @grid.move_to(0, y)
      @grid.line_to(0, y + 10)
    end

    @left_score = ScoreDisplay.new(0.25, 0.125)
    @right_score = ScoreDisplay.new(0.75, 0.125)

    @left_paddle = Paddle.new(10)
    @right_paddle = Paddle.new($size_x - 40)

    # star emitter
    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles("star")
    @emitter.gravity = 200

    @ball = Ball.new(self)
    @meow = $game.add.audio("meow")
    @meow2 = $game.add.audio("meow2")
  end

  def bounce_effects!
    @emitter.x = @ball.x
    @emitter.y = @ball.y
    @emitter.start true, 5000, nil, 10
    @meow.play
  end

  def fail_effects!
    @meow2.play
    @ball.reset!
  end

  def bounce_left_paddle!
    intercept = (@left_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * @ball.speed
    @ball.launch!(speed, 0 - 45*intercept)
    bounce_effects!
  end

  def bounce_right_paddle!
    intercept = (@right_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * @ball.speed
    @ball.launch!(speed, 180 + 45*intercept)
    bounce_effects!
  end

  def ball_reached_left_side!
    if @left_paddle.hit?(@ball)
      bounce_left_paddle!
    else
      @right_score.value += 1
      fail_effects!
    end
  end

  def ball_reached_right_side!
    if @right_paddle.hit?(@ball)
      bounce_right_paddle!
    else
      @left_score.value += 1
      fail_effects!
    end
  end

  def update
    # move paddles up/down
    dt = $game.time.physics_elapsed
    if $game.input.keyboard.down?(`Phaser.KeyCode.W`)
      @left_paddle.y -= dt * 600
    elsif $game.input.keyboard.down?(`Phaser.KeyCode.S`)
      @left_paddle.y += dt * 600
    end

    if $game.input.keyboard.down?(`Phaser.KeyCode.UP`)
      @right_paddle.y -= dt * 600
    elsif $game.input.keyboard.down?(`Phaser.KeyCode.DOWN`)
      @right_paddle.y += dt * 600
    end

    @ball.update(dt)
  end
end
