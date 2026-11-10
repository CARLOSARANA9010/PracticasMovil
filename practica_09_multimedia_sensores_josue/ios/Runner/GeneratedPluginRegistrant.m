//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<image_picker_ios/ImagePickerPlugin.h>)
#import <image_picker_ios/ImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

#if __has_include(<sensors_plus/FPPSensorsPlusPlugin.h>)
#import <sensors_plus/FPPSensorsPlusPlugin.h>
#else
@import sensors_plus;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [ImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImagePickerPlugin"]];
  [FPPSensorsPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPSensorsPlusPlugin"]];
}

@end
