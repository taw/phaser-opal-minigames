require "pathname"

class CreateNewGame
  def initialize(title, file_name)
    @title = title
    @file_name = file_name
  end

  def ruby_path
    Pathname("app/#{@file_name}.rb")
  end

  def html_path
    Pathname("games/#{@file_name}.html")
  end

  def index_path
    Pathname("public/index.html")
  end

  def create_ruby_file!
    return if ruby_path.exist?
    ruby_path.write(
'require_relative "common"

class MainState < Phaser::State
end

$game.state.add(:main, MainState.new, true)
')
  end

  def create_html_file!
    return if html_path.exist?
    html_path.write(
%Q[<!DOCTYPE html>
<html>
  <head>
    <meta charset= "utf-8" />
    <title>#{@title}</title>
    <style>
      body {
        margin: 0;
        padding: 0;
        background-color: #000000;
      }
    </style>
    <script src="../js/phaser.js"></script>
    <script src="../assets/#{@file_name}.js"></script>
  </head>

  <body>
    <script>
      window.onload = function() {
        Opal.load("#{@file_name}")
      }
    </script>
  </body>
</html>
]
)
  end

  def index_line
    %Q[           <li><a href="games/#{@file_name}">#{@title}</a></li>\n]
  end

  def add_line_to_index!
    index_path.read
    index_path.write( index_path.read.sub(%r[( *</ul>)]) { index_line + $1 } )
  end

  def run!
    create_ruby_file!
    create_html_file!
    add_line_to_index!
  end
end

desc "Rebuild docs/"
task "docs" do
  system "trash", "docs"
  Pathname("docs").mkpath
  system "cp -a games/ docs/"
  system "cp -a public/* docs/"
  Pathname("docs/assets").mkpath
  Dir["games/*.html"].each do |path|
    n = Pathname(path).basename(".html")
    system "wget http://localhost:9292/assets/#{n}.js -O docs/assets/#{n}.js"
  end
end

desc "Create skeleton for a new game"
task "game", [:name] do |t, args|
  title = args[:name]
  file_name = title.downcase.tr(" ", "_")
  puts "Creating game '#{title}' with file name '#{file_name}'"
  CreateNewGame.new(title, file_name).run!
end
