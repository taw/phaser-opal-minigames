require "opal"
require "opal-phaser"
require "math"
require "browser"

# This needs to be PRed upstream
module Phaser
  class Time
    alias_native :elapsed
    alias_native :elapsedMS
    alias_native :physicsElapsed
    alias_native :physicsElapsedMS
  end

  class Text
    alias_native :anchor, :anchor, as: Phaser::Point

    def x=(x)
      `#@native.x = x`
    end

    def y=(y)
      `#@native.y = y`
    end

    def angle=(angle)
      `#@native.angle = angle`
    end

    def fill=(fill)
      `#@native.fill = fill`
    end
  end

  class Math
    include Native

    alias_native :deg_to_rad, :degToRad
    alias_native :rad_to_deg, :radToDeg
  end

  class Game
    alias_native :math, :math, as: Phaser::Math
  end
end
