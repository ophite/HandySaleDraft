//
//  POSOrder.h
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSOrder : NSObject
{
    NSString*       name;
    NSString*       category;
    NSString*       price;
    NSString*       quantity;
    NSString*       codeItem;
    int             item_ID;
    UIImage*        image;
}

@property  NSString*        name;
@property  NSString*        codeItem;
@property  NSString*        category;
@property  NSString*        price;
@property  NSString*        quantity;
@property  UIImage*         image;
@property  int              item_ID;

@end
