//
//  JXPersistenceSQLStatement.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceSQLStatement.h"
#import <sqlite3.h>
#import "JXPersistenceDefines.h"

@interface JXPersistenceSQLStatement()

@property (nonatomic, weak) JXPersistenceDatabase *database;
@property (nonatomic, unsafe_unretained) sqlite3_stmt *statement;

@end


@implementation JXPersistenceSQLStatement

#pragma mark - life cycle
- (instancetype)initWithSqlString:(NSString *)sqlString bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList database:(JXPersistenceDatabase *)database error:(NSError *__autoreleasing *)error {
    self = [super init];
    if (self) {
        self.database = database;
        
        sqlite3_stmt *statement = nil;
        int result = sqlite3_prepare_v2(database.database, [sqlString UTF8String], (int)sqlString.length, &statement, NULL);
        if (result != SQLITE_OK) {
            self.statement = nil;
            
            NSString *errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(database.database)];
            NSError *generatedError = [NSError errorWithDomain:kJXPersistanceErrorDomain code:JXPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", sqlString, errorMessage]}];
            if (error != NULL) {
                *error = generatedError;
            }
            NSLog(@"\n\n\n======================\n\n%@\n\n%s\n%s(%d):\n\n\terror is:\n\t\t %@ \n\n\t sqlString is %@\n\n======================\n\n\n", [NSThread currentThread], __FILE__, __FUNCTION__, __LINE__, errorMessage, sqlString);
            sqlite3_finalize(statement);
            return nil;
        }
        self.statement = statement;
        
        [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
            [bindInvocation setArgument:(void *)&statement atIndex:2];
            [bindInvocation invoke];
        }];
        [bindValueList removeAllObjects];
    }
    return self;
}

- (void)close {
    sqlite3_finalize(self.statement);
    self.statement = nil;
}

#pragma mark - public method
- (BOOL)executeWithError:(NSError *__autoreleasing *)error {
    if (error != NULL && *error != nil) {
        [self close];
        return NO;
    }
    
    sqlite3_stmt *statement = self.statement;
    
    int result = sqlite3_step(statement);
    
    if (result != SQLITE_DONE && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kJXPersistanceErrorDomain code:JXPersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", [NSString stringWithUTF8String:sqlite3_sql(statement)], [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    [self close];
    
    return YES;
}

- (NSArray<NSDictionary *> *)fetchWithError:(NSError *__autoreleasing *)error {
    if (error != NULL && *error != nil) {
        [self close];
        return nil;
    }
    
    sqlite3_stmt *statement = self.statement;
    NSMutableArray *resultsArray = [NSMutableArray array];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        int columns = sqlite3_column_count(statement);
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:columns];
        
        for (int i = 0; i < columns; ++i) {
            const char *name = sqlite3_column_name(statement, i);
            int type = sqlite3_column_type(statement, i);
            NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            
            switch (type) {
                case SQLITE_INTEGER: {
                    int64_t value = sqlite3_column_int64(statement, i);
                    [result setObject:@(value) forKey:columnName];
                    break;
                }
                case SQLITE_TEXT: {
                    const char *value = (const char*)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
                case SQLITE_FLOAT: {
                    double value = sqlite3_column_double(statement, i);
                    [result setObject:@(value) forKey:columnName];
                    break;
                }
                case SQLITE_BLOB: {
                    int bytes = sqlite3_column_bytes(statement, i);
                    if (bytes > 0) {
                        const void *blob = sqlite3_column_blob(statement, i);
                        if (blob != NULL) {
                            [result setObject:[NSData dataWithBytes:blob length:bytes] forKey:columnName];
                        }
                    }
                    break;
                }
                case SQLITE_NULL: {
                    [result setObject:[NSNull null] forKey:columnName];
                    break;
                }
                default: {
                    const char *value = (const char *)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
            }
        }
        [resultsArray addObject:result];
    }
    
    [self close];
    
    return resultsArray;
}
@end
