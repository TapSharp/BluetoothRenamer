#import <Accounts/Accounts.h>
#import <Social/Social.h>

#define firstRunFile @"/Library/PreferenceBundles/BluetoothRenamerPrefs.bundle/first_run.btr"

void followMeOnTwitter(ACAccount *twitterAccount) {
	HBLogDebug(@"Following on twitter using \"@%@\"", twitterAccount.username);
	NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
	[tempDict setValue:@"TapSharp" forKey:@"screen_name"];
	[tempDict setValue:@"true" forKey:@"follow"];
	SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
	[postRequest setAccount:twitterAccount];
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		HBLogDebug(@"Twitter Response Error?: %@", error);
	}];
}
