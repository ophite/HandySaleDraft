//
//  POSObjectsManager.h
//  POSStoryboard
//
//  Created by kobernik.u on 1/24/14.
//  Copyright (c) 2014 kobernik.u. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CustomPhotoAlbum.h"
#import "POSDBWrapper.h"
#import "POSItem.h"
#import "POSImage.h"
#import "POSCategory.h"
#import "POSSetting.h"
#import "POSAttribute.h"
#import "POSAttributeValue.h"
#import "POSCategoryAttribute.h"
#import "POSGallery.h"
#import "POSBasket.h"
#import "POSOrder.h"
#import "POSObjectsHelper.h"
#import "POSDataSet.h"


@interface POSObjectsManager : NSObject


//attributes
- (void)attributesGet;
- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesRemove:(POSAttribute *)attribute;
- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active;


@end
