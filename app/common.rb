require "opal"
require "opal-phaser"
require "browser"

# This needs to be PRed upstream
# Copied from rubinius
class Range
  def step(step_size=1) # :yields: object
    return to_enum(:step, step_size) unless block_given?
    first = @begin
    last = @end

    if step_size.kind_of? Float or first.kind_of? Float or last.kind_of? Float
      # if any are floats they all must be
      begin
        step_size = Float(from = step_size)
        first     = Float(from = first)
        last      = Float(from = last)
      rescue ArgumentError
        raise TypeError, "no implicit conversion to float from #{from.class}"
      end
    else
      step_size = Integer(from = step_size)
      if ! step_size.kind_of? Integer
        raise TypeError, "can't convert #{from.class} to Integer (#{from.class}#to_int gives #{step_size.class})"
      end
    end

    if step_size <= 0
      raise ArgumentError, "step can't be negative" if step_size < 0
      raise ArgumentError, "step can't be 0"
    end

    if first.kind_of?(Float)
      err = (first.abs + last.abs + (last - first).abs) / step_size.abs * Float::EPSILON
      err = 0.5 if err > 0.5
      if @excl
        n = ((last - first) / step_size - err).floor
        n += 1 if n * step_size + first < last
      else
        n = ((last - first) / step_size + err).floor + 1
      end

      i = 0
      while i < n
        d = i * step_size + first
        d = last if last < d
        yield d
        i += 1
      end
    elsif first.kind_of?(Numeric)
      d = first
      while @excl ? d < last : d <= last
        yield d
        d += step_size
      end
    else
      counter = 0
      each do |o|
        yield o if counter % step_size == 0
        counter += 1
      end
    end

    return self
  end
end

# This needs to be PRed upstream
module Phaser
  class Time
    alias_native :elapsed
    alias_native :elapsed_ms, :elapsedMS
    alias_native :physics_elapsed, :physicsElapsed
    alias_native :physics_elapsed_ms, :physicsElapsedMS
  end

  class Button
    alias_native :anchor, :anchor, as: Phaser::Point
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
    def visible=(visible)
      `#@native.visible = visible`
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
    alias_native :draw_polygon, :drawPolygon
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
