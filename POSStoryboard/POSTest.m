//
//  POSTest.m
//  POS
//
//  Created by kolec on 21.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import "POSTest.h"

@implementation POSTest

-(void) initDBStructure
{
    POSDBWrapper* dbHelber = [POSDBWrapper getInstance];
    if ([dbHelber openDB] == NO)
        return;
    
    /*
    query = @"DROP TABLE IF EXISTS image";
    sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg);
    
    query = @"DROP TABLE IF EXISTS collection";
    sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg);

    query = @"DROP TABLE IF EXISTS product";
    sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg);
    
    query = @"DROP TABLE IF EXISTS document";
    sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg);
    
    query = @"DROP TABLE IF EXISTS document_line";
    sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg);
    */
    
    NSString* query =
    @"CREATE TABLE IF NOT EXISTS attribute ( \
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        owner_id INTEGER, \
        is_deleted BOOLEAN,\
        tst TIMESTAMP, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1))\
    );\
    CREATE TABLE IF NOT EXISTS attribute_value (\
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        attribute_id INTEGER NOT NULL, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(attribute_id) REFERENCES attribute (id)\
    );\
    CREATE TABLE IF NOT EXISTS collection (\
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        is_deleted BOOLEAN, \
        user_id INTEGER NOT NULL, \
        tst TIMESTAMP, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(user_id) REFERENCES user (id)\
    );\
    CREATE TABLE IF NOT EXISTS document (\
        id INTEGER NOT NULL, \
        date DATETIME, \
        client VARCHAR(255), \
        paid_price FLOAT, \
        document_type_id INTEGER NOT NULL, \
        user_id INTEGER NOT NULL, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        PRIMARY KEY (id), \
        FOREIGN KEY(document_type_id) REFERENCES document_type (id), \
        FOREIGN KEY(user_id) REFERENCES user (id), \
        CHECK (is_deleted IN (0, 1)) \
    ); \
    CREATE TABLE IF NOT EXISTS document_line ( \
        id INTEGER NOT NULL, \
        price FLOAT, \
        quantity FLOAT NOT NULL, \
        item_id INTEGER NOT NULL, \
        document_id INTEGER NOT NULL, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        PRIMARY KEY (id),\
        FOREIGN KEY(item_id) REFERENCES item (id), \
        FOREIGN KEY(document_id) REFERENCES document (id), \
        CHECK (is_deleted IN (0, 1)) \
    ); \
    CREATE TABLE IF NOT EXISTS document_type ( \
        id INTEGER NOT NULL, \
        code VARCHAR(128) NOT NULL, \
        PRIMARY KEY (id) \
    );\
    CREATE TABLE IF NOT EXISTS image (\
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        path VARCHAR(255) NOT NULL, \
        asset VARCHAR(255) NULL, \
        tst TIMESTAMP, \
        is_default BOOLEAN, \
        is_deleted BOOLEAN, \
        object_id INTEGER NOT NULL, \
        object_name VARCHAR(255) NOT NULL, \
        PRIMARY KEY (id),\
        CHECK (is_default IN (0, 1)), \
        CHECK (is_deleted IN (0, 1)) \
    ); \
    CREATE TABLE IF NOT EXISTS item ( \
        id INTEGER NOT NULL, \
        rest FLOAT, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        product_id INTEGER NOT NULL, \
        attribute_1_id INTEGER, \
        attribute_2_id INTEGER, \
        attribute_3_id INTEGER, \
        attribute_4_id INTEGER, \
        attribute_5_id INTEGER, \
        attribute_6_id INTEGER, \
        attribute_7_id INTEGER, \
        attribute_8_id INTEGER, \
        attribute_9_id INTEGER, \
        attribute_10_id INTEGER, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(product_id) REFERENCES product (id), \
        FOREIGN KEY(attribute_1_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_2_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_3_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_4_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_5_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_6_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_7_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_8_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_9_id) REFERENCES attribute_value (id), \
        FOREIGN KEY(attribute_10_id) REFERENCES attribute_value (id) \
    ); \
    CREATE TABLE IF NOT EXISTS login ( \
        token VARCHAR(255) NOT NULL, \
        expired DATETIME, \
        user_id INTEGER NOT NULL, \
        PRIMARY KEY (token), \
        FOREIGN KEY(user_id) REFERENCES user (id) \
    ); \
    CREATE TABLE IF NOT EXISTS product ( \
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        code VARCHAR(255), \
        price_buy FLOAT, \
        price_sale FLOAT, \
        comment VARCHAR(512), \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        user_id INTEGER NOT NULL, \
        collection_id INTEGER NOT NULL, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(user_id) REFERENCES user (id), \
        FOREIGN KEY(collection_id) REFERENCES collection (id) \
    ); \
    CREATE TABLE IF NOT EXISTS product_attribute ( \
        id INTEGER NOT NULL, \
        number INTEGER NOT NULL, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        product_id INTEGER NOT NULL, \
        attribute_id INTEGER NOT NULL, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(product_id) REFERENCES product (id), \
        FOREIGN KEY(attribute_id) REFERENCES attribute (id) \
    ); \
    CREATE TABLE IF NOT EXISTS user ( \
        id INTEGER NOT NULL, \
        email VARCHAR(255) NOT NULL, \
        password VARCHAR(128) NOT NULL, \
        first_name VARCHAR(255), \
        last_name VARCHAR(255), \
        is_deleted BOOLEAN, \
        PRIMARY KEY (id), \
        UNIQUE (email), \
        CHECK (is_deleted IN (0, 1))\
    );";
    
    [dbHelber tryExecQuery:query];
    [dbHelber closeDB];
}


-(void) testForeach
{
    POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
    if (![dbWrapper openDB])
        return;

    NSMutableArray * categories  = [[NSMutableArray alloc] init];
    NSString* query = [NSString stringWithFormat: @"SELECT    c.id, c.name, i.asset \
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


-(void) initDBData:(POSDataSet*) dataSet
{
    POSDBWrapper* dbWrapper = [POSDBWrapper getInstance];
    if ([dbWrapper openDB] == NO)
        return;

    NSString* query = @"SELECT count(*) FROM collection";
    int count = [dbWrapper execQueryResultInt:query p_index:0];

    if(count == 0)
    {
        query = @"INSERT INTO collection (name, user_id) VALUES (\"Nissan\", 1);\
        INSERT INTO collection (name, user_id) VALUES (\"Toyota\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Suzuki\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Mitsubishi\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Ford\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Subaru\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Citroen\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Renault\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"Mercedes\", 1); \
        INSERT INTO collection (name, user_id) VALUES (\"BMW\", 1);";
        
        [dbWrapper tryExecQuery:query];
    }
    
    query = @"SELECT count(*) FROM product";
    count = [dbWrapper execQueryResultInt:query p_index:0];
    
    if(count == 0)
    {
        query = [NSString stringWithFormat:@"SELECT id FROM collection WHERE name= \"%@\" AND user_id = %d", @"Nissan", 1];
        int catID = [dbWrapper execQueryResultInt:query p_index:0];

        query = [NSString stringWithFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"X-Trail\", 1, %d, 1000.0, 2000.0, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Pathfinder\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Qashqai\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Navara\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Note\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Almera\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Teana\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Z350\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Micra\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        query = [query stringByAppendingFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Tiida\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        
        [dbWrapper tryExecQuery:query];
    }

//    query = @"SELECT count(*) FROM product";
//    count = [dbWrapper execQueryResultInt:query p_index:0];
    
    query = @"SELECT count(*) FROM image";
    count = [dbWrapper execQueryResultInt:query p_index:0];

    if(count == 0)
    {
        query = @"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car01.png\", \"car01.png\", 1, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car02.png\", \"car02.png\", 2, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car03.png\", \"car03.png\", 3, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car4.png\", \"car4.png\", 4, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car5.png\", \"car5.png\", 5, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car6.png\", \"car6.png\", 6, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car7.png\", \"car7.png\", 7, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car8.png\", \"car8.png\", 8, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car9.png\", \"car9.png\", 9, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 10, \"collection\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car02.png\", \"car02.png\", 1, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car03.png\", \"car03.png\", 2, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car4.png\", \"car4.png\", 3, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car5.png\", \"car5.png\", 4, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car6.png\", \"car6.png\", 5, \"cproduct\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car7.png\", \"car7.png\", 6, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car8.png\", \"car8.png\", 7, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car9.png\", \"car9.png\", 8, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 9, \"product\", 1);\
        INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 10, \"product\", 1);";
        
        [dbWrapper tryExecQuery:query];
       
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car01.png"] withAsset:nil withPath:@"car01.png" withObject_id:1 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car02.png"] withAsset:nil withPath:@"car02.png" withObject_id:2 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car03.png"] withAsset:nil withPath:@"car03.png" withObject_id:3 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car4.png"] withAsset:nil withPath:@"car4.png" withObject_id:4 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car5.png"] withAsset:nil withPath:@"car5.png" withObject_id:5 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car6.png"] withAsset:nil withPath:@"car6.png" withObject_id:6 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car7.png"] withAsset:nil withPath:@"car7.png" withObject_id:7 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car8.png"] withAsset:nil withPath:@"car8.png" withObject_id:8 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car9.png"] withAsset:nil withPath:@"car9.png" withObject_id:9 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car10.png"] withAsset:nil withPath:@"car10.png" withObject_id:10 withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car11.png"] withAsset:nil withPath:@"car11.png" withObject_id:11 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car12.png"] withAsset:nil withPath:@"car12.png" withObject_id:12 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car13.png"] withAsset:nil withPath:@"car13.png" withObject_id:13 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car14.png"] withAsset:nil withPath:@"car14.png" withObject_id:14 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car15.png"] withAsset:nil withPath:@"car15.png" withObject_id:15 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car16.png"] withAsset:nil withPath:@"car16.png" withObject_id:16 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car17.png"] withAsset:nil withPath:@"car17.png" withObject_id:17 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car18.png"] withAsset:nil withPath:@"car18.png" withObject_id:18 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car19.png"] withAsset:nil withPath:@"car19.png" withObject_id:19 withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car20.png"] withAsset:nil withPath:@"car20.png" withObject_id:20 withObject_name:@"product"]];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [dataSet saveGallery:0 withLibrary:library];
    }
    
    [dbWrapper closeDB];
}

@end
