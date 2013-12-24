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

- (NSString *)SETTING_EMAIL;

- (CGFloat)ITEM_EDIT_WIDTH;
- (CGFloat)ITEM_EDIT_HEIGHT;
- (CGFloat)ITEM_VIEW_WIDTH;
- (CGFloat)ITEM_VIEW_HEIGHT;
- (CGFloat)ITEM_LIST_WIDTH;
- (CGFloat)ITEM_LIST_HEIGHT;
- (CGFloat)CATEGORY_LIST_WIDTH;
- (CGFloat)CATEGORY_LIST_HEIGHT;

+ (POSHelper *)getInstance;
- (id)GetUIViewController:(NSString *)storyboardName;

@end
