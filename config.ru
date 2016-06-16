# config.ru
require "bundler"
Bundler.require

opal = Opal::Server.new do |s|
  s.append_path "app"
  s.append_path "assets"
  # s.main = "main"
end

# map opal.source_maps.prefix do
#   run opal.source_maps
# end

map "/assets" do
  run opal.sprockets
end

get "/" do
  send_file "index.html"
end

get "/games/:name" do
  send_file "games/#{params[:name]}.html"
end

run Sinatra::Application
