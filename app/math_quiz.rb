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

class Question
  def initialize
    @label = $game.add.text(0.5*$size_x, 0.3*$size_y, "", { fontSize: "80px", fill: "#000", align: "center" })
    @label.anchor.set(0.5)
  end

  def text=(v)
    @label.text = v
  end
end

class Answer
  attr_accessor :correct
  def initialize(x,y)
    @label = $game.add.text(x, y, "", { fontSize: "80px", fill: "#000", align: "center", backgroundColor: "#8EA" })
    @label.anchor.set(0.5)
    @correct = false
  end

  def text=(v)
    @label.text = v
  end
end

class MainState < Phaser::State
  def create
    $game.stage.background_color = "AFB"
    @score = Score.new
    @question = Question.new
    @answers = [
      Answer.new(0.25*$size_x, 0.5*$size_y),
      Answer.new(0.75*$size_x, 0.5*$size_y),
      Answer.new(0.25*$size_x, 0.7*$size_y),
      Answer.new(0.75*$size_x, 0.7*$size_y),
    ]
    new_question
  end

  def new_question
    a = $game.rnd.between(10, 100)
    b = $game.rnd.between(10, 100)
    @question.text = "#{a} + #{b}"
    correct = a + b
    fake_answers = [-12,-11,-10,-2,-1,1,2,10,11,12].map{|fuzz| fuzz+correct}.sample(3)
    @answers.shuffle.each_with_index do |answer, i|
      if i == 3
        answer.text = correct
        answer.correct = true
      else
        answer.text = fake_answers[i]
        answer.correct = false
      end
    end
  end
end
