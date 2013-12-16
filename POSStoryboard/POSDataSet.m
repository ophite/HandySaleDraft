//
//  POSDataSet.m
//  POS
//
//  Created by Pavel Slusar on 6/1/13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import "POSDataSet.h"

@implementation POSDataSet

@synthesize images, categories, items, orderArray, allItems;

-(id) init
{
    self = [super init];
    
    images          = [[NSMutableArray alloc] init];
    categories      = [[NSMutableArray alloc] init];
    items           = [[NSMutableArray alloc] init];
    allItems        = [[NSMutableArray alloc] init];
    orderArray      = [[NSMutableArray alloc] init];
    
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

-(void) getCategories
{
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
    POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
    if ([dbWrapper openDB]) {
       NSString * query = [NSString stringWithFormat: @"SELECT    c.id, c.name, i.asset \
                                                       FROM      collection c \
                                                                 LEFT JOIN image i \
                                                       WHERE     i.object_id = c.id AND i.object_name = \"collection\" AND i.is_default = 1"];
        
        void (^blockGetCategory)( id rows) = ^(id rows)
        {
            POSCategory* catObject = [[POSCategory alloc] init];
            catObject.ID = [dbWrapper getCellInt:0];
            catObject.name = [dbWrapper getCellText:1];
            catObject.asset = [dbWrapper getCellText:2];
            
            [((NSMutableArray *)rows) addObject:catObject];
        };
        
        [dbWrapper fetchRows:query foreachCallback:blockGetCategory p_rows:categories];
        
        // Prepare image
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        for (int i = 0; i < [categories count]; i++)
        {
            POSCategory * catObject = [categories objectAtIndex:i];
            
            if ( catObject.asset != Nil && ![catObject.asset isEqualToString:@""])
            {
                NSURL* assetUrl = [[NSURL alloc] initWithString:catObject.asset];
                [library assetForURL: assetUrl resultBlock:^(ALAsset *asset)
                 {
                     catObject.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                 }
                        failureBlock: ^(NSError* error)
                 {
                     NSLog(@"%@", error.description);
                 }];
            }
        }
        
        [dbWrapper closeDB];
    }
}


-(void) getItems: (NSString*) selectedCatName
{
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
    
    [items removeAllObjects];
    //[allItems filterUsingPredicate:@"I"]
    POSItem* item;
    for(int i = 0; i<[allItems count]; i++)
    {
        item = [allItems objectAtIndex:i];
        if([item.category isEqualToString:selectedCatName]) [items addObject:item];
    }
}

-(void) getAllItems
{
    POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
    if(![dbWrapper openDB])
        return;

    NSString* query = [NSString stringWithFormat: @"SELECT    p.id, p.name, p.price_buy, p.price_sale, p.comment, i.asset, c.id, c.name \
                                        FROM      product p, image i, collection c \
                                        WHERE     i.object_id = p.id AND i.object_name = \"product\" AND i.is_default = 1 and c.id = p.collection_id"];
    
    void (^blockGetItems)(id rows) = ^(id rows)
    {
        POSItem* goodObject = [[POSItem alloc] init];
        goodObject.gallery = [[NSMutableArray alloc] init];
        goodObject.ID = [dbWrapper getCellInt:0];
        goodObject.name = [dbWrapper getCellText:1];
        goodObject.codeItem = @"001";
        goodObject.price1 = [[NSString alloc] initWithFormat:@"%f", [dbWrapper getCellFloat:2]];
        goodObject.price2 = [[NSString alloc] initWithFormat:@"%f", [dbWrapper getCellFloat:3]];
        goodObject.description = [dbWrapper getCellText:4];
        goodObject.category =  [dbWrapper getCellText:7];
        goodObject.quantityAvailable = @"10";
        goodObject.quantityOrdered = @"0";
        goodObject.catID = goodObject.ID = [dbWrapper getCellInt:6];
        goodObject.asset = [dbWrapper getCellText:5];
        
        [goodObject.gallery addObject:[UIImage imageNamed:@"car9.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car10.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car11.png"]];
        [goodObject.gallery addObject:[UIImage imageNamed:@"car12.png"]];
        
        
        [((NSMutableArray* )rows) addObject:goodObject];
    };
    
    [dbWrapper fetchRows:query foreachCallback:blockGetItems p_rows:allItems];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    for (int i = 0; i < [allItems count]; i++)
    {
        POSItem* item= [allItems objectAtIndex:i];
        
        if (item.asset != Nil && ![item.asset isEqualToString:@""])
        {
            NSURL* assetUrl = [[NSURL alloc] initWithString:item.asset];
            [library assetForURL: assetUrl resultBlock:^(ALAsset *asset)
             {
                 item.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
             }
            failureBlock: ^(NSError* error)
             {
                 NSLog(@"%@", error.description);
             }];
        }
    }
    
    [dbWrapper closeDB];
}

-(void) getOrderArray
{

}

-(void)saveGallery:(int)index withLibrary:(ALAssetsLibrary*)library
{
    if(index >= images.count)
        return;

    POSImage* posImage = [images objectAtIndex:index];

    if (posImage.assetUrl != nil)
    {
        [self saveGallery:index + 1 withLibrary:library];
        return;
    }

    [library saveImage:posImage.image toAlbum:@"POS" withCompletionBlock:^(NSURL* url, NSError *error)
    {
        NSString* query = [[NSString alloc] init];

        if (error != nil)
        {
            [self saveGallery:index withLibrary:library];
            return;
        }
        else
        {
            posImage.assetUrl = url;
            
            POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
            if ([dbWrapper openDB])
            {
                query = [NSString stringWithFormat:@"UPDATE image SET asset = \"%@\" where path = \"%@\"", url, posImage.path];
                [dbWrapper tryExecQuery:query];
                [dbWrapper closeDB];
            }

            [self saveGallery:index + 1 withLibrary:library];
        }
    }];
}

@end
