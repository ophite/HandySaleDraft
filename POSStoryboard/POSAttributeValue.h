//
//  POSAttributeValue.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "POSDBWrapper.h"


@interface POSAttributeValue : NSObject


@property NSString *name;
@property int attribute_ID;


+ (POSAttributeValue *)createNewAttributeValue:(NSString *)name withAttribute_ID:(int)attribute_ID;


@end
