require_relative "common"

class Game
  def initialize
    $size_x = $window.view.width
    $size_y = $window.view.height
    $game = Phaser::Game.new(width: $size_x, height: $size_y)
    $game.state.add(:main, MainState.new, true)
  end
end

class Score
  attr_reader :value
  def initialize
    @label = $game.add.text(0.5*$size_x, 0.1*$size_y, "", { fontSize: "80px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
    self.value = 0
  end

  def value=(v)
    @value = v
    @label.text = "Score: #{@value}"
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "AFB"
    @score = Score.new
    new_question
  end

  def new_question
    @question_label = $game.add.text(0.5*$size_x, 0.3*$size_y, "2 + 2 =", { fontSize: "80px", fill: "#000", align: "center" })
    @question_label.anchor.set(0.5)

    @answer_a = $game.add.text(0.25*$size_x, 0.5*$size_y, "3", { fontSize: "80px", fill: "#000", align: "center" })
    @answer_a.anchor.set(0.5)
    @answer_b = $game.add.text(0.75*$size_x, 0.5*$size_y, "4", { fontSize: "80px", fill: "#000", align: "center" })
    @answer_b.anchor.set(0.5)
    @answer_c = $game.add.text(0.25*$size_x, 0.7*$size_y, "5", { fontSize: "80px", fill: "#000", align: "center" })
    @answer_c.anchor.set(0.5)
    @answer_d = $game.add.text(0.75*$size_x, 0.7*$size_y, "6", { fontSize: "80px", fill: "#000", align: "center" })
    @answer_d.anchor.set(0.5)
  end
end
