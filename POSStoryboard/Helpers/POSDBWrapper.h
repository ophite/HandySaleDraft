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

- (int)execQueryResultInt:(NSString *)query andIndex:(int)index;
- (BOOL)tryExecQuery:(NSString *)query;
- (BOOL)tryExecQueryResultText:(NSString *)query andIndex:(int)index andResult:(NSString**)text;

- (BOOL)tryGetNextRow;
- (void)prepareRows:(NSString *)query;
- (void)closeForeach;

- (int)getCellInt:(int)index;
- (NSString *)getCellText:(int)index;
- (const unsigned char *)getCellChar:(int)index;
- (float)getCellFloat:(int)index;
- (double)getCellDouble:(int)index;

- (void)fetchRows:query andForeachCallback:(void (^)(id rows ))callback andRows:(id)rows;
- (void)fetchRows:query andForeachCallback:(void (^)(id rows, id library))callback andRows:(id)rows andLibrary:(id)library;

- (void)extractMultipleValues:query andForeachCallback:(void (^)())callback;

@end
