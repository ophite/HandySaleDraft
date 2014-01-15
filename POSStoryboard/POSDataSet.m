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
@synthesize settings = _settings;
@synthesize orderArray = _orderArray;

@synthesize items = _items;
@synthesize allItems = _allItems;

@synthesize categories = _categories;
@synthesize categoriesAttributes = _categoriesAttributes;

@synthesize attributes = _attributes;
@synthesize attributeValues = _attributeValues;


- (id)init {
    
    self = [super init];
    
    self.images = [[NSMutableArray alloc] init];
    self.settings = [[NSMutableArray alloc] init];
    self.orderArray = [[NSMutableArray alloc] init];

    self.items = [[NSMutableArray alloc] init];
    self.allItems = [[NSMutableArray alloc] init];

    self.attributes = [[NSMutableArray alloc] init];
    self.attributeValues = [[NSMutableArray alloc] init];

    self.categories = [[NSMutableArray alloc] init];
    self.categoriesAttributes = [[NSMutableArray alloc] init];
    
    //currentBasketID = 0;
       
    return self;
}


#pragma mark - Attributes

- (void)attributesGet {
    
    if ([self.attributes count] > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString *query = [NSString stringWithFormat:@"select   name, is_active, id \
                                                   from     attribute;"];
    
    void(^getAttribute)(id rows) = ^(id rows) {
        
        POSAttribute *object = [[POSAttribute alloc] init];
        object.name = [dbWrapperInstance getCellText:0];
        object.is_active = [dbWrapperInstance getCellInt:1];
        object.ID = [dbWrapperInstance getCellInt:2];
        
        [((NSMutableArray *)rows) addObject:object];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: getAttribute
                         andRows: self.attributes];
    [dbWrapperInstance closeDB];
}

- (POSAttribute *)attributesCreate:(NSString *)name withIs_active:(BOOL)is_active {
    
    POSAttribute *newAttr;
    NSString *query = [NSString stringWithFormat:@"insert into attribute (name, is_active) \
                                                   values (\"%@\", %d); ", name, is_active];
   
    if ([dbWrapperInstance openDB]) {
        
        int newID = [dbWrapperInstance tryCreateNewRow:query];
        [dbWrapperInstance closeDB];
        
        newAttr = [[POSAttribute alloc] init];
        newAttr.name = name;
        newAttr.is_active = is_active;
        newAttr.ID = newID;
        
        [self.attributes addObject:newAttr];
    }
    
    return newAttr;
}

- (BOOL)attributesUpdate:(POSAttribute *)attribute withName:(NSString *)name withIs_active:(BOOL)is_active {
    
    BOOL result = NO;
    NSString *query = [NSString stringWithFormat:@"update   attribute \
                                                   set      name = \"%@\", \
                                                            is_active = %d \
                                                   where    id = %d; ", name, is_active, attribute.ID];
    
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        attribute.name = name;
        attribute.is_active = is_active;
        result = YES;
    }
    
    return result;
}

- (BOOL)attributesRemove:(POSAttribute *)attribute {

    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
    
        NSMutableString *query = [NSMutableString stringWithFormat:@"delete \
                                                                     from   attribute_value \
                                                                     where  attribute_id = %d; ", attribute.ID];
        [query appendString:[NSString stringWithFormat:@"delete \
                                                         from   attribute \
                                                         where  id = %d; ", attribute.ID]];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute_ID = %d", attribute.ID];
        NSArray *arr = [self.attributeValues filteredArrayUsingPredicate:predicate];
        
        for(POSAttributeValue *attrValue in arr) {
            
            [self.attributeValues removeObject:attrValue];
        }
        
        [self.attributes removeObject:attribute];
        
        result = YES;
    }
    
    return result;
}


#pragma mark - Settings

- (void)settingsGet {
    
    if ([self.settings count] > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString *query = [NSString stringWithFormat: @"select  name, value, type, image_id, id \
                                                    from    setting;"];
    
    void(^blockGetSetting)(id rows) = ^(id rows) {
        
        POSSetting *object = [[POSSetting alloc] init];
        object.name = [dbWrapperInstance getCellText:0];
        object.value = [dbWrapperInstance getCellText:1];
        object.type = [dbWrapperInstance getCellText:2];
        object.image_id = [dbWrapperInstance getCellInt:3];
        object.ID = [dbWrapperInstance getCellInt:4];
        
        [((NSMutableArray *)rows) addObject:object];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetSetting
                         andRows: self.settings];
    [dbWrapperInstance closeDB];
}
//
//- (void)settingsSave {
//    
//    if ([self.settings count] == 0)
//        return;
//    
//    if (![dbWrapperInstance openDB])
//        return;
//    
//    NSMutableString *query = [[NSMutableString alloc] init];
//    
//    for (id object in self.settings) {
//        
//        POSSetting *settingObject = (POSSetting *)object;
//        NSString *subQuery = [NSString stringWithFormat:@"update    setting    \
//                                                          set       value = \"%@\" \
//                                                          where     name = \"%@\"; ", settingObject.value, settingObject.name];
//        [query appendString:subQuery];
//    }
//    
//    [dbWrapperInstance tryExecQuery:query];
//    [dbWrapperInstance closeDB];
//}

- (BOOL)settingsUpdate:(POSSetting *)setting withName:(NSString *)name withValue:(NSString *)value withType:(NSString *)type withImage_id:(int)image_id {

    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString *query = [NSString stringWithFormat:@"update   setting \
                                                       set      name = \"%@\", \
                                                                value = \"%@\", \
                                                                type = \"%@\", \
                                                                image_id = %d \
                                                       where    id = %d; ", name, value, type, image_id, setting.ID];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        setting.name = name;
        setting.value = value;
        setting.type = type;
        setting.image_id = image_id;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)settingsUpdate:(POSSetting *)setting withValue:(NSString *)value {

    return [self settingsUpdate: setting
                       withName: setting.name
                      withValue: value
                       withType: setting.type
                   withImage_id: setting.image_id];
}



#pragma mark - AttributeValues

- (void)attributeValuesGet {
    
    if ([self.attributeValues count] > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString *query = [NSString stringWithFormat:@"select   name, attribute_id, id \
                                                   from     attribute_value;"];
    
    void(^getAttributeValue)(id rows) = ^(id rows) {
        
        POSAttributeValue *attrValueObject = [[POSAttributeValue alloc] init];
        attrValueObject.name = [dbWrapperInstance getCellText:0];
        attrValueObject.attribute_ID = [dbWrapperInstance getCellInt:1];
        attrValueObject.ID = [dbWrapperInstance getCellInt:2];
        
        [((NSMutableArray *)rows) addObject:attrValueObject];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: getAttributeValue
                         andRows: self.attributeValues];
    [dbWrapperInstance closeDB];
}

- (POSAttributeValue *)attributeValuesCreate:(NSString *)name withAttribute_ID:(int)attribute_ID {

    POSAttributeValue *newAttrValue;
    NSString *query = [NSString stringWithFormat:@"insert into attribute_value (name, attribute_id) \
                                                   values(\"%@\", %d); ", name, attribute_ID];
    
    if ([dbWrapperInstance openDB]) {
        
        int newID = [dbWrapperInstance tryCreateNewRow:query];
        [dbWrapperInstance closeDB];
        
        newAttrValue = [[POSAttributeValue alloc] init];
        newAttrValue.name = name;
        newAttrValue.attribute_ID = attribute_ID;
        newAttrValue.ID = newID;
        
        [self.attributeValues addObject:newAttrValue];
    }
    
    return newAttrValue;
}

- (BOOL)attributeValuesUpdate:(NSMutableArray *)arr {

    BOOL result = NO;
    
    if ([arr count] > 0) {
        
        NSMutableString *query = [[NSMutableString alloc] init];
        
        for(POSAttributeValue *attrValue in arr) {
            
            [query appendString:[NSString stringWithFormat:@"update attribute_value \
                                                             set    name = \"%@\", \
                                                             attribute_id = %d \
                                                             where  id = %d; ", attrValue.name, attrValue.attribute_ID, attrValue.ID]];
        }
        
        if ([dbWrapperInstance openDB]) {
            
            [dbWrapperInstance tryExecQuery:query];
            [dbWrapperInstance closeDB];
        }
    }
    else {
        
        result = YES;
    }
    
    return result;
}

- (BOOL)attributeValuesRemove:(POSAttributeValue *)attrValue {
    
    BOOL result = NO;
    
    if ([dbWrapperInstance openDB]) {
        
        NSString *query = [NSString stringWithFormat:@"delete   \
                                                       from     attribute_value \
                                                       where    id = %d;", attrValue.ID];
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        [self.attributeValues removeObject:attrValue];
        
        result = YES;
    }
    
    return result;
}


#pragma mark - Categories

- (void)categoriesGet {
    
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
    
    if (self.categories.count > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = [NSString stringWithFormat: @"SELECT     c.id, c.name, i.asset \
                                                     FROM       collection c \
                                                     LEFT JOIN  image i \
                                                     WHERE      i.object_id = c.id AND i.object_name = \"collection\" AND i.is_default = 1; "];
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
  
    void(^blockGetCategory)( id rows, ALAssetsLibrary * lib) = ^(id rows, id lib) {
        
        POSCategory* object = [[POSCategory alloc] init];
        object.ID = [dbWrapperInstance getCellInt:0];
        object.name = [dbWrapperInstance getCellText:1];
        object.asset = [dbWrapperInstance getCellText:2];
        
        if (object.asset != Nil && ![object.asset isEqualToString:@""]) {
            
            NSURL * assetUrl = [[NSURL alloc] initWithString:object.asset];
            
            [((ALAssetsLibrary *)lib) assetForURL: assetUrl
                                      resultBlock:^(ALAsset *asset) {
                                          
                                          object.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                                      }
                                     failureBlock: ^(NSError* error) {
                                         
                                         NSLog(@"%@", error.description);
                                     }];
        }
        
        [((NSMutableArray *)rows) addObject:object];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetCategory
                         andRows: self.categories
                      andLibrary: library];
    [dbWrapperInstance closeDB];
}


#pragma mark - CategoriesAttributes

- (void)categoriesAttributesGet {
    
    if (self.categoriesAttributes.count > 0)
        return;
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = [NSString stringWithFormat: @"SELECT     c.id, c.collection_id, c.attribute_id, c.attributeIndex, a.name \
                                                     FROM       collection_attribute c \
                                                     INNER JOIN attribute a on a.ID = c.attribute_id; "];
    
    void(^blockGetCategoryAttribute)( id rows) = ^(id rows) {
        
        POSCategoryAttribute *object = [[POSCategoryAttribute alloc] init];
        object.ID = [dbWrapperInstance getCellInt:0];
        object.categoryID = [dbWrapperInstance getCellInt:1];
        object.attributeID = [dbWrapperInstance getCellInt:2];
        object.index = [dbWrapperInstance getCellInt:3];
        object.name = [dbWrapperInstance getCellText:4];
        
        [((NSMutableArray *)rows) addObject:object];
    };
    
    [dbWrapperInstance fetchRows: query
              andForeachCallback: blockGetCategoryAttribute
                         andRows: self.categoriesAttributes];
    [dbWrapperInstance closeDB];
}

- (POSCategoryAttribute *)categoriesAttributesCreate:(POSCategory *)category withAttributeID:(POSAttribute *)attribute withIndex:(int)index {
    
    POSCategoryAttribute *newCategoryAttribute;
    NSString *query = [NSString stringWithFormat:@"insert into collection_attribute (collection_id, attribute_id, attributeIndex) \
                                                   values(%d, %d, %d); ", category.ID, attribute.ID, index];
    
    if ([dbWrapperInstance openDB]) {
        
        int newID = [dbWrapperInstance tryCreateNewRow:query];
        [dbWrapperInstance closeDB];
        
        newCategoryAttribute = [[POSCategoryAttribute alloc] init];
        newCategoryAttribute.categoryID = category.ID;
        newCategoryAttribute.attributeID = attribute.ID;
        newCategoryAttribute.index = index;
        newCategoryAttribute.name = attribute.name;
        newCategoryAttribute.ID = newID;
        
        [self.categoriesAttributes addObject:newCategoryAttribute];
    }
    
    return newCategoryAttribute;

}

- (BOOL)categoriesAttributesUpdate:(POSCategoryAttribute *)categoryAttribute withAttribute:(POSAttribute *)attribute {
    
    BOOL result = NO;
    
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendString:[NSString stringWithFormat:@"update collection_attribute \
                                                     set    attribute_id = %d \
                                                     where  ID = %d; ", attribute.ID, categoryAttribute.ID]];
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        result = YES;
        
        categoryAttribute.name = attribute.name;
        categoryAttribute.attributeID = attribute.ID;
    }
    
    return result;
}

- (BOOL)categoriesAttributesRemove:(POSCategoryAttribute *)categoryAttribute {
   
    BOOL result = NO;
    
    NSMutableString *query = [NSMutableString stringWithFormat:@"delete \
                                                                 from   collection_attribute \
                                                                 where  ID = %d; ", categoryAttribute.ID];
    if ([dbWrapperInstance openDB]) {
        
        [dbWrapperInstance tryExecQuery:query];
        [dbWrapperInstance closeDB];
        
        [self.categoriesAttributes removeObject:categoryAttribute];
        result = YES;
    }
    
    return result;
}


#pragma mark - Items

- (void)itemsGet:(NSString*)selectedCategoryName {
    
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

    if (self.items.count > 0)
        return;
    
    //[allItems filterUsingPredicate:@"I"]
    POSItem* item;
    
    for(int i = 0; i < [self.allItems count]; i++) {
        
        item = [self.allItems objectAtIndex:i];
        if([item.category isEqualToString:selectedCategoryName]) {
            
            [self.items addObject:item];
        }
    }
}


#pragma mark - All items

- (void)allItemsGet {
    
    if (self.allItems.count > 0)
        return;
    
    if(![dbWrapperInstance openDB])
        return;
    
    NSString* query = [NSString stringWithFormat: @"SELECT  p.id, p.name, p.price_buy, p.price_sale, p.comment, i.asset, c.id, c.name \
                                                    FROM    product p, image i, collection c \
                                                    WHERE   i.object_id = p.id AND i.object_name = \"product\" AND i.is_default = 1 and c.id = p.collection_id"];
    
    void(^blockGetItems)(id rows) = ^(id rows) {
        
        POSItem* goodObject = [[POSItem alloc] init];
        goodObject.gallery = [[NSMutableArray alloc] init];
        goodObject.codeItem = @"001";
        goodObject.quantityAvailable = @"10";
        goodObject.quantityOrdered = @"0";
        goodObject.ID = [dbWrapperInstance getCellInt:0];
        goodObject.name = [dbWrapperInstance getCellText:1];
        goodObject.price1 = [[NSString alloc] initWithFormat:@"%f", [dbWrapperInstance getCellFloat:2]];
        goodObject.price2 = [[NSString alloc] initWithFormat:@"%f", [dbWrapperInstance getCellFloat:3]];
        goodObject.description = [dbWrapperInstance getCellText:4];
        goodObject.category =  [dbWrapperInstance getCellText:7];
        goodObject.asset = [dbWrapperInstance getCellText:5];
        goodObject.catID = goodObject.ID = [dbWrapperInstance getCellInt:6];
        
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


#pragma mark - Order

- (void)getOrderArray {

}


#pragma mark - Images

- (void)gallerySave:(int)index withLibrary:(ALAssetsLibrary*)library {
    
    if(index >= self.images.count)
        return;

    POSImage* posImage = [self.images objectAtIndex:index];

    if (posImage.assetUrl != nil) {
        
        [self gallerySave: index + 1
              withLibrary: library];
        
        return;
    }

    [library saveImage: posImage.image
               toAlbum: @"POS"
   withCompletionBlock: ^(NSURL* url, NSError *error) {
        
        NSString* query = [[NSString alloc] init];

        if (error != nil) {

            [self gallerySave: index
                  withLibrary: library];
            return;
        }
        else {
            
            posImage.assetUrl = url;
            
            if ([dbWrapperInstance openDB]) {
                
                query = [NSString stringWithFormat:@"UPDATE image \
                                                     SET    asset = \"%@\" \
                                                     where  path = \"%@\"; ", url, posImage.path];
                [dbWrapperInstance tryExecQuery:query];
                [dbWrapperInstance closeDB];
            }

            [self gallerySave:index + 1 withLibrary:library];
        }
    }];
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


@end
