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
end
