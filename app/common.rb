require "opal"
require "opal-phaser"
require "browser"

# This needs to be PRed upstream
module Phaser
  class Time
    alias_native :elapsed
    alias_native :elapsed_ms, :elapsedMS
    alias_native :physics_elapsed, :physicsElapsed
    alias_native :physics_elapsed_ms, :physicsElapsedMS
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

  class Graphics
    include Native
    alias_native :begin_fill, :beginFill
    alias_native :end_fill, :endFill
    alias_native :draw_circle, :drawCircle
    alias_native :line_style, :lineStyle
    def x=(x)
      `#@native.x = x`
    end
    def y=(y)
      `#@native.y = y`
    end
  end

  class Emitter
    include Native
    alias_native :make_particles, :makeParticles
    alias_native :start
    def gravity=(gravity)
      `#@native.gravity = gravity`
    end
    def x=(x)
      `#@native.x = x`
    end
    def y=(y)
      `#@native.y = y`
    end
  end

  class Input
    # This needs to raise exception on unknown events
    def on(type, &block)
      puts [:ion, type]
      if block_given?
        case type.to_sym
        when :down
          `#@native.onDown.add(#{block.to_n})`
        when :up
          `#@native.onUp.add(#{block.to_n})`
        when :tap
          `#@native.onTap.add(#{block.to_n})`
        when :hold
          `#@native.onHold.add(#{block.to_n})`
        else
          raise ArgumentError, "Unrecognized event type #{type}"
        end
      else
        # ???
        Signal.new
      end
    end
  end

  class Events
    def on(type, context, &block)
      puts [:ev, type]
      case type.to_sym
      when :up
        `#@native.onInputUp.add(#{block.to_n}, #{context})`
      when :down
        `#@native.onInputDown.add(#{block.to_n}, #{context})`
      when :out
        `#@native.onInputOut.add(#{block.to_n}, #{context})`
      when :over
        `#@native.onInputOver.add(#{block.to_n}, #{context})`
      when :out_of_bounds
        `#@native.onOutOfBounds.add(#{block.to_n}, #{context})`
      else
        raise ArgumentError, "Unrecognized event type #{type}"
      end
    end
  end

  class Game
    alias_native :math, :math, as: Phaser::Math
  end

  class GameObjectFactory
    alias_native :graphics, :graphics, as: Phaser::Graphics
    alias_native :emitter, :emitter, as: Phaser::Emitter
  end
end
