#import <SpringBoard/SBLockScreenManager.h>
#import "UIAlertView+Blocks.h"
#import "Common.h"

@interface SpringBoard : UIApplication
- (void)reboot;
@end

void rebootDevice() {
	[(SpringBoard *)[UIApplication sharedApplication] reboot];
}
