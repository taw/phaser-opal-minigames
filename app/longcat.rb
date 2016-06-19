require_relative "common"
require "json"

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
    atlas = {
      frames: (0..3).flat_map{|x|
        (0..3).map{|y|
          {
            filename: "longcat_#{x}_#{y}",
            frame: {x:480*x,y:300*y,w:480,h:300},
          }
        }
      }
    }
    $game.load.atlas("longcat", "/images/longcat.jpg", nil, atlas, `Phaser.Loader.TEXTURE_ATLAS_JSON_HASH`)
  end

  def create
    @sprites = []
    4.times do |x|
      4.times do |y|
        longcat = $game.add.sprite($size_x*x/4, $size_y*y/4, "longcat")
        @sprites << longcat
        longcat.width = $size_x/4
        longcat.height = $size_y/4
      end
    end

    $game.input.on("down") do
      shuffle_cats
    end
    shuffle_cats
  end

  def shuffle_cats
    cats = []
    4.times do |x|
      4.times do |y|
        cats << "longcat_#{x}_#{y}"
      end
    end
    cats.shuffle!

    @sprites.each do |longcat|
      longcat.frame_name = cats.shift
    end
  end
end
