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
  def update_label(label, distance, angle_ratio)
    angle_deg = 360 * angle_ratio
    a = $game.math.deg_to_rad(angle_deg)
    label.x = $size_x / 2 + distance * Math.sin(a)
    label.y = $size_y / 2 - distance * Math.cos(a)
    label.angle = angle_deg
    if a == 0
      label.fill = "#44ff00"
      label.fontSize = 15
    else
      label.fill = "#ff0044"
      label.fontSize = 10
    end
  end

  def create_label(i)
    text = $game.add.text(0, 0, "#{i}", { font: "10px Arial", fill: "#ff0044", align: "center" })
    text.anchor.set(0.5)
    text
  end

  def create
    @last_time = nil
    $game.stage.background_color = "88F"
    @hours   = 24.times.map{|i| create_label(i) }
    @minutes = 60.times.map{|i| create_label(i) }
    @seconds = 60.times.map{|i| create_label(i) }

    @screen_size = [$size_x, $size_y].min
  end

  def update
    time = Time.new
    return if @last_time and time.to_i == @last_time.to_i
    @last_time = time

    @seconds.each_with_index do |s,i|
      update_label @seconds[i], 0.40*@screen_size, (i - time.sec)/60.0
    end

    @minutes.each_with_index do |s,i|
      update_label @minutes[i], 0.30*@screen_size, (i - time.min)/60.0
    end

    @hours.each_with_index do |s,i|
      update_label @hours[i], 0.20*@screen_size, (i - time.hour)/24.0
    end
  end
end
