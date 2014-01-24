//
//  POSObjectsManager.m
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//

#import "POSObjectsManager.h"

@implementation POSObjectsManager


#pragma mark - Attributes

- (void)attributesGet {
    
    if ([objectsHelperInstance.dataSet.attributes count] > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString *query = [NSString stringWithFormat:@"select   name, is_active, id \
                                                   from     attribute;"];
    
    void(^getAttribute)(id rows) = ^(id rows) {
        
        POSAttribute *object = [[POSAttribute alloc] init];
        object.name = [dbWrapperInstance getCellText:0];
        object.is_active = [dbWrapperInstance getCellInt:1];
        object.ID = [dbWrapperInstance getCellInt:2];
        
        [((NSMutableArray *)rows) addObject:object];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: getAttribute
                         andRows: objectsHelperInstance.dataSet.attributes];
    [dbWrapperInstance closeDB];
}

- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active {
    
    POSAttribute *newAttr;
    NSString *query = [NSString stringWithFormat:@"insert into attribute (name, is_active) \
                                                   values (\"%@\", %d); ", name, is_active];
    
    if ([dbWrapperInstance openDB]) {
        
        int newID = [dbWrapperInstance tryCreateNewRow:query];
        [dbWrapperInstance closeDB];
        
        newAttr = [[POSAttribute alloc] init];
        newAttr.name = name;
        newAttr.is_active = is_active;
        newAttr.ID = newID;
        
        [objectsHelperInstance.dataSet.attributes addObject:newAttr];
    }
    
    return newAttr;
}

- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active {
    
    BOOL result = NO;
    NSString *query = [NSString stringWithFormat:@"update   attribute \
                                                   set      name = \"%@\", \
                                                   is_active = %d \
                                                   where    id = %d; ", name, is_active, attribute.ID];
    
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        attribute.name = name;
        attribute.is_active = is_active;
        result = YES;
    }
    
    return result;
}

- (BOOL)attributesRemove:(POSAttribute *)attribute {
    
    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSMutableString *query = [NSMutableString stringWithFormat:@"delete \
                                                                      from   attribute_value \
                                                                      where  attribute_id = %d; ", attribute.ID];
        [query appendString:[NSString stringWithFormat:@"delete \
                                                         from   attribute \
                                                         where  id = %d; ", attribute.ID]];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute_ID = %d", attribute.ID];
        NSArray *arr = [objectsHelperInstance.dataSet.attributeValues filteredArrayUsingPredicate:predicate];
        
        for(POSAttributeValue *attrValue in arr) {
            
            [objectsHelperInstance.dataSet.attributeValues removeObject:attrValue];
        }
        
        [objectsHelperInstance.dataSet.attributes removeObject:attribute];
        
        result = YES;
    }
    
    return result;
}


@end