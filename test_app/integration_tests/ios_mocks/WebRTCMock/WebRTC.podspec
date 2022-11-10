
Pod::Spec.new do |s|
  s.name             = 'WebRTC'
  s.version          = '1.0.0'
  s.summary          = 'Mock for WebRTC'
  s.description      = <<-DESC
For testing purposes we need to mock the WebRTC. This Pod contains the mock. 
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => './LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platforms = {
    :ios => "12.0"
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
