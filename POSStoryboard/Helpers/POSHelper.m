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

- (NSString *)SETTING_EMAIL {
    
    return @"email";
//    return @"setting_email_icon.png";
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
