//
//  POSAttributeValue.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/26/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//
#import "POSAttributeValue.h"

@implementation POSAttributeValue


@synthesize name = _name;
@synthesize attribute_ID = _attribute_ID;
@synthesize ID = _ID;

+ (POSAttributeValue *)createNewAttributeValue:(NSString *)name withAttribute_ID:(int)attribute_ID {

    POSAttributeValue *newAttrValue;
    
    NSString *query = [NSString stringWithFormat:@"insert into attribute_value (name, attribute_id) values(\"%@\", %d); ", name, attribute_ID];
    
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        newAttrValue = [[POSAttributeValue alloc] init];
        newAttrValue.name = name;
        newAttrValue.attribute_ID = attribute_ID;
    }
    
    return newAttrValue;
}


+ (BOOL)updateAttributeValues:(NSMutableArray *)arr {
    
    BOOL result = NO;
    
    if ([arr count] > 0) {
        
        NSMutableString *query = [[NSMutableString alloc] init];
        
        for(POSAttributeValue *attrValue in arr) {
        
            [query appendString:[NSString stringWithFormat:@"update attribute_value \
                                                             set    name = \"%@\", \
                                                                    attribute_id = %d \
                                                             where  id = %d; ", attrValue.name, attrValue.attribute_ID, attrValue.ID]];
        }
        
        if ([dbWrapperInstance openDB]) {
            
            [dbWrapperInstance tryExecQuery:query];
            [dbWrapperInstance closeDB];
        }
    }
    else {
        
        result = YES;
    }
    
    return result;
}


@end
