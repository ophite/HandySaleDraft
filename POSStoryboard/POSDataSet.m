//
//  POSDataSet.m
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import "POSDataSet.h"
#import <dispatch/dispatch.h>

@implementation POSDataSet

@synthesize images = _images;
@synthesize categories = _categories;
@synthesize items = _items;
@synthesize orderArray = _orderArray;
@synthesize allItems = _allItems;
@synthesize settings = _settings;
@synthesize attributes = _attributes;

- (id)init {
    
    self = [super init];
    
    self.images = [[NSMutableArray alloc] init];
    self.categories = [[NSMutableArray alloc] init];
    self.items = [[NSMutableArray alloc] init];
    self.allItems = [[NSMutableArray alloc] init];
    self.orderArray = [[NSMutableArray alloc] init];
    self.settings = [[NSMutableArray alloc] init];
    self.attributes = [[NSMutableArray alloc] init];
    
    //currentBasketID = 0;
       
    return self;
}


/*
-(void) getImages
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    if(sqlite3_open([dataPath UTF8String], &database) == SQLITE_OK)
    {
        query = [NSString stringWithFormat: @"SELECT id, asset, path, object_id, object_name FROM images"];
        sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                POSImage* image = [[POSImage alloc] init];
                
                const unsigned char* asset = sqlite3_column_text(statement, 1);
                
                if (asset != nil)
                    image.assetUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithUTF8String:(const char*)asset]];
                
                image.path = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                image.object_id = sqlite3_column_int(statement, 3);
                image.object_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                [library assetForURL: image.assetUrl resultBlock:^(ALAsset *asset) {
                    image.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        
                } failureBlock: ^(NSError* error) {
                    NSLog(@"%@", error.description);
                }];

                [images addObject:image];
            }
                
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
        
        NSLog(@"Read from DB");
    }
    else
    {
        //statusDB = NO;
        NSAssert(0, @"Failed to open database");
    }
}

*/


- (void)saveSettings {

    if ([self.settings count] == 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSMutableString *query = [[NSMutableString alloc] init];
    
    for (id object in self.settings) {
        
        POSSetting *settingObject = (POSSetting *)object;
        NSString *subQuery = [NSString stringWithFormat:@"update    setting    \
                                                          set       value = \"%@\" \
                                                          where     name = \"%@\"; ", settingObject.value, settingObject.name];
        [query appendString:subQuery];
    }
    
    [dbWrapperInstance tryExecQuery:query];
    [dbWrapperInstance closeDB];
}


- (void)getAttributes {

//    [self.attributes removeAllObjects];
    if ([self.attributes count] > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;

    NSString *query = [NSString stringWithFormat:@"select   name, is_active \
                                                   from     attribute;"];
    
    void(^getAttribute)(id rows) = ^(id rows) {
        
        POSAttribute *attrObject = [[POSAttribute alloc] init];
        attrObject.name = [dbWrapperInstance getCellText:0];
        attrObject.is_active = [dbWrapperInstance getCellInt:1];
        
        [((NSMutableArray *)rows) addObject:attrObject];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: getAttribute
                         andRows: self.attributes];
    [dbWrapperInstance closeDB];
}


- (void)getSettings {

    if ([self.settings count] > 0)
        return;
    
//    [self.settings removeAllObjects];

    if (![dbWrapperInstance openDB])
        return;
    
    NSString *query = [NSString stringWithFormat: @"select  name, value, type, image_id \
                                                    from    setting;"];
    
    void(^blockGetSetting)(id rows) = ^(id rows) {
      
        POSSetting *settingObject = [[POSSetting alloc] init];
        settingObject.name = [dbWrapperInstance getCellText:0];
        settingObject.value = [dbWrapperInstance getCellText:1];
        settingObject.type = [dbWrapperInstance getCellText:2];
        settingObject.image_id = [dbWrapperInstance getCellInt:3];
        
        [((NSMutableArray *)rows) addObject:settingObject];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetSetting
                         andRows: self.settings];
    [dbWrapperInstance closeDB];
}


- (void)getCategories {
    
    /*
    url            = [NSURL URLWithString:[NSString stringWithFormat:@"http://goods.itvik.com/api/collection/?token=%@", token]];
    request        = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    responseData        = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    responseString      = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    cat                 = (NSArray*)[responseDictionary objectForKey:@"collections"];
    requestSuccess      = [[responseDictionary objectForKey:@"success"] boolValue];
    timeStamp           = (NSString*) [responseDictionary objectForKey:@"tst"];
    */
    
    if (![dbWrapperInstance openDB])
        return;
    
    // TODO подумать может в будущем не удалять, а проверять что уже есть и ничего не делать
    [self.categories removeAllObjects];
    
    NSString * query = [NSString stringWithFormat: @"SELECT    c.id, c.name, i.asset \
                                                     FROM      collection c \
                                                     LEFT JOIN image i \
                                                     WHERE     i.object_id = c.id AND i.object_name = \"collection\" AND i.is_default = 1"];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
  
    void(^blockGetCategory)( id rows, ALAssetsLibrary * lib) = ^(id rows, id lib) {
        
        POSCategory* catObject = [[POSCategory alloc] init];
        catObject.ID = [dbWrapperInstance getCellInt:0];
        catObject.name = [dbWrapperInstance getCellText:1];
        catObject.asset = [dbWrapperInstance getCellText:2];
        
        if (catObject.asset != Nil && ![catObject.asset isEqualToString:@""])
        {
            NSURL * assetUrl = [[NSURL alloc] initWithString:catObject.asset];
            
            [((ALAssetsLibrary *)lib) assetForURL: assetUrl
                                      resultBlock:^(ALAsset *asset) {
                                          
                                          catObject.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                                      }
                                     failureBlock: ^(NSError* error) {
                                         
                                         NSLog(@"%@", error.description);
                                     }];
        }
        
        [((NSMutableArray *)rows) addObject:catObject];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetCategory
                         andRows: self.categories
                      andLibrary: library];
    [dbWrapperInstance closeDB];
}


- (void)getItems:(NSString*)selectedCatName {
    
    /*
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if(sqlite3_open([dataPath UTF8String], &database) == SQLITE_OK)
    {
        query = [NSString stringWithFormat:@"SELECT id FROM collection WHERE name= \"%@\" AND user_id = %d", selectedCatName, 1];
        sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
        sqlite3_step(statement);
        int catID = sqlite3_column_int(statement, 0);
        sqlite3_finalize(statement);
        
        NSLog(@"Category query=%@, catID = %d", query, catID);
        
        query = [NSString stringWithFormat: @"SELECT p.id, p.name, p.price_buy, p.price_sale, p.comment, i.asset FROM product p LEFT JOIN image i WHERE i.object_id = p.id AND i.object_name = \"product\" AND i.is_default = 1 AND p.collection_id = %d", catID];
        
        int i;
        
        i = 0;
        
        sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                POSItem* goodObject = [[POSItem alloc] init];
                goodObject.gallery = [[NSMutableArray alloc] init];                
                goodObject.ID = sqlite3_column_int(statement, 0);
                goodObject.name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];                
                goodObject.codeItem = @"001";
                goodObject.price1 = [[NSString alloc] initWithFormat:@"%f", (float)sqlite3_column_double(statement, 2)];
                goodObject.price2 = [[NSString alloc] initWithFormat:@"%f", (float)sqlite3_column_double(statement, 3)];
                goodObject.description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                goodObject.category = selectedCatName;
                goodObject.quantityAvailable = @"10";
                goodObject.quantityOrdered = @"0";
                goodObject.catID = catID;
                
                [goodObject.gallery addObject:[UIImage imageNamed:@"car9.png"]];
                [goodObject.gallery addObject:[UIImage imageNamed:@"car10.png"]];
                [goodObject.gallery addObject:[UIImage imageNamed:@"car11.png"]];
                [goodObject.gallery addObject:[UIImage imageNamed:@"car12.png"]];
                
                const unsigned char* asset = sqlite3_column_text(statement, 5);
                
                if (asset != nil)
                {
                    NSURL* assetUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithUTF8String:(const char *) asset]];
                    
                    [library assetForURL: assetUrl resultBlock:^(ALAsset *asset)
                    {
                        goodObject.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                        
                    }
                    
                    failureBlock: ^(NSError* error)
                    {
                        NSLog(@"%@", error.description);
                    }
                    ];
                }
                
                [items addObject:goodObject];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
        
        NSLog(@"items inserted = %d", [items count]);
    }
    else
    {
        //statusDB = NO;
        NSAssert(0, @"Failed to open database");
    }
    */
    
    [self.items removeAllObjects];
    //[allItems filterUsingPredicate:@"I"]
    POSItem* item;
    
    for(int i = 0; i<[self.allItems count]; i++) {
        item = [self.allItems objectAtIndex:i];
        
        if([item.category isEqualToString:selectedCatName])
            [self.items addObject:item];
    }
}


- (void)getAllItems {
    
    if(![dbWrapperInstance openDB])
        return;
    
    // TODO подумать может в будущем не удалять, а проверять что уже есть и ничего не делать
    [self.allItems removeAllObjects];

    NSString* query = [NSString stringWithFormat: @"SELECT    p.id, p.name, p.price_buy, p.price_sale, p.comment, i.asset, c.id, c.name \
                                                    FROM      product p, image i, collection c \
                                                    WHERE     i.object_id = p.id AND i.object_name = \"product\" AND i.is_default = 1 and c.id = p.collection_id"];
    
    void(^blockGetItems)(id rows) = ^(id rows) {
        
        POSItem* goodObject = [[POSItem alloc] init];
        goodObject.gallery = [[NSMutableArray alloc] init];
        goodObject.ID = [dbWrapperInstance getCellInt:0];
        goodObject.name = [dbWrapperInstance getCellText:1];
        goodObject.codeItem = @"001";
        goodObject.price1 = [[NSString alloc] initWithFormat:@"%f", [dbWrapperInstance getCellFloat:2]];
        goodObject.price2 = [[NSString alloc] initWithFormat:@"%f", [dbWrapperInstance getCellFloat:3]];
        goodObject.description = [dbWrapperInstance getCellText:4];
        goodObject.category =  [dbWrapperInstance getCellText:7];
        goodObject.quantityAvailable = @"10";
        goodObject.quantityOrdered = @"0";
        goodObject.catID = goodObject.ID = [dbWrapperInstance getCellInt:6];
        goodObject.asset = [dbWrapperInstance getCellText:5];
        
        [goodObject.gallery addObject:[UIImage imageNamed:@"car9.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car10.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car11.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car12.png"]];
        
        [((NSMutableArray* )rows) addObject:goodObject];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetItems
                         andRows: self.allItems];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    for (int i = 0; i < [self.allItems count]; i++) {
        
        POSItem* item= [self.allItems objectAtIndex:i];
        
        if (item.asset != Nil && ![item.asset isEqualToString:@""]) {
            
            NSURL* assetUrl = [[NSURL alloc] initWithString:item.asset];
            [library assetForURL: assetUrl resultBlock:^(ALAsset *asset) {
                
                 item.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
             }
             failureBlock: ^(NSError* error) {
                 
                 NSLog(@"%@", error.description);
             }];
        }
    }
    
    [dbWrapperInstance closeDB];
}


- (void)getOrderArray {

}


- (void)saveGallery:(int)index withLibrary:(ALAssetsLibrary*)library {
    
    if(index >= self.images.count)
        return;

    POSImage* posImage = [self.images objectAtIndex:index];

    if (posImage.assetUrl != nil) {
        
        [self saveGallery: index + 1
              withLibrary: library];
        return;
    }

    [library saveImage: posImage.image
               toAlbum: @"POS"
   withCompletionBlock: ^(NSURL* url, NSError *error) {
        
        NSString* query = [[NSString alloc] init];

        if (error != nil) {

            [self saveGallery: index
                  withLibrary: library];
            return;
        }
        else {
            
            posImage.assetUrl = url;
            
            if ([dbWrapperInstance openDB]) {
                
                query = [NSString stringWithFormat:@"UPDATE image \
                                                     SET    asset = \"%@\" \
                                                     where  path = \"%@\"", url, posImage.path];
                [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
            }

            [self saveGallery:index + 1 withLibrary:library];
        }
    }];
}


@end
