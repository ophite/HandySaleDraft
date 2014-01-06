//
//  KBKeyboardHandlerDelegate.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/6/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol POSKBKeyboardHandlerDelegate <NSObject>

- (void)keyboardSizeChanged:(CGSize)delta;

@end
