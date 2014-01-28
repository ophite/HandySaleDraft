//
//  POSTest.m
//  POS
//
//  Created by kolec on 21.06.13.
//  Copyright (c) 2013 IT Vik. All rights reserved.
//

#import "POSTest.h"

@implementation POSTest

- (void)initDBStructure {
    
    if (![dbWrapperInstance openDB])
        return;
    
    NSString * query = [[NSString alloc] init];

//    query = @"DROP TABLE IF EXISTS attribute";
//    [dbWrapperInstance tryExecQuery:query];
//
//    query = @"DROP TABLE IF EXISTS image";
//    [dbWrapperInstance tryExecQuery:query];
//
//    query = @"DROP TABLE IF EXISTS collection";
//    [dbWrapperInstance tryExecQuery:query];
//
    query = @"DROP TABLE IF EXISTS collection_attribute";
    [dbWrapperInstance tryExecQuery:query];
//
//    query = @"DROP TABLE IF EXISTS product";
//    [dbWrapperInstance tryExecQuery:query];
//
//    query = @"DROP TABLE IF EXISTS document";
//    [dbWrapperInstance tryExecQuery:query];
//    
//    query = @"DROP TABLE IF EXISTS document_line";
//    [dbWrapperInstance tryExecQuery:query];
    
    query = @"DROP TABLE IF EXISTS setting";
    [dbWrapperInstance tryExecQuery:query];
//
//    query = @"DROP TABLE IF EXISTS gallery";
//    [dbWrapperInstance tryExecQuery:query];
    
    query =
    @"CREATE TABLE IF NOT EXISTS attribute ( \
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        owner_id INTEGER, \
        is_deleted BOOLEAN,\
        is_active BOOLEAN,\
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
    CREATE TABLE IF NOT EXISTS collection_attribute (\
        id INTEGER NOT NULL, \
        is_deleted BOOLEAN, \
        tst TIMESTAMP, \
        collection_id INTEGER NOT NULL, \
        attribute_id INTEGER NOT NULL, \
        attributeIndex INTEGER NOT NULL, \
        PRIMARY KEY (id), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(collection_id) REFERENCES collection (id)\
        FOREIGN KEY(attribute_id) REFERENCES attribute (id)\
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
    ); \
    CREATE TABLE IF NOT EXISTS setting ( \
        id INTEGER NOT NULL, \
        name VARCHAR(255) NOT NULL, \
        value VARCHAR(128) NOT NULL, \
        type VARCHAR(255), \
        is_deleted BOOLEAN, \
        image_id INTEGER, \
        PRIMARY KEY (id), \
        UNIQUE (name), \
        CHECK (is_deleted IN (0, 1)), \
        FOREIGN KEY(image_id) REFERENCES image (id) \
    ); \
    CREATE TABLE IF NOT EXISTS gallery ( \
        id INTEGER NOT NULL, \
        image_id INTEGER NOT NULL, \
        product_id INTEGER NOT NULL, \
        PRIMARY KEY (id), \
        FOREIGN KEY(image_id) REFERENCES image (id), \
        FOREIGN KEY(product_id) REFERENCES product (id) \
    );";
    
    [dbWrapperInstance tryExecQuery:query];
    [dbWrapperInstance closeDB];
}


- (void)initDBData:(POSDataSet*)dataSet {
    
    if ([dbWrapperInstance openDB] == NO)
        return;

    // COLLECTION (CATEGORY)
    NSMutableString* query = [NSMutableString stringWithString:@"SELECT count(*) FROM collection; "];
    int count = [dbWrapperInstance execQueryResultInt:query andIndex:0];

    if(count == 0) {
        
        [query setString:@""];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Nissan\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Toyota\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Suzuki\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Mitsubishi\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Ford\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Subaru\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Citroen\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Renault\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"Mercedes\", 1); "];
        [query appendString:@"INSERT INTO collection (name, user_id) VALUES (\"BMW\", 1); "];
        
        [dbWrapperInstance tryExecQuery:query];
    }
    
    // PRODUCT (ITEM)
    [query setString:@"SELECT count(*) FROM product; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"SELECT id FROM collection WHERE name= \"%@\" AND user_id = %d; ", @"Nissan", 1];
        int catID = [dbWrapperInstance execQueryResultInt:query andIndex:0];

        query = [NSMutableString stringWithFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"X-Trail\", 1, %d, 1000.0, 2000.0, \"Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover 555555 99999 11111 Crossover 555555 99999 11111 Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Pathfinder\", 1, %d, 1000, 2000, \"Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover Crossover 555555 99999 11111 Crossover 555555 99999 11111 Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111Crossover 555555 99999 11111\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Qashqai\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Navara\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Note\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Almera\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Teana\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Z350\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Micra\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        [query appendFormat:@"INSERT INTO product (name, user_id, collection_id, price_buy, price_sale, comment) VALUES (\"Tiida\", 1, %d, 1000, 2000, \"Crossover\"); ", catID];
        
        [dbWrapperInstance tryExecQuery:query];
    }

    // IMAGE
    [query setString:@"SELECT count(*) FROM image; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];

    if(count == 0) {
        
        query  = [NSMutableString stringWithString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car01.png\", \"car01.png\", 1, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car02.png\", \"car02.png\", 2, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car03.png\", \"car03.png\", 3, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car4.png\", \"car4.png\", 4, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car5.png\", \"car5.png\", 5, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car6.png\", \"car6.png\", 6, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car7.png\", \"car7.png\", 7, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car8.png\", \"car8.png\", 8, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car9.png\", \"car9.png\", 9, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 10, \"collection\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car02.png\", \"car02.png\", 1, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car03.png\", \"car03.png\", 2, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car4.png\", \"car4.png\", 3, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car5.png\", \"car5.png\", 4, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car6.png\", \"car6.png\", 5, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car7.png\", \"car7.png\", 6, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car8.png\", \"car8.png\", 7, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car9.png\", \"car9.png\", 8, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 9, \"product\", 1); "];
        [query appendString:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"car10.png\", \"car10.png\", 10, \"product\", 1); "];
        [query appendFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"%@\", \"%@\", 11, \"setting\", 1); ",
                                helperInstance.SETTING_EMAIL_ICON, helperInstance.SETTING_EMAIL_ICON];
        [query appendFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"%@\", \"%@\", 11, \"setting\", 1); ",
                                helperInstance.SETTING_LANGUAGE_ICON, helperInstance.SETTING_LANGUAGE_ICON];
        [query appendFormat:@"INSERT INTO image (name, path, object_id, object_name, is_default) VALUES (\"%@\", \"%@\", 11, \"setting\", 1); ",
                                helperInstance.SETTING_CURRENCY_ICON, helperInstance.SETTING_CURRENCY_ICON];
        
        [dbWrapperInstance tryExecQuery:query];
       
        int imageID = 0;
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car01.png"] withAsset:nil withPath:@"car01.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car02.png"] withAsset:nil withPath:@"car02.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car03.png"] withAsset:nil withPath:@"car03.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car4.png"] withAsset:nil withPath:@"car4.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car5.png"] withAsset:nil withPath:@"car5.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car6.png"] withAsset:nil withPath:@"car6.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car7.png"] withAsset:nil withPath:@"car7.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car8.png"] withAsset:nil withPath:@"car8.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car9.png"] withAsset:nil withPath:@"car9.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car10.png"] withAsset:nil withPath:@"car10.png" withObject_id:++imageID withObject_name:@"collection"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car11.png"] withAsset:nil withPath:@"car11.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car12.png"] withAsset:nil withPath:@"car12.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car13.png"] withAsset:nil withPath:@"car13.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car14.png"] withAsset:nil withPath:@"car14.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car15.png"] withAsset:nil withPath:@"car15.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car16.png"] withAsset:nil withPath:@"car16.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car17.png"] withAsset:nil withPath:@"car17.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car18.png"] withAsset:nil withPath:@"car18.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car19.png"] withAsset:nil withPath:@"car19.png" withObject_id:++imageID withObject_name:@"product"]];
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:@"car20.png"] withAsset:nil withPath:@"car20.png" withObject_id:++imageID withObject_name:@"product"]];
        
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_EMAIL_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_EMAIL_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];
        
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_LANGUAGE_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_LANGUAGE_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];
        
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_CURRENCY_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_CURRENCY_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];
        
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_WIFI_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_WIFI_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];
        
        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_VAT_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_VAT_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];

        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_REMEMBERME_CHECKED_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_REMEMBERME_CHECKED_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];

        [dataSet.images addObject:[[POSImage alloc] initWithImage: [UIImage imageNamed:helperInstance.SETTING_REMEMBERME_UNCHECKED_ICON]
                                                        withAsset: nil
                                                         withPath: helperInstance.SETTING_REMEMBERME_UNCHECKED_ICON
                                                    withObject_id: ++imageID
                                                  withObject_name: @"setting"]];
    }
    
    // GALLERY
    [query setString:@"SELECT count(*) FROM gallery; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"SELECT id FROM product WHERE name= \"%@\"; ", @"Pathfinder"];
        int product_1 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", @"car5.png"];
        int image_1 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", @"car6.png"];
        int image_2 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", @"car7.png"];
        int image_3 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", @"car8.png"];
        int image_4 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        
        query = [NSMutableString stringWithFormat:@"INSERT INTO gallery (image_id, product_id) VALUES (%d, %d); ", image_1, product_1];
        [query appendFormat:@"INSERT INTO gallery (image_id, product_id) VALUES (%d, %d); ", image_2, product_1];
        [query appendFormat:@"INSERT INTO gallery (image_id, product_id) VALUES (%d, %d); ", image_3, product_1];
        [query appendFormat:@"INSERT INTO gallery (image_id, product_id) VALUES (%d, %d); ", image_4, product_1];
        [dbWrapperInstance tryExecQuery:query];
    }
    
    // SETTING
    [query setString:@"SELECT count(*) FROM setting; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_EMAIL_ICON];
        int image_email_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_LANGUAGE_ICON];
        int image_language_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_CURRENCY_ICON];
        int image_money_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_WIFI_ICON];
        int image_wifi_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_VAT_ICON];
        int image_vat_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM image WHERE name= \"%@\"; ", helperInstance.SETTING_REMEMBERME_CHECKED_ICON];
        int image_rememberme_checked_id = [dbWrapperInstance execQueryResultInt:query andIndex:0];
      
        query = [NSMutableString stringWithFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_EMAIL, @"test@ukr.net", image_email_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_LANGUAGE, [helperInstance getDictionaryFirstValue:[helperInstance SETTING_LANGUAGES_DICT]], image_language_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_CURRENCY,[helperInstance getDictionaryFirstKey:[helperInstance SETTING_CURRENCY_DICT]], image_money_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_WIFI, [helperInstance convertBoolToString:YES], image_wifi_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_VAT, [helperInstance convertBoolToString:NO], image_vat_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_REMEMBERME, [helperInstance convertBoolToString:NO], image_rememberme_checked_id];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_REMEMBERME_LOGIN, @"NO", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_REMEMBERME_PASS, @"NO", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_BUTTON_BACKGROUND_COLOR, @"", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_BUTTON_FONT_COLOR, @"", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_CATEGORY_MODE, @"NO", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_ITEM_MODE, @"NO", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"BOOL\", 0, %d); ",
                                helperInstance.SETTING_BASKETS_MODE, @"NO", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_TEXTFIELD_BORDER_COLOR, @"", -1];
        [query appendFormat:@"INSERT INTO setting (name, value, type, is_deleted, image_id) VALUES (\"%@\", \"%@\", \"STRING\", 0, %d); ",
                                helperInstance.SETTING_TEXTFIELD_FONT_COLOR, @"", -1];

        [dbWrapperInstance tryExecQuery:query];
    }
    
    // ATTRIBUTE
    [query setString:@"SELECT count(*) FROM attribute; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"first attribute", 0];
        [query appendFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"second attribute", 0];
        [query appendFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"third attribute", 1];
        [query appendFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"size attribute", 1];
        [query appendFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"width attribute", 0];
        [query appendFormat:@"INSERT INTO attribute (name, is_active) VALUES (\"%@\", %d); ", @"height attribute", 1];
        
        [dbWrapperInstance tryExecQuery:query];
    }
    
    // ATTRIBUTE VALUE
    [query setString:@"SELECT count(*) FROM attribute_value; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"SELECT id FROM attribute WHERE name= \"%@\";", @"first attribute"];
        int attributeID = [dbWrapperInstance execQueryResultInt:query andIndex:0];

        query = [NSMutableString stringWithFormat:@"INSERT INTO attribute_value (name, attribute_id) VALUES (\"%@\", %d); ", @"attribute value 1", attributeID];
        [query appendFormat:@"INSERT INTO attribute_value (name, attribute_id) VALUES (\"%@\", %d); ", @"attribute value 2", attributeID];
        [query appendFormat:@"INSERT INTO attribute_value (name, attribute_id) VALUES (\"%@\", %d); ", @"attribute value 3", attributeID];
        [query appendFormat:@"INSERT INTO attribute_value (name, attribute_id) VALUES (\"%@\", %d); ", @"test attribbute value", attributeID];
        
        [dbWrapperInstance tryExecQuery:query];
    }
    
    // COLLECTION ATTRIBUTE (CATEGORY ATTRIBUTE)
    [query setString:@"SELECT count(*) FROM collection_attribute; "];
    count = [dbWrapperInstance execQueryResultInt:query andIndex:0];
    
    if(count == 0) {
        
        query = [NSMutableString stringWithFormat:@"SELECT id FROM attribute WHERE name= \"%@\"; ", @"first attribute"];
        int attributeID1 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM attribute WHERE name= \"%@\"; ", @"second attribute"];
        int attributeID2 = [dbWrapperInstance execQueryResultInt:query andIndex:0];
        query = [NSMutableString stringWithFormat:@"SELECT id FROM collection WHERE name= \"%@\"; ", @"Nissan"];
        int collectionID = [dbWrapperInstance execQueryResultInt:query andIndex:0];

        query = [NSMutableString stringWithFormat:@"INSERT INTO collection_attribute (collection_id, attribute_id, attributeIndex) \
                                                    VALUES (%d, %d, %d); ", collectionID, attributeID1, 0];
        [query appendFormat:@"INSERT INTO collection_attribute  (collection_id, attribute_id, attributeIndex) \
                              VALUES (%d, %d, %d); ", collectionID, attributeID2, 1];
        
        [dbWrapperInstance tryExecQuery:query];
    }
    
    [dbWrapperInstance closeDB];
}

@end
