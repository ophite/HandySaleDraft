//
//  UIView+POSFindFirstResponder.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/6/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import "UIView+POSFindFirstResponder.h"

@implementation UIView (POSFindFirstResponder)


- (UIView *)posFindFirstResponder {
    
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView posFindFirstResponder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}


@end
