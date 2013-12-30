//
//  POSSetting.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/24/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSDBWrapper.h"

@interface POSSetting : NSObject


@property NSString *name;
@property NSString *value;
@property NSString *type;
@property int image_id;
@property int ID;


- (BOOL)updateSetting:(NSString *)name withValue:(NSString *)value withType:(NSString *)type withImage_id:(int)image_id;
- (BOOL)updateSetting:(NSString *)name;

@end
