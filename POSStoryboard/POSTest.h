//
//  POSTest.h
//  POS
//
//  Created by kolec on 21.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "POSImage.h"
#import "POSCategory.h"
#import "POSDataSet.h"
#import "POSHelper.h"

@interface POSTest : NSObject

- (void)initDBStructure;
- (void)initDBData:(POSDataSet*)dataSet;

@end
