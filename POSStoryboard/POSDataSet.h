//
//  POSDataSet.h
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
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


@interface POSDataSet : NSObject


@property NSMutableArray *images;
@property NSMutableArray *categories;
@property NSMutableArray *items;
@property NSMutableArray *allItems;
@property NSMutableArray *orderArray;
@property NSMutableArray *settings;
@property NSMutableArray *attributes;
@property NSMutableArray *attributeValues;


- (id)init;
- (void)getAttributeValues;
//- (void)saveAttributeValues;
- (void)getAttributes;
- (void)saveAttributes;
- (void)getSettings;
- (void)saveSettings;
- (void)getCategories;
- (void)getItems:(NSString *)selectedCatName;
- (void)getAllItems;
- (void)saveGallery:(int)index withLibrary:(ALAssetsLibrary *)library;


@end

