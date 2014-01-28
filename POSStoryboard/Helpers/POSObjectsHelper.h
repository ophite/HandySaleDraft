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


//@property (strong, nonatomic) POSDataSet *dataSet;
@property BOOL itemsMode;
@property BOOL categoriesMode;
@property POSDataSet *dataSet;

// Current position data
@property int currentBasketsMode;
@property int currentCategoryIndex;
@property int currentItemsIndex;
@property int currentBasketID;


+ (POSObjectsHelper *)getInstance;


@end
