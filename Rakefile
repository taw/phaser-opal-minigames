require "pathname"

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
