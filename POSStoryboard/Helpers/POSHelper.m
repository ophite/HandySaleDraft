//
//  POSHelper.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/23/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSHelper.h"

@implementation POSHelper

#pragma mark - Singleton

+ (POSHelper *)getInstance {
    
    static POSHelper *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[POSHelper alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Settings

- (NSDictionary *)SETTING_LANGUAGES_DICT {
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"Russian", @"Russian",
            @"English", @"English",
            nil];
}

- (NSDictionary *)SETTING_CURRENCY_DICT {
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"$ USD", @"$",
            @"P RUB", @"P",
            @"₴ UAH", @"₴",
            @"€ EUR", @"€",
            nil];
}

- (NSString *)SETTING_REMEMBERME_CHECKED_ICON {
    
    return @"setting_rememberme_checked_icon.png";
}

- (NSString *)SETTING_REMEMBERME_UNCHECKED_ICON {
    
    return @"setting_rememberme_unchecked_icon.png";
}

- (NSString *)SETTING_EMAIL_ICON {
    
    return @"setting_email_icon.png";
}

- (NSString *)SETTING_LANGUAGE_ICON {
    
    return @"setting_language_icon.png";
}

- (NSString *)SETTING_CURRENCY_ICON {
    
    return @"setting_money_icon.png";
}

- (NSString *)SETTING_ADDATTRIBUTE_ICON {
    
    return @"setting_addattribute_icon.png";
}

- (NSString *)SETTING_DELETEATTRIBUTE_ICON {
    
    return @"setting_deleteattribute_icon.png";
}

- (NSString *)SETTING_WIFI_ICON {
    
    return @"setting_wifi_icon.png";
}

- (NSString *)SETTING_VAT_ICON {
    
    return @"setting_vat_icon.png";
}

- (NSString *)SETTING_EMAIL {
    
    return @"email";
}

- (NSString *)SETTING_LANGUAGE {
    
    return @"language";
}

- (NSString *)SETTING_CURRENCY {
    
    return @"currency";
}

- (NSString *)SETTING_WIFI {
    
    return @"wifi";
}

- (NSString *)SETTING_VAT {
    
    return @"vat";
}

- (NSString *)SETTING_REMEMBERME {
    
    return @"rememberme";
}

- (NSString *)SETTING_REMEMBERME_LOGIN {
    
    return @"rememberme_login";
}

- (NSString *)SETTING_REMEMBERME_PASS {
    
    return @"rememberme_pass";
}

- (NSString *)SETTING_BUTTON_BACKGROUND_COLOR {
    
    return @"button_color";
}

- (NSString *)SETTING_BUTTON_FONT_COLOR {
    
    return @"button_font_color";
}

- (NSString *)SETTING_TEXTFIELD_BORDER_COLOR {
    
    return @"textfield_border_color";
}

- (NSString *)SETTING_TEXTFIELD_FONT_COLOR {
    
    return @"textfield_font_color";
}

- (NSString *)SETTING_CATEGORY_MODE {
    
    return @"category_mode";
}

- (NSString *)SETTING_ITEM_MODE {
    
    return @"category_item";
}

#pragma mark - Sizes

- (CGFloat)ITEM_EDIT_WIDTH {
    
    return  180;
}


- (CGFloat)ITEM_EDIT_HEIGHT {
    
    return  180;
}


- (CGFloat)ITEM_VIEW_WIDTH {
    
    return  295;
}


- (CGFloat)ITEM_VIEW_HEIGHT
{
    
    return  285;
}


- (CGFloat)ITEM_LIST_WIDTH {
    
    return  160;
}


- (CGFloat)ITEM_LIST_HEIGHT {
    
    return  160;
}


- (CGFloat)CATEGORY_LIST_WIDTH {
    
    return  180;
}


- (CGFloat)CATEGORY_LIST_HEIGHT {
    
    return  200;
}

- (int)BUTTON_CORNER_RADIUS {
    
    return 15;
}


#pragma mark - Other

- (id)getDictionaryFirstValue:(NSDictionary *)dict {
    
    return [dict valueForKey:[[dict allKeys] objectAtIndex:0]];
}

- (id)getDictionaryFirstKey:(NSDictionary *)dict {
    
    return [[dict allKeys] objectAtIndex:0];
}

- (NSString *)convertFloatToStringWithFormat2SignIfNeed:(NSString *)value {

    float floatValue = value.floatValue;
    int intValue = value.intValue;

    return (floatValue - intValue > 0) ? [NSString stringWithFormat:@"%.2f", floatValue] : [NSString stringWithFormat: @"%d", intValue];
}

- (NSString *)convertBoolToString:(BOOL)value {
    
    return value ? @"YES" : @"NO";
}

- (NSString *)convertDateToSQLite:(NSDate *)date {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];

    return dateString;
}

- (NSDate *)convertStringToDateTo:(NSString *)dateStr {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    return date;
}

- (NSString *)convertDateToStringShort:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL)isValidEmail:(NSString *)email {
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];
}


- (NSObject *)getObject:(NSMutableArray *)objects withID:(int)id {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID = %d", id];
    NSArray *arr = [objects filteredArrayUsingPredicate:predicate];
    NSObject *value;
    
    if ([arr count] > 0) {
        
        value = ((NSObject *)[arr objectAtIndex:0]);
    }
    
    return value;
}

- (NSObject *)getObject:(NSMutableArray *)objects withName:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *arr = [objects filteredArrayUsingPredicate:predicate];
    NSObject *value;
    
    if ([arr count] > 0) {
        
        value = ((NSObject *)[arr objectAtIndex:0]);
    }
    
    return value;
}

- (NSObject *)getObject:(NSMutableArray *)objects withPredicate:(NSPredicate *)predicate {
    
    NSArray *arr = [objects filteredArrayUsingPredicate:predicate];
    NSObject *value;
    
    if ([arr count] > 0) {
        
        value = ((NSObject *)[arr objectAtIndex:0]);
    }
    
    return value;
}

- (NSObject *)getObjectImmutableArray:(NSArray *)objects withPredicate:(NSPredicate *)predicate {
    
    NSArray *arr = [objects filteredArrayUsingPredicate:predicate];
    NSObject *value;
    
    if ([arr count] > 0) {
        
        value = ((NSObject *)[arr objectAtIndex:0]);
    }
    
    return value;
}


#pragma mark - GUI

- (UIViewController *)getParentViewController:(UINavigationController *)navigationController {
    
    return (UIViewController *)[navigationController.viewControllers objectAtIndex:navigationController.viewControllers.count - 2];
}


- (id)getUIViewController:(NSString *)storyboardName {

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main"
                                                             bundle: nil];

    return [mainStoryboard instantiateViewControllerWithIdentifier:storyboardName];

}

- (void)setButtonShadow:(UIButton *)button withCornerRadius:(int)cornerRadius{

    button.layer.shadowRadius = 3.0f;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(2, 2);
    button.layer.shadowOpacity = 0.5f;
    button.layer.masksToBounds = NO;
    button.layer.cornerRadius = cornerRadius;
}

- (void)createLeftMarginForLabel:(UILabel *)label {
    
    [self createLeftMarginForLabel:label withSize:20];
}

- (void)createLeftMarginForLabel:(UILabel *)label withSize:(int)value {
    
    CGRect frameLabel = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    frameLabel.origin.x = value;
    label.frame = frameLabel;
}

- (void)createLeftMarginForTextField:(UITextField *)textField {
    
    [self createLeftMarginForTextField:textField withSize:20];
}

- (void)createLeftMarginForTextField:(UITextField *)textField withSize:(int)value {
    
    UIView *paddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, value, 0)];
    textField.leftView = paddingTxtfieldView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)createLeftMarginForTextView:(UITextView *)textView {
    
    [textView setContentInset:UIEdgeInsetsMake(0, 20, 0, 0)];
}

- (void)createLeftMarginForTextView:(UITextView *)textView withSize:(int)value {
    
    [textView setContentInset:UIEdgeInsetsMake(0, value, 0, 0)];
}

@end
