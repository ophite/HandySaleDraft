//
//  POSDataSet.h
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomPhotoAlbum.h"

@interface POSDataSet : NSObject

{
    //Main data arrays
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
- (void) loadData;
- (void) getCategories;
- (void) getItems: (NSString*) selectedCatName;
- (void) getAllItems;
- (void) saveGallery:(int)index withLibrary:(ALAssetsLibrary*)library;

@end
