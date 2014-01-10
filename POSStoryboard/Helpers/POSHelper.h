//
//  POSHelper.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/23/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSSetting.h"
#import "POSObjectsHelper.h"
#define helperInstance [POSHelper getInstance]

@interface POSHelper : NSObject

- (NSDictionary *)SETTING_MONEY_DICT;
- (NSDictionary *)SETTING_LANGUAGES_DICT;

- (NSString *)SETTING_TEXTFIELD_FONT_COLOR;
- (NSString *)SETTING_TEXTFIELD_BORDER_COLOR;
- (NSString *)SETTING_CATEGORY_MODE;
- (NSString *)SETTING_BUTTON_BACKGROUND_COLOR;
- (NSString *)SETTING_BUTTON_FONT_COLOR;
- (NSString *)SETTING_REMEMBERME_LOGIN;
- (NSString *)SETTING_REMEMBERME_PASS;
- (NSString *)SETTING_REMEMBERME_CHECKED_ICON;
- (NSString *)SETTING_REMEMBERME_UNCHECKED_ICON;
- (NSString *)SETTING_EMAIL_ICON;
- (NSString *)SETTING_LANGUAGE_ICON;
- (NSString *)SETTING_MONEY_ICON;
- (NSString *)SETTING_WIFI_ICON;
- (NSString *)SETTING_VAT_ICON;
- (NSString *)SETTING_EMAIL;
- (NSString *)SETTING_LANGUAGE;
- (NSString *)SETTING_MONEY;
- (NSString *)SETTING_WIFI;
- (NSString *)SETTING_VAT;
- (NSString *)SETTING_REMEMBERME;


- (CGFloat)ITEM_EDIT_WIDTH;
- (CGFloat)ITEM_EDIT_HEIGHT;
- (CGFloat)ITEM_VIEW_WIDTH;
- (CGFloat)ITEM_VIEW_HEIGHT;
- (CGFloat)ITEM_LIST_WIDTH;
- (CGFloat)ITEM_LIST_HEIGHT;
- (CGFloat)CATEGORY_LIST_WIDTH;
- (CGFloat)CATEGORY_LIST_HEIGHT;
- (int)BUTTON_CORNER_RADIUS;

- (id)getDictionaryFirstValue:(NSDictionary *)dict;
- (id)getDictionaryFirstKey:(NSDictionary *)dict;

- (NSString *)convertBoolToString:(BOOL)value;

- (BOOL)isValidEmail:(NSString *)email;


+ (POSHelper *)getInstance;
- (id)getUIViewController:(NSString *)storyboardName;
- (void)setButtonShadow:(UIButton *)button withCornerRadius:(int)cornerRadius;

- (void)setTextFieldBorderColorBySetting:(UITextField *)textField;
- (void)loadTextFieldBorderColorSetting:(UIColor *)color;

- (void)setTextFieldFontColorBySetting:(UITextField *)textField;
- (void)loadTextFieldFontColorSetting:(UIColor *)color;

- (void)setButtonBackgroundColorBySetting:(UIButton *)button;
- (void)loadButtonBackgroundColorSetting:(UIColor *)color;

- (void)setButtonFontColorBySetting:(UIButton *)button;
- (void)loadButtonFontColorSetting:(UIColor *)color;

- (void)setButtonFontColor:(UIButton *)button withSetting:(POSSetting *)setting;


@end
