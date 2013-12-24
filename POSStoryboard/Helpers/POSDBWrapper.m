//
//  DBWrapper.m
//  POSStoryboard
//
//  Created by kobernik.u on 12/10/13.
//  Copyright (c) 2013 kobernik.u. All rights reserved.
//

/*
 open
 --------
 prepare
 step (statement, while)
 sqlite3_column_*
 finalize(statement)
 --------
 close
 */

#import "POSDBWrapper.h"

@implementation POSDBWrapper


@synthesize dataPath;
@synthesize database;
@synthesize statement;
@synthesize errorMsg;


- (NSString *)getDBFilePath {
  
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:dataFile];
}


+ (POSDBWrapper *)getInstance {
    
    static POSDBWrapper *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[POSDBWrapper alloc] init];
        sharedInstance.dataPath = [sharedInstance getDBFilePath];
    });
    
    return sharedInstance;
}


- (BOOL)openDB {
    
    if(sqlite3_open([dataPath UTF8String], &database) != SQLITE_OK) {
        
        NSAssert(0, @"Error cannot open database %s", "");
        return NO;
    }

    return YES;
}


- (void)closeDB {
    
    sqlite3_close(database);
}


- (int)execQueryResultInt:(NSString *)query
                  p_index:(int)index {

    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    sqlite3_step(statement);    
    int result = sqlite3_column_int(statement, index);
    sqlite3_finalize(statement);
    
    return result;
}

- (BOOL)tryExecQueryResultText:(NSString *)query
                       p_index:(int)index
                      p_result:(NSString **)text {
    
    BOOL result = YES;
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    
    if (sqlite3_step(statement) == SQLITE_ROW)
        *text = [self getCellText:0];
    else
        result = NO;
    
    sqlite3_finalize(statement);
    
    return result;
}


- (NSString *)getCellText:(int)index {
    
    const char *result = ((char *)sqlite3_column_text(statement, index));
    return result == NULL ? nil : [[NSString alloc] initWithUTF8String: result];
}


- (int)getCellInt:(int)index {
    
    return sqlite3_column_int(statement, index);
}


- (double)getCellDouble:(int)index {
    
    return sqlite3_column_double(statement, index);
}


- (float)getCellFloat:(int)index {
    
    return (float)sqlite3_column_double(statement, index);
}


- (const unsigned char *)getCellChar:(int)index {
    
    return sqlite3_column_text(statement, index);
}


- (BOOL)tryExecQuery:(NSString *)query {
    
    BOOL result = YES;
    
    if(sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        
        NSAssert(0, @"Error exec query %@: %s", query, errorMsg);
        result = NO;
    }
    
    return result;
}


- (void)prepareRows:(NSString *) query {
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
}


- (void)closeForeach {
    
    sqlite3_finalize(statement);
}


- (BOOL)tryGetNextRow {
    
    BOOL result = YES;

    if (sqlite3_step(statement) != SQLITE_ROW)
        result = NO;
    
    return result;
}


- (void)fetchRows:query
  foreachCallback:(void (^)( id rows ))callback
           p_rows:(id)rows {

    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    
    while (sqlite3_step(statement) == SQLITE_ROW)
        callback(rows);
    
    sqlite3_finalize(statement);
}


- (void)fetchRows:query
  foreachCallback:(void (^)(id rows, id library ))callback
           p_rows:(id)rows
        p_library:(id)library; {
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    
    while (sqlite3_step(statement) == SQLITE_ROW)
        callback(rows, library);
    
    sqlite3_finalize(statement);
}


- (void)extractMultipleValues:query
              foreachCallback:(void (^)())callback {
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    sqlite3_step(statement);
    callback();
    sqlite3_finalize(statement);
}


@end
