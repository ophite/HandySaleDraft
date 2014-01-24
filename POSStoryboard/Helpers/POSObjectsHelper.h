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
@property POSDataSet *dataSet;
@property BOOL categoriesMode;
@property BOOL itemsMode;

//Current position data
@property int currentCategoryIndex;
@property int currentItemsIndex;
@property int currentBasketID;


+ (POSObjectsHelper *)getInstance;


@end
