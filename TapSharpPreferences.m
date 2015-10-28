#import "TapSharpPreferences.h"
#import <Social/Social.h>

@implementation TapSharpRootController
-(BOOL)showHeart {
	return YES;
}

-(NSString *)shareMessage {
	return @"Customize this message.";
}

- (void)tweet:(UIBarButtonItem *)buttonItem {
    NSString *serviceType = SLServiceTypeTwitter;
    SLComposeViewController *composeSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [composeSheet setInitialText:self.shareMessage];
    [self presentViewController:composeSheet animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.showHeart) {
        UIImage* image = [UIImage imageNamed:@"heart" inBundle:[NSBundle bundleForClass:self.class]];
        image = [image changeImageColor:[UIColor tapSharp]];
        CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
        [someButton setBackgroundImage:image forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(tweet:) forControlEvents:UIControlEventTouchUpInside];
        [someButton setShowsTouchWhenHighlighted:YES];
        UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        ((UINavigationItem*)self.navigationItem).rightBarButtonItem = heartButton;
    }

    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor tapSharp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.tintColor = [UIColor tapSharp];
    self.navigationController.navigationBar.tintColor = [UIColor tapSharp];
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor tapSharp];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor tapSharp] };
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] keyWindow].tintColor = nil;
    self.view.tintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.titleTextAttributes = @{};

    [super viewWillDisappear:animated];
}
@end


@implementation TapSharpFooterCell
- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];

    if (self) {
    	HBLogDebug(@"Creating Custom Footer.");

        int screenWidth = [[UIScreen mainScreen] bounds].size.width;

        // Logo Image
		_logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 29)];
		_logoImageView.image = [UIImage imageNamed:@"tapsharp" inBundle:[NSBundle bundleForClass:self.class]];
		[_logoImageView setCenter:CGPointMake(screenWidth/2, self.bounds.size.height/2)];


		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy"];
		NSString *yearString = [formatter stringFromDate:[NSDate date]];

		// Copyright text
        _copyright = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, screenWidth, 20)];
        [_copyright setNumberOfLines:1];
        _copyright.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [_copyright setText:[@"ALL RIGHTS RESERVED © " stringByAppendingString:yearString]];
        [_copyright setBackgroundColor:[UIColor clearColor]];
        _copyright.textColor = [UIColor grayColor];
        _copyright.textAlignment = NSTextAlignmentCenter;

        // Add subviews
		[self addSubview:_logoImageView];
        [self addSubview:_copyright];
    }

    return self;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
    return 110.f;
}
-(void)dealloc {
	[_logoImageView release];
	[_copyright release];
	[super dealloc];
}
@end