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
#import "POSCategoryAttribute.h"

@interface POSDataSet : NSObject


@property NSMutableArray *images;
@property NSMutableArray *settings;
@property NSMutableArray *orderArray;

@property NSMutableArray *items;
@property NSMutableArray *allItems;

@property NSMutableArray *attributes;
@property NSMutableArray *attributeValues;

@property NSMutableArray *categories;
@property NSMutableArray *categoriesAttributes;


- (id)init;

- (void)attributesGet;
- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesRemove:(POSAttribute *)attribute;

- (void)attributeValuesGet;
- (POSAttributeValue *)attributeValuesCreate:(NSString *)name withAttribute_ID:(int)attribute_ID;
- (BOOL)attributeValuesUpdate:(NSMutableArray *)arr;
- (BOOL)attributeValuesRemove:(POSAttributeValue *)attrValue;

- (void)settingsGet;
- (BOOL)settingsUpdate:(POSSetting *)setting withName:(NSString *)name withValue:(NSString *)value withType:(NSString *)type withImage_id:(int)image_id;
- (BOOL)settingsUpdate:(POSSetting *)setting withValue:(NSString *)value;

- (void)categoriesGet;

- (void)categoriesAttributesGet;
- (POSCategoryAttribute *)categoriesAttributesCreate:(POSCategory *)category withAttributeID:(POSAttribute *)attribute withIndex:(int)index;
- (BOOL)categoriesAttributesUpdate:(POSCategoryAttribute *)categoryAttribute withAttribute:(POSAttribute *)attribute;
- (BOOL)categoriesAttributesRemove:(POSCategoryAttribute *)categoryAttribute;

- (void)itemsGet;
- (void)itemsGetByCategory:(NSString *)selectedCategoryName;
- (BOOL)itemUpdate:(POSItem *)item withCategory:(POSCategory *)category;

- (void)gallerySave:(int)index withLibrary:(ALAssetsLibrary *)library;




@end

