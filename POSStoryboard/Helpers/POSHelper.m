//
//  POSHelper.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/23/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSHelper.h"

@implementation POSHelper


#pragma mark - SETTINGS

- (NSDictionary *)SETTING_LANGUAGES_DICT {
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"Russian", @"Russian",
            @"English", @"English",
            nil];
}

- (NSDictionary *)SETTING_MONEY_DICT {
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"$ dollar", @"$",
            @"P rubl", @"P",
            @"₴ hryvna", @"₴",
            @"€ evro", @"€",
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

- (NSString *)SETTING_MONEY_ICON {
    
    return @"setting_money_icon.png";
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

- (NSString *)SETTING_MONEY {
    
    return @"money";
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


#pragma mark - SIZES

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


#pragma mark - Other 

- (id)getDictionaryFirstValue:(NSDictionary *)dict {
    
    return [dict valueForKey:[[dict allKeys] objectAtIndex:0]];
}

- (id)getDictionaryFirstKey:(NSDictionary *)dict {
    
    return [[dict allKeys] objectAtIndex:0];
}

- (NSString *)convertBoolToString:(BOOL)value {
    
    return value ? @"YES" : @"NO";
}


#pragma mark - GUI

+ (POSHelper *)getInstance {
    
    static POSHelper *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        sharedInstance = [[POSHelper alloc] init];
    });
    
    return sharedInstance;
}

- (id)getUIViewController:(NSString *)storyboardName {

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main"
                                                             bundle: nil];

    return [mainStoryboard instantiateViewControllerWithIdentifier:storyboardName];

}

@end
