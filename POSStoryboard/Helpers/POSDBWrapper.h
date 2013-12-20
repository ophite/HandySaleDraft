//
//  DBWrapper.h
//  POSStoryboard
//
//  Created by kobernik.u on 12/10/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define dataFile @"data.sqlite3"
#define dbWrapperInstance [POSDBWrapper getInstance]

@interface POSDBWrapper : NSObject {
    
    NSString*               dataPath;
    sqlite3*                database;
    sqlite3_stmt*           statement;
    char*                   errorMsg;
}


@property NSString*         dataPath;
@property sqlite3*          database;
@property sqlite3_stmt*     statement;
@property char*             errorMsg;


- (NSString *)getDBFilePath;
+ (POSDBWrapper *)getInstance;

- (BOOL)openDB;
- (void)closeDB;

- (int)execQueryResultInt:(NSString *)query p_index:(int)index;
- (BOOL)tryExecQuery:(NSString *)query;
- (BOOL)tryExecQueryResultText:(NSString *)query p_index:(int)index p_result:(NSString**)text;

- (BOOL)tryGetNextRow;
- (void)prepareRows:(NSString *) query;
- (void)closeForeach;

- (int)getCellInt:(int)index;
- (NSString *)getCellText:(int)index;
- (const unsigned char *)getCellChar:(int)index;
- (float)getCellFloat:(int)index;
- (double)getCellDouble:(int)index;

- (void)fetchRows:query foreachCallback:(void (^)( id rows ) )callback p_rows:(id) rows;
- (void)fetchRows:query foreachCallback:(void (^)( id rows, id library ) )callback p_rows:(id) rows p_library:(id)library;

- (void)extractMultipleValues:query foreachCallback:(void (^)() )callback;

@end
