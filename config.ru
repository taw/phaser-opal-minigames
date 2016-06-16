require "bundler"
Bundler.require

opal = Opal::Server.new do |s|
  s.append_path "app"
  s.append_path "views"
end

# This is dumb, but we need source maps
# To debug, as source map concatenation doesn't work, switch to .html.erb and use code like:
#  <%= javascript_include_tag "cat_pong" %>
Kernel.send(:define_method, :javascript_include_tag) do |name|
  Opal::Sprockets.javascript_include_tag(name, sprockets: opal.sprockets, prefix: opal.prefix, debug: opal.debug)
end

map "/__OPAL_SOURCE_MAPS__" do
  run Opal::SourceMapServer.new(opal.sprockets, "/__OPAL_SOURCE_MAPS__")
end

map "/assets" do
  run opal.sprockets
end

get "/" do
  send_file "public/index.html"
end

get "/games/:name" do
  send_file "games/#{params[:name]}.html"
end

run Sinatra::Application
