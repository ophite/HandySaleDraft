//
//  POSObjectsHelper.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/12/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSDataSet.h"

#define objectsHelperInstance [POSObjectsHelper getInstance]

@interface POSObjectsHelper : NSObject

@property (strong, nonatomic) POSDataSet  *dataSet;
@property BOOL catsMode;
@property BOOL goodsMode;

//Current position data
@property int currentCatIndex;
@property int currentItemsIndex;
@property int currentBasketID;

+(POSObjectsHelper *)getInstance;

@end
