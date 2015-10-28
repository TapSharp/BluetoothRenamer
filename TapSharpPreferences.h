#import <UIKit/UIKit.h>

typedef enum PSCellType {
    PSGroupCell,
    PSLinkCell,
    PSLinkListCell,
    PSListItemCell,
    PSTitleValueCell,
    PSSliderCell,
    PSSwitchCell,
    PSStaticTextCell,
    PSEditTextCell,
    PSSegmentCell,
    PSGiantIconCell,
    PSGiantCell,
    PSSecureEditTextCell,
    PSButtonCell,
    PSEditTextViewCell,
} PSCellType;

@interface PSSpecifier : NSObject {
@public
    id target;
    SEL getter;
    SEL setter;
    SEL action;
    Class detailControllerClass;
    PSCellType cellType;
    Class editPaneClass;
    UIKeyboardType keyboardType;
    UITextAutocapitalizationType autoCapsType;
    UITextAutocorrectionType autoCorrectionType;
    int textFieldType;
@private
    NSString *_name;
    NSArray *_values;
    NSDictionary *_titleDict;
    NSDictionary *_shortTitleDict;
    id _userInfo;
    NSMutableDictionary *_properties;
}
@property (retain) NSMutableDictionary *properties;
@property (retain) NSString *identifier;
@property (retain) NSString *name;
@property (retain) id userInfo;
@property (retain) id titleDictionary;
@property (retain) id shortTitleDictionary;
@property (retain) NSArray *values;
+ (id)preferenceSpecifierNamed:(NSString *)title target:(id)target set:(SEL)set get:(SEL)get detail:(Class)detail cell:(PSCellType)cell edit:(Class)edit;
+ (PSSpecifier *)groupSpecifierWithName:(NSString *)title;
+ (PSSpecifier *)emptyGroupSpecifier;
+ (UITextAutocapitalizationType)autoCapsTypeForString:(PSSpecifier *)string;
+ (UITextAutocorrectionType)keyboardTypeForString:(PSSpecifier *)string;
- (id)propertyForKey:(NSString *)key;
- (void)setProperty:(id)property forKey:(NSString *)key;
- (void)removePropertyForKey:(NSString *)key;
- (void)loadValuesAndTitlesFromDataSource;
- (void)setValues:(NSArray *)values titles:(NSArray *)titles;
- (void)setValues:(NSArray *)values titles:(NSArray *)titles shortTitles:(NSArray *)shortTitles;
- (void)setupIconImageWithPath:(NSString *)path;
- (NSString *)identifier;
- (void)setTarget:(id)target;
- (void)setButtonAction:(SEL)arg1;
- (void)setKeyboardType:(UIKeyboardType)type autoCaps:(UITextAutocapitalizationType)autoCaps autoCorrection:(UITextAutocorrectionType)autoCorrection;
@end

@interface PSTextFieldSpecifier: PSSpecifier
- (void)setPlaceholder:(id)arg1;
@end

@interface PSViewController : UIViewController {
    PSSpecifier *_specifier;
}
@property (retain) PSSpecifier *specifier;
- (id)readPreferenceValue:(PSSpecifier *)specifier;
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier;
@end

@interface PSListController : PSViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_specifiers;
}
@property (retain, nonatomic) NSArray *specifiers;
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)plistName target:(id)target;
- (PSSpecifier *)specifierForID:(NSString *)identifier;
- (PSSpecifier *)specifierAtIndex:(NSInteger)index;
- (NSArray *)specifiersForIDs:(NSArray *)identifiers;
- (NSArray *)specifiersInGroup:(NSInteger)group;
- (BOOL)containsSpecifier:(PSSpecifier *)specifier;
- (NSInteger)numberOfGroups;
- (NSInteger)rowsForGroup:(NSInteger)group;
- (NSInteger)indexForRow:(NSInteger)row inGroup:(NSInteger)group;
- (BOOL)getGroup:(NSInteger *)group row:(NSInteger *)row ofSpecifier:(PSSpecifier *)specifier;
- (BOOL)getGroup:(NSInteger *)group row:(NSInteger *)row ofSpecifierID:(NSString *)identifier;
- (BOOL)getGroup:(NSInteger *)group row:(NSInteger *)row ofSpecifierAtIndex:(NSInteger )index;
- (void)addSpecifier:(PSSpecifier *)specifier;
- (void)addSpecifiersFromArray:(NSArray *)array;
- (void)addSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated;
- (void)addSpecifiersFromArray:(NSArray *)array animated:(BOOL)animated;
- (void)insertSpecifier:(PSSpecifier *)specifier afterSpecifier:(PSSpecifier *)afterSpecifier;
- (void)insertSpecifier:(PSSpecifier *)specifier afterSpecifierID:(NSString *)afterSpecifierID;
- (void)insertSpecifier:(PSSpecifier *)specifier atIndex:(NSInteger)index;
- (void)insertSpecifier:(PSSpecifier *)specifier atEndOfGroup:(NSInteger)index;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers afterSpecifier:(PSSpecifier *)afterSpecifier;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers afterSpecifierID:(NSString *)afterSpecifierID;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers atIndex:(NSInteger)index;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers atEndOfGroup:(NSInteger)index;
- (void)insertSpecifier:(PSSpecifier *)specifier afterSpecifier:(PSSpecifier *)afterSpecifier animated:(BOOL)animated;
- (void)insertSpecifier:(PSSpecifier *)specifier afterSpecifierID:(NSString *)afterSpecifierID animated:(BOOL)animated;
- (void)insertSpecifier:(PSSpecifier *)specifier atIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertSpecifier:(PSSpecifier *)specifier atEndOfGroup:(NSInteger)index animated:(BOOL)animated;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers afterSpecifier:(PSSpecifier *)afterSpecifier animated:(BOOL)animated;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers afterSpecifierID:(NSString *)afterSpecifierID animated:(BOOL)animated;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers atIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertContiguousSpecifiers:(NSArray *)spcifiers atEndOfGroup:(NSInteger)index animated:(BOOL)animated;
- (void)replaceContiguousSpecifiers:(NSArray *)oldSpecifiers withSpecifiers:(NSArray *)newSpecifiers;
- (void)replaceContiguousSpecifiers:(NSArray *)oldSpecifiers withSpecifiers:(NSArray *)newSpecifiers animated:(BOOL)animated;
- (void)removeSpecifier:(PSSpecifier *)specifier;
- (void)removeSpecifierID:(NSString *)identifier;
- (void)removeSpecifierAtIndex:(NSInteger)index;
- (void)removeLastSpecifier;
- (void)removeContiguousSpecifiers:(NSArray *)specifiers;
- (void)removeSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated;
- (void)removeSpecifierID:(NSString *)identifier animated:(BOOL)animated;
- (void)removeSpecifierAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeLastSpecifierAnimated:(BOOL)animated;
- (void)removeContiguousSpecifiers:(NSArray *)specifiers animated:(BOOL)animated;
- (void)reloadSpecifier:(PSSpecifier *)specifier;
- (void)reloadSpecifierID:(NSString *)identifier;
- (void)reloadSpecifierAtIndex:(NSInteger)index;
- (void)reloadSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated;
- (void)reloadSpecifierID:(NSString *)identifier animated:(BOOL)animated;
- (void)reloadSpecifierAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadSpecifiers;
- (void)updateSpecifiers:(NSArray *)oldSpecifiers withSpecifiers:(NSArray *)newSpecifiers;
- (void)updateSpecifiersInRange:(NSRange)range withSpecifiers:(NSArray *)newSpecifiers;
- (void)_returnKeyPressed:(id)arg1;
@end

@interface PSListItemsController : PSListController
@end

@interface UITableCell : UIView
@end

@interface UIImageAndTextTableCell : UITableCell
-(id)titleTextLabel;
@end

@interface UIPreferencesTableCell : UIImageAndTextTableCell
@end

@interface PSTableCell : UIPreferencesTableCell {
    id _userInfo;
    BOOL _checked;
}
@property(retain) id userInfo;
+(PSCellType)cellTypeFromString:(id)string;
+(id)_cellForSpecifier:(id)specifier defaultClass:(Class)aClass frame:(CGRect)frame;
+(PSTableCell *)switchCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)segmentCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)sliderCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)textFieldCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)textViewCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)groupHeaderCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)staticTextCellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
+(PSTableCell *)cellWithFrame:(CGRect)frame specifier:(PSSpecifier *)specifier;
-(void)setValueChangedTarget:(id)target action:(SEL)action userInfo:(id)info;
-(void)cellClicked:(id)clicked;
// inherited: -(void)layoutSubviews;
// inherited: -(id)titleTextLabel;
-(id)initWithFrame:(CGRect)frame specifier:(id)specifier;
// inherited: -(void)dealloc;
-(void)willMoveToSuperview:(id)superview;
-(void)addSubview:(id)subview;
@end

@interface PSTableCell (SyntheticEvents)
-(id)_automationID;
-(id)scriptingInfoWithChildren;
@end

@interface PSTableCell (TapSharp)
// @property (nonatomic, assign) CGSize bounds;
@property (nonatomic, retain) UIView *backgroundView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface TapSharpFooterCell : PSTableCell {
	UIImageView* _logoImageView;
	UILabel* _copyright;
}
@end


@interface TapSharpRootController: PSListController
- (NSString *)shareMessage;
- (BOOL)showHeart;
- (void)tweet:(UIBarButtonItem *)buttonItem;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
@end


@interface UIImage (TapSharpPreferencesImage)
+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end


@implementation UIImage (TapSharpPreferencesImageColor)
- (UIImage *)changeImageColor:(UIColor *)color {
    UIImage *img = self;
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImg;
}
@end

@implementation UIColor (TapSharpPreferencesColor)
+ (UIColor *)tapSharp {
    return [UIColor colorWithRed:85.0f/255.0f green:172.0f/255.f blue:238.0f/255.f alpha:1.0f];
}
@end