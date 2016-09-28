require_relative "common"
require_relative "capitals"

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

class Question
  def initialize
    @label = $game.add.text(0.5*$size_x, 0.3*$size_y, "", { fontSize: "60px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
  end

  def text=(v)
    @label.text = v
  end
end

class Answer
  attr_accessor :correct
  def initialize(x,y,state)
    @label = $game.add.text(x, y, "", { fontSize: "60px", fill: "#000", align: "center", backgroundColor: "#8AE" })
    @label.anchor.set(0.5)
    @correct = false
    @state = state

    @label.inputEnabled = true
    @label.events.on(:down) do
      @state.answered(@correct)
    end
  end

  def text=(v)
    @label.text = v
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "ABF"
    @score = Score.new
    @question = Question.new
    @answers = [
      Answer.new(0.25*$size_x, 0.5*$size_y, self),
      Answer.new(0.75*$size_x, 0.5*$size_y, self),
      Answer.new(0.25*$size_x, 0.7*$size_y, self),
      Answer.new(0.75*$size_x, 0.7*$size_y, self),
    ]
    new_question
  end

  def answered(correct)
    if correct
      @score.value += 1
    else
      @score.value -= 1
    end
    new_question
  end

  def new_question
    countries = Capitals.sample(4)
    @question.text = "Capital of #{countries[0][1]}"
    @answers.shuffle.each_with_index do |answer, i|
      answer.text = countries[i][0]
      answer.correct = (i == 0)
    end
  end
end
