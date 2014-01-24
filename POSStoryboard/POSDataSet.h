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
#import "POSGallery.h"
#import "POSBasket.h"
#import "POSOrder.h"
#import "POSHelper.h"

@interface POSDataSet : NSObject

@property int ASYNC_IMAGES_COUNT;

@property NSMutableArray *images;
@property NSMutableArray *galleries;

@property NSMutableArray *settings;

@property NSMutableArray *baskets;
@property NSMutableArray *orders;

@property NSMutableArray *items;
@property NSMutableArray *allItems;

@property NSMutableArray *attributes;
@property NSMutableArray *attributeValues;

@property NSMutableArray *categories;
@property NSMutableArray *categoriesAttributes;


- (id)init;

// attributes
- (void)attributesGet;
- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active;
- (BOOL)attributesRemove:(POSAttribute *)attribute;

// attributesValues
- (void)attributeValuesGet;
- (POSAttributeValue *)attributeValuesCreate:(NSString *)name withAttribute_ID:(int)attribute_ID;
- (BOOL)attributeValuesUpdate:(NSMutableArray *)arr;
- (BOOL)attributeValuesRemove:(POSAttributeValue *)attrValue;

// settings
- (void)settingsGet;
- (BOOL)settingsUpdate:(POSSetting *)setting withValue:(NSString *)value;
- (BOOL)settingsUpdate: (POSSetting *)setting
              withName: (NSString *)name
             withValue: (NSString *)value
              withType: (NSString *)type
          withImage_id: (int)image_id;

// categories
- (void)categoriesGet;

// categoriesAttributes
- (void)categoriesAttributesGet;
- (POSCategoryAttribute *)categoriesAttributesCreate:(POSCategory *)category withAttributeID:(POSAttribute *)attribute withIndex:(int)index;
- (BOOL)categoriesAttributesUpdate:(POSCategoryAttribute *)categoryAttribute withAttribute:(POSAttribute *)attribute;
- (BOOL)categoriesAttributesRemove:(POSCategoryAttribute *)categoryAttribute;

// items
- (void)itemsGet;
- (void)itemsGetByCategory:(NSString *)selectedCategoryName;
- (BOOL)itemUpdate: (POSItem *)item
          withName: (NSString *)name
          withCode: (NSString *)code
      withPriceBuy: (NSString *)price_buy
     withPriceSale: (NSString *)price_sale
   withDescription: (NSString *)description
        withUserID: (int)userID
    withCategoryID: (int)categoryID;

// images/galleries
- (POSGallery *)galeriesCreate:(UIImage *)image withImageID:(int)imageID withProductID:(int)productID withAsset:(NSString *)asset;
- (void)imagesSave:(int)index withLibrary:(ALAssetsLibrary *)library;
- (void)imagesSaveWithAsyncCounter:(int)index withLibrary:(ALAssetsLibrary*)library;
- (POSImage *)imagesCreate: (UIImage *)image
                  withName: (NSString *)name
                  withPath: (NSString *)path
              withObjectID: (int)object_id
            withObjectName: (NSString *)object_name
             withIsDefault: (BOOL)is_dafault;

// baskets
- (void)basketsGet;
- (void)basketsGet:(int)basketID;
- (POSBasket *)basketsCreate:(float)paid_price withDocumentTypeID:(int)documentTypeID withUserID:(int)userID;
- (void)basketsUpdate:(int)ID withPaidPrice:(float)paidPrice;


@end

