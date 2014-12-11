Pod::Spec.new do |s|
  s.name     = 'GRUnit'
  s.version  = '1.0.13'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Test Framework for Objective-C.'
  s.homepage = 'https://github.com/gabriel/GRUnit'
  s.authors   = { 'Gabriel Handford' => 'gabrielh@gmail.com' }
  s.source   = { :git => 'https://github.com/gabriel/GRUnit.git', :tag => s.version.to_s }
  s.description = 'GRUnit is a test framework for iOS.'
  
  s.ios.platform = "7.0"
  s.ios.source_files = 'GRUnit/**/*.{h,m}', 'GRUnit-iOS/**/*.{h,m}', 'Libraries/GTM/**/*.{h,m}'

  s.osx.platform = "10.8"
  s.osx.source_files = 'GRUnit/**/*.{h,m}', 'GRUnit-OSX/**/*.{h,m}', 'Libraries/GTM/**/*.{h,m}'
  
  s.requires_arc = true
end

