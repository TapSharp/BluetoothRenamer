#import "SpringBoard.h"

%hook SBLockScreenManager
- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options {
	%orig;

	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL hasRunBefore = [fileManager fileExistsAtPath:firstRunFile];

	if ( ! hasRunBefore) {
		[UIAlertView showWithTitle:nil
		                   message:@"Thanks for installing Bluetooth Renamer. I'm always on Twitter if you have suggestions/problems. Consider a follow?"
		         cancelButtonTitle:@"No Thanks"
		         otherButtonTitles:@[@"Okay Cool"]
		                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
		                    if (buttonIndex != [alertView cancelButtonIndex]) {
		                        HBLogDebug(@"User accepted");

								ACAccountStore *accountStore = [[ACAccountStore alloc] init];
								ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

								[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
								    if(granted) {
								    	NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
										HBLogDebug(@"Accounts: %@", accountsArray);

								    	NSMutableArray *accs = [NSMutableArray array];

										for(ACAccount *acc in accountsArray) {
											[accs addObject:[NSString stringWithFormat:@"@%@", acc.username]];
										}

										[accs addObject:@"All Accounts!"];

										HBLogDebug(@"Formatted Accounts: %@", accs);

										if ([accountsArray count] > 1) {
											dispatch_async(dispatch_get_main_queue(), ^{
												[UIAlertView showWithTitle:@"Which Account?"
												                   message:@"Select an account to follow with."
												         cancelButtonTitle:@"Cancel"
												         otherButtonTitles:[accs copy]
												                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
												                    if (buttonIndex != [alertView cancelButtonIndex]) {
												                    	if (buttonIndex == [accs count]) {
												                    		HBLogDebug(@"All button clicked!");

												                    		for (ACAccount *twitterAccount in accountsArray) {
																				followMeOnTwitter(twitterAccount);
												                    		}

												                    	} else {
													                        ACAccount *twitterAccount = [accountsArray objectAtIndex:buttonIndex-1];
																			followMeOnTwitter(twitterAccount);
																		}
												                    }
												                  }];
											});
										} else if([accountsArray count] == 1) {
											ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
											followMeOnTwitter( twitterAccount );
										}
								    }
								}];
		                    }
		                  }];

		hasRunBefore = [fileManager createFileAtPath:firstRunFile contents:nil attributes:nil];
		HBLogDebug(@"Setting First Run To True: %@", hasRunBefore ? @"YES" : @"NO");
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		(CFNotificationCallback)rebootDevice,
		(CFStringRef) @"com.tapsharp.bluetoothrenamer/rebootDevice",
		NULL,
		CFNotificationSuspensionBehaviorCoalesce
	);
}