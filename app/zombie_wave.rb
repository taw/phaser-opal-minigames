require_relative "common"

class Monster
  attr_reader :sprite

  def set_state!(state)
    @state = state
    if @state == "pre-appear"
      @delay = rand*2
      @sprite.visible = false
    else
      @sprite.visible = true
      @sprite.animations.play(state)
    end
  end

  def update(dt)
    current = @sprite.animations.current_anim
    case @state
    when "pre-appear"
      @delay -= dt
      set_state! "appear" if @delay < 0
    when "appear"
      return unless current.finished?
      set_state! "walk"
    when "walk"
      @sprite.x += dt * walking_speed_x
      set_state! "walk" if current.finished?
    else
      raie "Unknown state #{@state}"
    end
  end
end

class Zombie < Monster
  def initialize(x,y)
    @sprite = $game.add.sprite(x, y, "zombie")
    @sprite.anchor.set(0.5)
    @sprite.scale.set(0.25)
    @sprite.animations.add("appear", (1..11).to_a, 10, false)
    @sprite.animations.add("attack", (12..18).to_a, 10, false)
    @sprite.animations.add("die", (19..26).to_a, 10, false)
    @sprite.animations.add("idle", (27..32).to_a, 10, false)
    @sprite.animations.add("walk", (33..42).to_a, 10, false)
    @sprite.animations.play("appear")
    set_state! "pre-appear"
  end

  def walking_speed_x
    -40
  end
end

class Skeleton < Monster
  def initialize(x, y)
    @sprite = $game.add.sprite(x, y, "skeleton")
    @sprite.anchor.set(0.5)
    @sprite.scale.set(-0.25, 0.25)
    @sprite.animations.add("appear", (1..10).to_a, 10, false)
    @sprite.animations.add("attack", (11..18).to_a, 10, false)
    @sprite.animations.add("die", (19..26).to_a, 10, false)
    @sprite.animations.add("idle", (27..32).to_a, 10, false)
    @sprite.animations.add("walk", (33..42).to_a, 10, false)
    set_state! "pre-appear"
  end

  def walking_speed_x
    40
  end
end

class MainState < Phaser::State
  def preload
    $game.load.spritesheet("zombie", "../images/characters/zombie.png", 444, 324)
    $game.load.spritesheet("skeleton", "../images/characters/skeleton.png", 456, 384)
  end

  def create
    $game.stage.background_color = "008"
    @zombies = []
    @skeletons = []
    (2..6).each do |i|
      @skeletons << Skeleton.new($size_x * (0.05 + rand*0.2), $size_y * i / 8)
    end
    (2..6).each do |i|
      @zombies << Zombie.new($size_x * (0.95 - rand*0.2), $size_y * i / 8)
    end
  end

  def update
    dt = $game.time.physics_elapsed
    @zombies.each do |z|
      z.update(dt)
    end
    @skeletons.each do |s|
      s.update(dt)
    end
    # animation = %W[appear attack die idle walk]
    # $game.input.on("down") do |pointer, event|
    #   @zombie.sprite.animations.play(animation[@i % 5])
    #   @skeleton.sprite.animations.play(animation[@i % 5])
    #   @i += 1
    # end
  end
end

$game.state.add(:main, MainState.new, true)
