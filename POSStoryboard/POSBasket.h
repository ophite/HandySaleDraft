//
//  POSBasket.h
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSBasket : NSObject

{
    NSString*       name;
    int             ID;
    NSString*       tst;
    NSString*       price;
    
}

@property  NSString*        name;
@property  NSString*        tst;
@property  NSString*        price;
@property  int              ID;

@end
