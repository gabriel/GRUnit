Pod::Spec.new do |s|
  s.name     = 'GRUnit'
  s.version  = '1.0.1'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'Test Framework for Objective-C.'
  s.homepage = 'https://github.com/gabriel/GRUnit'
  s.authors   = { 'Gabriel Handford' => 'gabrielh@gmail.com' }
  s.source   = { :git => 'https://github.com/ggabriel/GRUnit.git', :tag => s.version.to_s }
  s.description = 'GRUnit is a test framework for iOS.'
  s.source_files = 'GRUnit/**/*.{h,m}', 'Libraries/GTM/**/*.{h,m}'
  s.requires_arc = true
end
