require "opal"
require "opal-phaser"
require "opal-browser"
require_relative "upstream_fixes"

# Shared code
$size_x ||= $window.view.width
$size_y ||= $window.view.height
$game ||= Phaser::Game.new(width: $size_x, height: $size_y)
