#import <UIKit/UIKit.h>
#import "TapSharpPreferences.h"

#define bluetoothPlistFile @"/var/mobile/Library/Preferences/com.apple.MobileBluetooth.devices.plist"
#define bluetoothLEPlistFile @"/var/mobile/Library/Preferences/com.apple.MobileBluetooth.ledevices.plist"

@interface BRRootListController : TapSharpRootController {
	NSMutableDictionary *_bluetoothDevices;
	NSMutableDictionary *_bluetoothLEDevices;
}
@end
