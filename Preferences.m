#import "Preferences.h"

@implementation BRRootListController

-(NSString *)shareMessage {
	return @"Rename paired Bluetooth devices on your #jailbroken #iOS device using \"BluetoothRenamer\" by @TapSharp. Now available on Cydia.";
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray *specifiers = [[NSMutableArray alloc] initWithArray:[self bluetoothDevicesSpecifiers]];
		[specifiers addObjectsFromArray:[self otherSpecifiers]];
		_specifiers = [specifiers copy];
	}

	return _specifiers;
}

-(NSMutableArray *)otherSpecifiers {
	NSMutableArray *specifiers = [NSMutableArray array];

	// Spacer
	[specifiers addObject:[PSSpecifier groupSpecifierWithName:@""]];

	[specifiers addObject:({
	    PSSpecifier *specifier = [PSSpecifier groupSpecifierWithName:@""];
	    [specifier setProperty:@"TapSharpFooterCell" forKey:@"footerCellClass"];
	    specifier;
	})];

	return specifiers;
}

-(NSArray *)bluetoothDevicesSpecifiers {
	NSMutableArray *specifiers = [NSMutableArray array];
	HBLogDebug(@"Initialize empty specifiers");

	/**
	 * BLUETOOTH DEVICES
	 */

	BOOL plistExists = [[NSFileManager defaultManager] fileExistsAtPath:bluetoothPlistFile];

	[specifiers addObject:[self groupSpecifier:@"Bluetooth Devices"
								withFooterText:plistExists ? @"You may need to reboot to see saved changes." : @""]];

	if (plistExists) {
		_bluetoothDevices = [[NSMutableDictionary alloc] initWithContentsOfFile:bluetoothPlistFile];

		HBLogDebug(@"Available Bluetooth Devices: %@", _bluetoothDevices);

		[_bluetoothDevices enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
			[specifiers addObject:[self textFieldSpecifier:key
													 label:@""
											   placeholder:[NSString stringWithFormat:@"\"%@\" New Name", [obj objectForKey:@"Name"]]
											   isLowEnergy:NO]];
		}];

		[specifiers addObject:[self rebootConfirmationButton]];
		HBLogDebug(@"Completed Adding Specifiers for Bluetooth Devices: %@", specifiers);
	} else {
		[specifiers addObject:[self noDevicesSpecifier]];
		HBLogDebug(@"No bluetooth devices found.");
	}


	/**
	 * LOW ENERGY BLUETOOTH DEVICES
	 */

	plistExists = [[NSFileManager defaultManager] fileExistsAtPath:bluetoothLEPlistFile];

	[specifiers addObject:[self groupSpecifier:@"Low Power Bluetooth Devices"
								withFooterText:plistExists ? @"You may need to reboot to see saved changes." : @"This mode is coming soon."]];

	// if (plistExists)
	// {
	// 	NSMutableDictionary *devices = [[NSMutableDictionary alloc] initWithContentsOfFile: bluetoothLEPlistFile];

	// 	[devices enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
	// 		NSString *placeholder = [NSString stringWithFormat:@"\"%@\" New Name", [obj objectForKey:@"Name"]];

	// 		[specifiers addObject:[self textFieldSpecifier:key label:@"" placeholder:placeholder isLowEnergy:YES]];
	// 	}];

	// 	[specifiers addObject:[self rebootConfirmationButton]];
	// }
	// else
	// {
		[specifiers addObject:[self noDevicesSpecifier]];
	// }


	return [specifiers copy];
}

-(PSSpecifier *) groupSpecifier:(NSString *)title withFooterText:(NSString *)footerText {
	PSSpecifier *specifier = [PSSpecifier groupSpecifierWithName:title];
	[specifier setProperty:footerText forKey:@"footerText"];
	return specifier;
}

-(PSTextFieldSpecifier *) textFieldSpecifier:(NSString *)key label:(NSString *)label placeholder:(NSString *)placeholder isLowEnergy:(BOOL)lowEnergy {
	SEL setSelector = lowEnergy ? @selector(setLEPreferenceValue:specifier:) : @selector(setPreferenceValue:specifier:);
	SEL getSelector = lowEnergy ? @selector(readLEPreferenceValue:specifier:) : @selector(readPreferenceValue:specifier:);

	PSTextFieldSpecifier *specifier = [PSTextFieldSpecifier preferenceSpecifierNamed:label
	                                                            target:self
	                                                               set:setSelector
	                                                               get:getSelector
	                                                            detail:nil
	                                                              cell:PSEditTextCell
	                                                              edit:nil];

	NSString *btNotification = lowEnergy ? @"bluetoothLENameChanged" : @"bluetoothNameChanged";
	NSString *notification = [NSString stringWithFormat:@"com.tapsharp.bluetoothrenamer/%@", btNotification];

    [specifier setIdentifier:key];
    [specifier setPlaceholder:placeholder];
    [specifier setProperty:label forKey:@"label"];
	[specifier setProperty:@YES forKey:@"enabled"];
	[specifier setProperty:notification forKey:@"PostNotification"];

	return specifier;
}

-(PSSpecifier *)noDevicesSpecifier {
	return [PSSpecifier preferenceSpecifierNamed:@"No bluetooth devices."
										  target:self
										     set:NULL
										    get:NULL
										  detail:Nil
										    cell:PSStaticTextCell
										    edit:Nil];
}

- (void)_returnKeyPressed:(id)notification {
	[self.view endEditing:YES];
	[super _returnKeyPressed:notification];
}


- (void)setBluetoothName:(id)value specifier:(PSSpecifier *)specifier isLowEnergy:(BOOL)lowEnergy {

	// @TODO
	if (lowEnergy) return;


	NSMutableDictionary *deviceInfo  = [_bluetoothDevices objectForKey:[specifier identifier]];

	if (deviceInfo) {
		NSString *currentName = [deviceInfo objectForKey:@"Name"];

		if ( ! [currentName isEqual:value]) {
			NSString *plistFile = lowEnergy ? bluetoothLEPlistFile : bluetoothPlistFile;

			NSString *keyPath = [NSString stringWithFormat:@"%@.Name", [specifier identifier]];

			[_bluetoothDevices setValue:value forKeyPath:keyPath];
			[_bluetoothDevices writeToFile:plistFile atomically:YES];

			CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
		} else {
			NSString *msg = @"Let me get this straight. You downloaded this tweak and decided to rename your BT device to the same name it already had?? (O.o)";

			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Weirdo Alert!"
															message:msg
														   delegate:nil
												  cancelButtonTitle:@"Try Again"
												  otherButtonTitles:nil];

			[alert show];
			[alert release];
		}
	}
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[self setBluetoothName:value specifier:specifier isLowEnergy:NO];
}

- (void)setLEPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[self setBluetoothName:value specifier:specifier isLowEnergy:YES];
}


- (id)readPreferenceValue:(PSSpecifier *)specifier {
	return [self readBluetoothName:specifier isLowEnergy:NO];
}

- (id)readLEPreferenceValue:(PSSpecifier *)specifier {
	return [self readBluetoothName:specifier isLowEnergy:YES];
}

-(id)readBluetoothName:(PSSpecifier *)specifier isLowEnergy:(BOOL)lowEnergy {
	if (_bluetoothDevices == nil) {
		NSString *plistFile = lowEnergy ? bluetoothLEPlistFile : bluetoothPlistFile;
		_bluetoothDevices = [[NSMutableDictionary alloc] initWithContentsOfFile: plistFile];
	}

	HBLogDebug(@"Bluetooth Devices: %@", _bluetoothDevices);

	NSMutableDictionary *device = [_bluetoothDevices objectForKey:specifier.identifier];
	HBLogDebug(@"Bluetooth Device: %@", device);

	NSString *deviceName = [device objectForKey:@"Name"];
	HBLogDebug(@"Bluetooth Device Name: %@", deviceName);

	return deviceName;
}


-(PSSpecifier *)rebootConfirmationButton {
	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Save Changes"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:nil
                                                              cell:PSButtonCell
                                                              edit:nil];
	[specifier setProperty:@YES forKey:@"enabled"];
	[specifier setButtonAction:@selector(showRebootConfirmationAlert)];

	return specifier;
}

-(void)showRebootConfirmationAlert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reboot Device?"
													message:@"Your device will have to be rebooted for any of the changes above to be correctly reflected."
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Reboot", nil];

	[alert show];
	[alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		CFStringRef toPost = (CFStringRef) @"com.tapsharp.bluetoothrenamer/rebootDevice";
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
	}
}


-(void) dealloc {
	[_bluetoothDevices release];
	[super dealloc];
}
@end
