Pod::Spec.new do |s|
  s.name     = "GRUnit"
  s.version  = "1.1.2"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary  = "Test Framework for Objective-C."
  s.homepage = "https://github.com/gabriel/GRUnit"
  s.authors   = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source   = { :git => "https://github.com/gabriel/GRUnit.git", :tag => s.version.to_s }
  s.description = "GRUnit is a test framework for iOS."
  
  s.ios.platform = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.ios.source_files = "GRUnit/**/*.{h,m}", "GRUnit-iOS/**/*.{h,m}", "Libraries/GTM/**/*.{h,m}"

  s.osx.platform = :osx, "10.8"
  s.osx.deployment_target = "10.8"
  s.osx.source_files = "GRUnit/**/*.{h,m}", "GRUnit-OSX/**/*.{h,m}", "Libraries/GTM/**/*.{h,m}"
  s.osx.resources = "GRUnit-OSX/**/*.xib"
  
  s.requires_arc = true
end

