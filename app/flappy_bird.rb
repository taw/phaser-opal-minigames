$size_x = 288
$size_y = 505
require_relative "common"
# Based on https://github.com/dondonz/dondonz.github.io

class GameOverState < Phaser::State
  def init(score)
    @score = score
  end

  def create
    # Add part of the game world
    $game.add.sprite(0, 0, "bg")
    @platforms = $game.add.group
    @platforms.enable_body = true
    @ground = @platforms.create(0, $game.world.height - 70, "ground")
    @ground.scale.set(1,1)
    @ground.body.immovable = true
    #Create cursors
    @cursors = $game.input.keyboard.create_cursor_keys
    # Press up to retry the game
    @cursors.up.on(:down) { play_again }
    $game.input.on(:down) { play_again }

    # Scoreboard
    display_score = (@score / 17).floor

    # There's probably some ruby interface to this
    if `!!localStorage`
      hi_score = `localStorage.getItem("hi_score")`
      hi_score = 0 if `hi_score === null`
      hi_score = hi_score.to_i
      unless hi_score > display_score
        hi_score = display_score
        `localStorage.setItem("hi_score", hi_score)`
      end
    else
      hi_score = "N/A"
    end

    # Screen text
    $game.add.bitmap_text(50, 50, "flappyfont", "Game Over", 36)
    $game.add.bitmap_text(65,110, "flappyfont", "You scored #{display_score}", 24)
    $game.add.bitmap_text(80,160, "flappyfont", "Hi score #{hi_score}", 24)
    $game.add.bitmap_text(65,250, "flappyfont", "Tap or hit UP", 24)
    $game.add.bitmap_text(70,290, "flappyfont", "to play again", 24)
  end

  def play_again
    $game.state.start(:game)
  end
end

class GameState < Phaser::State
  def preload
    $game.time.advanced_timing = true
  end

  def create
    @music = $game.add.audio("music")
    @music.play

    $game.add.sprite(0,0, "bg")
    @bg_tile = $game.add.tile_sprite(0, 0, 288, 505, "bg")
    @bg_tile.auto_scroll(-50,0)

    @down_pipes = $game.add.group()
    @down_pipes.enable_body = true
    @up_pipes = $game.add.group()
    @up_pipes.enable_body = true

    @platforms = $game.add.group()
    @platforms.enable_body = true
    @ground = @platforms.create(0, $game.world.height - 70, "ground")
    @ground.scale.set(1,1)
    @ground.body.immovable = true
    @ground_tile = $game.add.tile_sprite(0, $game.world.height - 70, 300,100, "ground")
    @ground_tile.auto_scroll(-200,0)

    # Create hidden 1px wall - determines score
    @wall = @platforms.create(115, 0, "wall")
    @wall.scale.set(1,5000)

    @player = $game.add.sprite(100, $game.world.height - 350, "bird");
    $game.physics.arcade.enable(@player)
    @player.body.bounce.y = 0.2
    @player.body.gravity.y = 1500
    @player.body.collide_world_bounds = true
    @player.animations.add("flap", [0,1,2], 1800, true)
    @cursors = $game.input.keyboard.create_cursor_keys

    @score = 0
    @score_text = $game.add.bitmap_text($game.width/2 - 10, 15, "flappyfont", "0", 36)

    $game.time.events.loop(Phaser::Timer::SECOND * 1.5) { spawn_pipe }
  end

  def update
    # Game over if player touches ground or pipes
    $game.physics.arcade.overlap(@player, @ground) { game_over }
    $game.physics.arcade.overlap(@player, @down_pipes) { game_over }
    $game.physics.arcade.overlap(@player, @up_pipes) { game_over }
    # Scoring
    $game.physics.arcade.overlap(@down_pipes, @wall) { add_score }

    @player.body.velocity.x = 0

    #Keyboard and touch control
    if @cursors.up.down? || $game.input.active_pointer.down?
      @player.body.velocity.y = -350
      @player.animations.play("flap")
    else
      @player.animations.stop()
      @player.frame = 1
    end
  end

  def game_over
    @player.kill
    @music.stop
    # Syntax is (name of state to start, clearWorld, clearCache (assets), parameters to pass onto the init function)
    $game.state.start(:game_over, true, false, @score)
  end

  def add_score
    @score += 1
    @score_text.text = (@score / 17).floor
  end

  def tap_check
    @player.body.velocity.y = -350
    @player.animations.play("flap")
  end

  def spawn_pipe
    xcoord = (320)
    ycoord = (-200 + rand*200)
    newPipe = @down_pipes.create(xcoord, ycoord, "down_pipe")
    newPipe.body.gravity.x = -80
    anotherPipe = @up_pipes.create(xcoord, ycoord + 425, "up_pipe")
    anotherPipe.body.gravity.x = -80
  end
end

class PreloadState < Phaser::State
  def preload
    $game.load.image("bg", "../flappy/background.png")
    $game.load.image("ground", "../flappy/ground.png")
    $game.load.spritesheet("bird", "../flappy/bird.png", 34, 24, 3)
    $game.load.image("down_pipe", "../flappy/down_pipe.png")
    $game.load.image("up_pipe", "../flappy/up_pipe.png")
    # Hidden wall to detect score
    $game.load.image("wall", "../flappy/wall.png")
    $game.load.bitmap_font(
      "flappyfont",
      "../flappy/flappyfont.png",
      "../flappy/flappyfont.fnt"
    )
    $game.load.audio("music", ["../audio/nyan.mp3"])
  end

  def create
    $game.state.start(:game)
  end
end

# This is meant mostly for some kind of progress bar
class BootState < Phaser::State
  def create
    $game.scale.page_align_horizontally = true
    $game.scale.page_align_vertically = true
    $game.scale.refresh
    $game.physics.start_system(Phaser::Physics::ARCADE)
    $game.state.start(:preload)
  end
end

$game.state.add(:boot, BootState.new, true)
$game.state.add(:preload, PreloadState.new)
$game.state.add(:game, GameState.new)
$game.state.add(:game_over, GameOverState.new)
