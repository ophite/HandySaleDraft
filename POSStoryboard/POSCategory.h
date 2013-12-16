//
//  POSCategory.h
//  POS
//
//  Created by Pavel Slusar on 5/30/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSCategory : NSObject

{
    NSString*               name;
    int                     ID;
    UIImage*                image;
    NSMutableArray*         items;
    NSString*               asset;
}

@property NSString*         name;
@property UIImage*          image;
@property NSMutableArray*   items;
@property NSString*         asset;
@property int               ID;

@end
