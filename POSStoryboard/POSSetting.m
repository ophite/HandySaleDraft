//
//  POSSetting.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSSetting.h"

@implementation POSSetting


@synthesize name = _name;
@synthesize value = _value;
@synthesize type = _type;
@synthesize image_id = _image_id;
@synthesize ID = _ID;


+ (POSSetting *)getSetting:(NSMutableArray *)settings withName:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *arr = [settings filteredArrayUsingPredicate:predicate];
    POSSetting *value;
    
    if ([arr count] > 0) {
        
        value = ((POSSetting *)[arr objectAtIndex:0]);
    }
    
    return value;
}

+ (NSString *)getSettingValue:(NSMutableArray *)settings withName:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *arr = [settings filteredArrayUsingPredicate:predicate];
    NSString *value;
    
    if ([arr count] > 0) {
        
        value = ((POSSetting *)[arr objectAtIndex:0]).value;
    }
    
    return value;
}


@end
