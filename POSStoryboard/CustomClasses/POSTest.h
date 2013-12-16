//
//  POSTest.h
//  POS
//
//  Created by kolec on 21.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POSItem.h"
#import "POSCategory.h"
#import "POSAppDelegate.h"
#import "CustomPhotoAlbum.h"

@interface POSTest : NSObject

-(void) initDBStructure;
-(void) initDBData:(POSDataSet*) dataSet;

@end
