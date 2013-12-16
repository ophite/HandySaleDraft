//
//  POSItem.h
//  POS
//
//  Created by Pavel Slusar on 5/30/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSItem : NSObject
{
    int             ID;
    NSString*       name;
    int             catID;
    NSString*       codeItem;
    NSString*       category;
    NSString*       price1;
    NSString*       price2;
    NSString*       quantityAvailable;
    NSString*       quantityOrdered;
    NSString*       description;
    int             userID;
    UIImage*        image;
    NSString*       asset;
    
    NSMutableArray* gallery;
}

@property  int              ID;
@property  NSString*        name;
@property  NSString*        codeItem;
@property  int              catID;
@property  NSString*        category;
@property  NSString*        price1;
@property  NSString*        price2;
@property  NSString*        quantityAvailable;
@property  NSString*        quantityOrdered;
@property  NSString*        description;
@property  int              userID;
@property  UIImage*         image;
@property  NSMutableArray*  gallery;
@property  NSString*        asset;


@end
