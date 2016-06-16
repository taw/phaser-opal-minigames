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
    $game.load.image("cat", "/images/cat_images/cat17.png")
    $game.load.image("star", "/images/star-icon.png")
    $game.load.audio("meow", "/audio/cat_meow.mp3")
    $game.load.audio("meow2", "/audio/cat_meow_2.mp3")
  end

  def hit_left_paddle?
    (@left_paddle.y - @ball.y).abs < 65 + 25
  end

  def hit_right_paddle?
    (@right_paddle.y - @ball.y).abs < 65 + 25
  end

  def bounce_left_paddle
    intercept = (@left_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * Math.sqrt(@ball_dx*@ball_dx + @ball_dy*@ball_dy)
    launch_ball(speed, 0 - 45*intercept)
    bounce_effects
  end

  def bounce_right_paddle
    intercept = (@right_paddle.y - @ball.y) / (65 + 25)
    speed = 1.1 * Math.sqrt(@ball_dx*@ball_dx + @ball_dy*@ball_dy)
    launch_ball(speed, 180 + 45*intercept)
    bounce_effects
  end

  def launch_ball(speed, angle)
    @ball_dx = Math.cos($game.math.deg_to_rad(angle)) * speed
    @ball_dy = Math.sin($game.math.deg_to_rad(angle)) * speed
  end

  def bounce_effects
    @emitter.x = @ball.x
    @emitter.y = @ball.y
    @emitter.start true, 5000, nil, 10
    @meow.play()
  end

  def fail_effects
    @meow2.play
    reset_ball()
  end

  def ensure_bounds
    if @ball.x < 65 and @ball_dx < 0
      if hit_left_paddle?
        bounce_left_paddle()
      else
        @right_score_val += 1
        fail_effects()
      end
    end
    if @ball.x > $size_x-65 and @ball_dx > 0
      if hit_right_paddle?
        bounce_right_paddle
      else
        @left_score_val += 1
        fail_effects()
      end
    end
    if @ball.y < 25 and @ball_dy < 0
      @ball_dy = -@ball_dy
    end
    if @ball.y > $size_y-25 and @ball_dy > 0
      @ball_dy = -@ball_dy
    end
  end

  def reset_ball
    @ball.x = $size_x / 2
    @ball.y = $size_y / 2
    if $game.rnd.between(0,1) == 0
      # Right
      angle = $game.rnd.between(-45, 45)
    else
      # Left
      angle = $game.rnd.between(180-45, 180+45)
    end
    launch_ball(300.0, angle)
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

    # score display
    @left_score_val  = 0
    @right_score_val = 0

    @left_score = $game.add.text($size_x / 4, $size_y / 8, @left_score_val, { fontSize: '100px', fill: '#000', align: "center" })
    @left_score.anchor.set(0.5)

    @right_score = $game.add.text($size_x / 4 * 3, $size_y / 8, @right_score_val, { fontSize: '100px', fill: '#000', align: "center" })
    @right_score.anchor.set(0.5)

    # paddles
    @left_paddle = $game.add.graphics(10, $size_y / 2)
    @left_paddle.line_style(5, "white")
    @left_paddle.line_style(0)
    @left_paddle.begin_fill(0x000)
    @left_paddle.draw_rect(0, -65, 30, 130)

    @right_paddle = $game.add.graphics($size_x - 40, $size_y / 2)
    @right_paddle.line_style(5, "white")
    @right_paddle.line_style(0)
    @right_paddle.begin_fill(0x000)
    @right_paddle.draw_rect(0, -65, 30, 130)

    # star emitter
    @emitter = $game.add.emitter(0, 0, 1000)
    @emitter.make_particles('star')
    @emitter.gravity = 200

    # ball
    @ball = $game.add.sprite(0, 0, "cat")
    @ball.height = 50
    @ball.width = 50
    @ball.anchor.set(0.5, 0.5)
    reset_ball

    @meow = $game.add.audio("meow")
    @meow2 = $game.add.audio("meow2")
  end

  def update
    # move paddles up/down
    dt = $game.time.physics_elapsed
    if $game.input.keyboard.down?(`Phaser.KeyCode.W`)
      @left_paddle.y -= dt * 600
    end
    if $game.input.keyboard.down?(`Phaser.KeyCode.S`)
      @left_paddle.y += dt * 600
    end

    if $game.input.keyboard.down?(`Phaser.KeyCode.UP`)
      @right_paddle.y -= dt * 600
    end
    if $game.input.keyboard.down?(`Phaser.KeyCode.DOWN`)
      @right_paddle.y += dt * 600
    end

    # ensure paddle boundaries
    @left_paddle.y  = $game.math.clamp(@left_paddle.y,  75, $size_y - 75)
    @right_paddle.y = $game.math.clamp(@right_paddle.y, 75, $size_y - 75)

    # move ball
    @ball.x += dt * @ball_dx
    @ball.y += dt * @ball_dy

    # ball boundary check
    ensure_bounds

    # udpate scores
    @left_score.text  = @left_score_val
    @right_score.text = @right_score_val
  end
end
