//
//  POSDBHelper.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSDBHelper.h"

@implementation POSDBHelper


-(POSDBWrapper* ) getWrapper
{
    POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
    
    return dbWrapper;
}


+(POSDBHelper *)getInstance
{
    static POSDBHelper* sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[POSDBHelper alloc] init];
    });
    
    return sharedInstance;
}


@end
