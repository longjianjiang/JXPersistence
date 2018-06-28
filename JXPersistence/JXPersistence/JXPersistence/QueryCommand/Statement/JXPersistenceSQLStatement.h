//
//  JXPersistenceSQLStatement.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPersistenceDatabase.h"


@interface JXPersistenceSQLStatement : NSObject

- (instancetype)initWithSqlString:(NSString *)sqlString bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList database:(JXPersistenceDatabase *)database error:(NSError **)error;

/**
 execute sql statement except `select`
 */
- (BOOL)executeWithError:(NSError **)error;

/**
 get result from select statement
 */
- (NSArray <NSDictionary *> *)fetchWithError:(NSError **)error;

@property (nonatomic, assign, readonly) BOOL inUse;
@property (nonatomic, unsafe_unretained, readonly) sqlite3_stmt *statement;
@property (nonatomic, assign, readonly) long useCount;
- (void)close;

@end
