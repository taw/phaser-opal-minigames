require "pathname"

desc "Rebuild docs/"
task "docs" do
  system "trash", "docs"
  Pathname("docs").mkpath
  system "cp -a games/*.html docs/"
  system "cp -a public/* docs/"
end
