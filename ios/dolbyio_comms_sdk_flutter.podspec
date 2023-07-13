#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint dolbyio_comms_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'dolbyio_comms_sdk_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Dolby.io Communications SDK for Flutter'
  s.description      = <<-DESC
Dolby.io Communications SDK for Flutter allows creating high-quality applications for video 
conferencing using the Flutter UI development SDK. With Flutter, you can write a single codebase in 
Dart that you can natively compile and use for building, testing, and deploying applications across 
multiple platforms. Currently, the Flutter SDK supports creating applications for iOS and 
Android devices.                       
DESC
  s.homepage         = 'https://github.com/DolbyIO/comms-sdk-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Dobly.io' => 'support@dolby.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'VoxeetSDK', '~> 3.9.0'
  s.platforms = {
    :ios => "12.0"
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
