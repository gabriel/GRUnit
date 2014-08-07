Gem::Specification.new do |s|
  s.name = "grunit"
  s.version = "1.0.4"
  s.executables << "grunit"
  s.date = "2014-08-06"
  s.summary = "GRUnit"
  s.description = "Utilities for GRUnit."
  s.authors = ["Gabriel Handford"]
  s.email = "gabrielh@gmail.com"
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = "https://github.com/gabriel/GRUnit"
  s.license = "MIT"
  s.add_runtime_dependency "xcodeproj"
  s.add_runtime_dependency "slop"
  s.add_runtime_dependency "colorize"
  s.add_runtime_dependency "xcpretty"
end
