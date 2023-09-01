#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint whisper_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'whisper_flutter_plus'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = {
    :file => '../LICENSE'
  }
  s.author           = {
    'Your Company' => 'email@example.com'
  }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.dependency 'Flutter'
  s.source           = {
    :git => 'https://github.com/krikristoophe/whisper_flutter_plus.git'
  }
  s.source_files = 'Classes/**/*.{cpp,c}'
  #s.private_header_files = 'Classes/**/*.{h,hpp}'
  s.platform = :ios, '12.1'
  s.ios.deployment_target  = '12.1'

  # Flutter.framework does not contain a i386 slice.
  s.xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '12.1'
  }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version = '5.0'
end
