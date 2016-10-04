require_relative "common"

class MainState < Phaser::State
  def preload
    $game.load.image("cat", "/images/cat_images/cat17.png")
    $game.load.image("green_box", "/images/green_box.png")
    $game.load.image("star", "/images/star.png")
  end

  def map
    @map ||= """
    ************
    * x        *
    *    **  ***
    ****  *   x*
    * x*  ******
    * **       *
    *     c  x *
    ************
    """.strip.lines.map(&:strip)
  end

  def add_box(x, y)
    box = @boxes.create(x, y, "green_box")
    box.width = @box_x_size
    box.height = @box_y_size
    box.anchor.set(0.5)
    box.body.immovable = true
  end

  def add_star(x, y)
    star = @stars.create(x, y, "star")
    star.anchor.set(0.5)
    star.width = @box_x_size/2
    star.height = @box_y_size/2
    star.body.immovable = true
  end

  def add_cat(x, y)
    @cat = $game.add.sprite(x, y, "cat")
    @cat.anchor.set(0.5)
    @cat.width = @box_x_size/2
    @cat.height = @box_y_size/2

  end

  def setup_map
    @boxes = $game.add.group()
    @boxes.enable_body = true
    @box_x_size = $size_x / map[0].size
    @box_y_size = $size_y / map.size

    @stars = $game.add.group()
    @stars.enable_body = true

    map.each_with_index do |row, y|
      row.chars.each_with_index do |cell, x|
        sx, sy = (x+0.5)*@box_x_size, (y+0.5)*@box_y_size
        case cell
        when "*"
          add_box(sx, sy)
        when "x"
          add_star(sx, sy)
        when "c"
          add_cat(sx, sy)
        end
      end
    end
  end

  def create
    $game.stage.background_color = "88F"
    $game.physics.start_system(Phaser::Physics::ARCADE)
    @cursors = $game.input.keyboard.create_cursor_keys
    setup_map
  end

  def update
  end
end

$game.state.add(:main, MainState.new, true)
