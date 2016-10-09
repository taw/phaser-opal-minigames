# Newer version of opal has a (fancier) version of this functionality implemented
# So this can be removed eventually
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

# PR this
module Phaser
  class Sprite
    alias_native :add_child, :addChild
    native_accessor :angle
    native_accessor :frame
  end

  class Text
    native_accessor :fontSize
    native_accessor :font
    alias_native :events, as: Phaser::Events
    native_accessor :inputEnabled
  end

  class Emitter
    alias_native :set_alpha, :setAlpha
  end

  class Sound
    native_accessor :volume
    native_accessor :mute
    native_accessor :loop
  end

  class StateManager
    alias_native :restart
  end

  class Pointer
    native_accessor :worldX
    native_accessor :worldY
  end

  class Timer
    alias_native :add
  end

  class Physics::Arcade::Body
    alias_native :on_floor?, :onFloor
  end

  class Physics::Arcade
    alias_native :enable_body, :enableBody
  end

  # This "breaks" demo in phaser repo
  class CursorKeys
    include Native
    alias_native :left, as: Key
    alias_native :right, as: Key
    alias_native :up, as: Key
    alias_native :down, as: Key
  end

  class Keyboard
     alias_native :create_cursor_keys, :createCursorKeys, as: CursorKeys
  end

  class Filter
    include Native
    alias_native :set_resolution, :setResolution
    alias_native :update

    def initialize(game, uniforms, source)
      @native = `new Phaser.Filter(#{game.to_n}, #{uniforms.to_n}, #{source.to_n})`
    end
  end

  class Physics::Arcade::Body
    alias_native :blocked
  end
end
