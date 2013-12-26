//
//  POSAttribute.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "POSDBWrapper.h"

@interface POSAttribute : NSObject


@property NSString *name;
@property BOOL is_active;
@property int ID;

+ (POSAttribute *)createNewAttribute:(NSString *)name withIs_active:(BOOL)is_active;

@end
