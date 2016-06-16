require "opal"
require "opal-phaser"
require "math"

# This needs to be PRed upstream
module Phaser
  class Time
    alias_native :elapsed
    alias_native :elapsedMS
    alias_native :physicsElapsed
    alias_native :physicsElapsedMS
  end

  class Text
    def x=(x)
      `#@native.x = x`
    end

    def y=(y)
      `#@native.y = y`
    end
  end
end
