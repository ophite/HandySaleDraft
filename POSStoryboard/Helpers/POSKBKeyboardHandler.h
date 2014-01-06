//
//  KBKeyboardHandler.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/6/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol POSKBKeyboardHandlerDelegate;


@interface POSKBKeyboardHandler : NSObject


- (id)init;


@property(nonatomic, weak) id<POSKBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;


@end