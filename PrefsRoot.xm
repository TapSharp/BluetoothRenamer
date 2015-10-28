#import <Preferences/PSSpecifier.h>

%hook PSUIPrefsListController
- (id)specifiers {
	%log;

	NSArray* specifiers = %orig;
	HBLogDebug(@"Registered Specifiers: %@", specifiers);

	unsigned long specifierIndex = nil;
	unsigned long btSpecifierIndex = nil;

	for (PSSpecifier* specifier in specifiers) {

		// Bluetooth is typically one below WIFI
		if ([[specifier identifier] isEqual:@"WIFI"]) {
			btSpecifierIndex = [specifiers indexOfObject:specifier] + 1;
			HBLogDebug(@"Found \"Bluetooth\" Specifier: %@ at Index: %lu", [specifiers objectAtIndex:btSpecifierIndex], btSpecifierIndex);
		}

		// Get our specifier
		if ([[specifier identifier] isEqual:@"TAPSHARP_BLUETOOTH_RENAMER"]) {
			specifierIndex = [specifiers indexOfObject:specifier];
			HBLogDebug(@"Found \"TAPSHARP_BLUETOOTH_RENAMER\" Specifier: %@ at Index: %lu", specifier, specifierIndex);
		}
	}

	NSMutableArray* newSpecifiers = [specifiers mutableCopy];

	// Move our specifier upwards the heirrachy...
	id btrSpecifier = [[[newSpecifiers objectAtIndex:specifierIndex] retain] autorelease];
	[newSpecifiers removeObjectAtIndex:specifierIndex];
	[newSpecifiers insertObject:btrSpecifier atIndex:btSpecifierIndex + 1];

	// Override "_specifiers" ivar
	MSHookIvar<id>(self, "_specifiers") = [newSpecifiers copy];
	HBLogDebug(@"New Specifiers: %@", MSHookIvar<id>(self, "_specifiers"));

	return MSHookIvar<id>(self, "_specifiers");
}
%end