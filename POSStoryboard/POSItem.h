//
//  POSItem.h
//  POS
//
//  Created by Pavel Slusar on 5/30/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSItem : NSObject


@property  int              ID;
@property  NSString*        name;
@property  NSString*        codeItem;
@property  int              catID;
@property  NSString*        category;
@property  NSString*        price_buy;
@property  NSString*        price_sale;
@property  NSString*        quantityAvailable;
@property  NSString*        quantityOrdered;
@property  NSString*        description;
@property  int              userID;
@property  UIImage*         image;
@property  NSMutableArray*  gallery;
@property  NSString*        asset;


@end
