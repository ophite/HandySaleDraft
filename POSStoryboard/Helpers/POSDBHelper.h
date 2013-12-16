//
//  POSDBHelper.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSDBWrapper.h"

@interface POSDBHelper : NSObject

+(POSDBHelper *)getInstance;
-(BOOL) isUserHasCorrectPassword:(NSString* )email p_password:(NSString* )password;
-(BOOL) registerNewUser:(NSString* )email p_password:(NSString* )password;
-(POSDBWrapper* ) getWrapper;

@end
