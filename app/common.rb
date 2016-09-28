require "opal"
require "opal-phaser"
require "browser"

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
  class Text
    native_accessor :fontSize
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
end
