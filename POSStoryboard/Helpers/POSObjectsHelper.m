//
//  POSObjectsHelper.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import "POSObjectsHelper.h"

@implementation POSObjectsHelper


@synthesize dataSet = _dataSet;
@synthesize categoriesMode = _categoriesMode;
@synthesize itemsMode = _itemsMode;
@synthesize currentCategoryIndex = _currentCategoryIndex;
@synthesize currentItemsIndex = _currentItemsIndex;


+ (POSObjectsHelper *)getInstance {
    
    static POSObjectsHelper* sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[POSObjectsHelper alloc] init];
        sharedInstance.dataSet = [[POSDataSet alloc] init];
    });
    
    return sharedInstance;
}


@end
