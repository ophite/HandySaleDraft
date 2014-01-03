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

- (void)attributesGet;
- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesDelete:(POSAttribute *)attribute;

- (void)attributeValuesGet;
- (POSAttributeValue *)attributeValuesCreate:(NSString *)name withAttribute_ID:(int)attribute_ID;
- (BOOL)attributeValuesUpdate:(NSMutableArray *)arr;
- (BOOL)attributeValuesDelete:(POSAttributeValue *)attrValue;

- (void)settingsGet;
//- (void)settingsSave;
- (BOOL)settingsUpdate:(POSSetting *)setting withName:(NSString *)name withValue:(NSString *)value withType:(NSString *)type withImage_id:(int)image_id;
- (BOOL)settingsUpdate:(POSSetting *)setting withValue:(NSString *)value;

- (void)categoriesGet;

- (void)itemsGet:(NSString *)selectedCategoryName;

- (void)allItemsGet;

- (void)gallerySave:(int)index withLibrary:(ALAssetsLibrary *)library;




@end

