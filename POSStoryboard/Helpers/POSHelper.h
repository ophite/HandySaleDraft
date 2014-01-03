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

- (NSDictionary *)getMoney;
- (NSDictionary *)getLanguages;

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

- (id)getDictionaryFirstValue:(NSDictionary *)dict;
- (id)getDictionaryFirstKey:(NSDictionary *)dict;
- (NSString *)convertBoolToString:(BOOL)value;

+ (POSHelper *)getInstance;
- (id)getUIViewController:(NSString *)storyboardName;

@end
