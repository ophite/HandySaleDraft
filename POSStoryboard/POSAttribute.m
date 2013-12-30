//
//  POSAttribute.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSAttribute.h"


@implementation POSAttribute


@synthesize ID = _ID;
@synthesize name = _name;
@synthesize is_active = _is_active;


+ (POSAttribute *)createNewAttribute:(NSString *)name withIs_active:(BOOL)is_active {
    
    POSAttribute *newAttr;
    NSString *query = [NSString stringWithFormat:@"insert into attribute (name, is_active) \
                                                   values (\"%@\", %d); ", name, is_active];
    
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];

        newAttr = [[POSAttribute alloc] init];
        newAttr.name = name;
        newAttr.is_active = is_active;
    }
    
    return newAttr;
}


- (BOOL)updateAttribute:(NSString *)name withIs_active:(BOOL)is_active {
    
    BOOL result = NO;
    NSString *query = [NSString stringWithFormat:@"update   attribute \
                                                   set      name = \"%@\", \
                                                            is_active = %d \
                                                   where    id = %d; ", name, is_active, self.ID];
    
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        self.name = name;
        self.is_active = is_active;
        result = YES;
    }
    
    return result;
}


@end
