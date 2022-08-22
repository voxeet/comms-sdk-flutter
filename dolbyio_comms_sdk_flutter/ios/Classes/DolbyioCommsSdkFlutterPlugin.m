#import "DolbyioCommsSdkFlutterPlugin.h"
#if __has_include(<dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter-Swift.h>)
#import <dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dolbyio_comms_sdk_flutter-Swift.h"
#endif

@implementation DolbyioCommsSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDolbyioCommsSdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
