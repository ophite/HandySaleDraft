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


- (BOOL)updateSetting:(NSString *)name withValue:(NSString *)value withType:(NSString *)type withImage_id:(int)image_id {
    
    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString *query = [NSString stringWithFormat:@"update   setting \
                                                       set      name = \"%@\", \
                                                                value = \"%@\", \
                                                                type = \"%@\", \
                                                                image_id = %d \
                                                       where    id = %d; ", name, value, type, image_id, self.ID];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        self.name = name;
        self.value = value;
        self.type = type;
        self.image_id = image_id;
        
        result = YES;
    }
    
    return result;
}


- (BOOL)updateSetting:(NSString *)value {
    
    return [self updateSetting: self.name
                     withValue: value
                      withType: self.type
                  withImage_id: self.image_id];
}


@end
