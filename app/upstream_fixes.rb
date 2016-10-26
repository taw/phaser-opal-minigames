# Newer version of opal has a (fancier) version of this functionality implemented
# So this can be removed eventually
# Hacky version below copied from rubinius
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
    native_accessor :name
    native_accessor_alias :fixed_to_camera, :fixedToCamera
    native_accessor_alias :hit_area, :hitArea
  end

  class Text
    native_accessor :font, :stroke
    native_accessor_alias :font_size, :fontSize
    native_accessor_alias :stroke_thickness, :strokeThickness
    native_accessor_alias :fixed_to_camera, :fixedToCamera
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

  # This is basic browser class, not part of phaser
  # https://developer.mozilla.org/en/docs/Web/API/MouseEvent
  class MouseEvent
    include Native
    alias_native :client_x, :clientX
    alias_native :client_y, :clientY
    alias_native :movement_x, :movementX
    alias_native :movement_y, :movementY
    alias_native :offset_x, :offsetX
    alias_native :offset_y, :offsetY
    alias_native :page_x, :pageX
    alias_native :page_y, :pageY
    alias_native :x
    alias_native :y

    alias_native :region
    alias_native :target
    alias_native :current_target, :currentTarget
    alias_native :related_target, :relatedTarget
    alias_native :screen_x, :screenX
    alias_native :screen_y, :screenY

    alias_native :alt_key, :altKey
    alias_native :shift_key, :shiftKey
    alias_native :meta_key, :metaKey
    alias_native :which
    alias_native :button
    alias_native :buttons

    alias_native :timestamp, :timeStamp
    alias_native :webkit_force, :webkitForce

    alias_native :prevent_default, :preventDefault
  end

  class Pointer
    alias_native :x
    alias_native :y
  end

  class Rope
    include Native
    # This is bad wrapper and would be nice to make it better
    native_accessor :updateAnimation
    alias_native :points
  end

  class GameObjectFactory
    alias_native :rope, :rope, as: Rope
    alias_native :bitmap_text, :bitmapText
  end

  class ScaleManager
    native_accessor_alias :page_align_horizontally, :pageAlignHorizontally
    native_accessor_alias :page_align_vertically, :pageAlignVertically
  end

  class Loader
    alias_native :bitmap_font, :bitmapFont
  end

  class Input
    def on(type, &block)
      cast_and_yield = proc do |pointer, event|
        pointer = Phaser::Pointer.new(pointer)
        event = event && Phaser::MouseEvent.new(event)
        block.call(pointer, event)
      end
      case type.to_sym
      when :down
        `#@native.onDown.add(#{cast_and_yield.to_n})`
      when :up
        `#@native.onUp.add(#{cast_and_yield.to_n})`
      when :tap
        `#@native.onTap.add(#{cast_and_yield.to_n})`
      when :hold
        `#@native.onHold.add(#{cast_and_yield.to_n})`
      else
        raise ArgumentError, "Unrecognized event type #{type}"
      end
    end
    alias_native :active_pointer, :activePointer
  end
end
