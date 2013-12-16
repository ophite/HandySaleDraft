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

@interface POSDataSet : NSObject
{
    NSMutableArray*         images;
    NSMutableArray*         categories;
    NSMutableArray*         items;
    NSMutableArray*         allItems;
    NSMutableArray*         orderArray;
}

@property NSMutableArray*       images;
@property NSMutableArray*       categories;
@property NSMutableArray*       items;
@property NSMutableArray*       allItems;
@property NSMutableArray*       orderArray;

- (id) init;
- (void) getCategories;
- (void) getItems: (NSString*) selectedCatName;
- (void) getAllItems;
- (void) saveGallery:(int)index withLibrary:(ALAssetsLibrary*)library;

@end
