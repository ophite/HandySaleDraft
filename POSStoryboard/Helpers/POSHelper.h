//
//  POSHelper.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/23/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#define helperInstance [POSHelper getInstance]

@interface POSHelper : NSObject

// name helpers
- (NSDictionary *)SETTING_CURRENCY_DICT;
- (NSDictionary *)SETTING_LANGUAGES_DICT;

- (NSString *)SETTING_ADDATTRIBUTE_ICON;
- (NSString *)SETTING_DELETEATTRIBUTE_ICON;
- (NSString *)SETTING_TEXTFIELD_FONT_COLOR;
- (NSString *)SETTING_TEXTFIELD_BORDER_COLOR;
- (NSString *)SETTING_CATEGORY_MODE;
- (NSString *)SETTING_ITEM_MODE;
- (NSString *)SETTING_BUTTON_BACKGROUND_COLOR;
- (NSString *)SETTING_BUTTON_FONT_COLOR;
- (NSString *)SETTING_REMEMBERME_LOGIN;
- (NSString *)SETTING_REMEMBERME_PASS;
- (NSString *)SETTING_REMEMBERME_CHECKED_ICON;
- (NSString *)SETTING_REMEMBERME_UNCHECKED_ICON;
- (NSString *)SETTING_EMAIL_ICON;
- (NSString *)SETTING_LANGUAGE_ICON;
- (NSString *)SETTING_CURRENCY_ICON;
- (NSString *)SETTING_WIFI_ICON;
- (NSString *)SETTING_VAT_ICON;
- (NSString *)SETTING_EMAIL;
- (NSString *)SETTING_LANGUAGE;
- (NSString *)SETTING_CURRENCY;
- (NSString *)SETTING_WIFI;
- (NSString *)SETTING_VAT;
- (NSString *)SETTING_REMEMBERME;

// sizes
- (CGFloat)ITEM_EDIT_WIDTH;
- (CGFloat)ITEM_EDIT_HEIGHT;
- (CGFloat)ITEM_VIEW_WIDTH;
- (CGFloat)ITEM_VIEW_HEIGHT;
- (CGFloat)ITEM_LIST_WIDTH;
- (CGFloat)ITEM_LIST_HEIGHT;
- (CGFloat)CATEGORY_LIST_WIDTH;
- (CGFloat)CATEGORY_LIST_HEIGHT;
- (int)BUTTON_CORNER_RADIUS;

// singleton
+ (POSHelper *)getInstance;

// methods
- (id)getDictionaryFirstValue:(NSDictionary *)dict;
- (id)getDictionaryFirstKey:(NSDictionary *)dict;

- (NSString *)convertFloatToStringWithFormat2SignIfNeed:(NSString *)value;
- (NSString *)convertBoolToString:(BOOL)value;
- (NSString *)convertDateToSQLite:(NSDate *)date;

- (BOOL)isValidEmail:(NSString *)email;
- (NSObject *)getObject:(NSMutableArray *)objects withID:(int)id;
- (NSObject *)getObject:(NSMutableArray *)objects withName:(NSString *)name;
- (NSObject *)getObject:(NSMutableArray *)objects withPredicate:(NSPredicate *)predicate;
- (NSObject *)getObjectImmutableArray:(NSArray *)objects withPredicate:(NSPredicate *)predicate;

// gui
- (UIViewController *)getParentViewController:(UINavigationController *)navigationController;

- (id)getUIViewController:(NSString *)storyboardName;
- (void)setButtonShadow:(UIButton *)button withCornerRadius:(int)cornerRadius;

- (void)createLeftMarginForLabel:(UILabel *)label withSize:(int)value;
- (void)createLeftMarginForLabel:(UILabel *)label;

- (void)createLeftMarginForTextField:(UITextField *)textField withSize:(int)value;
- (void)createLeftMarginForTextField:(UITextField *)textField;

- (void)createLeftMarginForTextView:(UITextView *)textView withSize:(int)value;
- (void)createLeftMarginForTextView:(UITextView *)textView;


@end
