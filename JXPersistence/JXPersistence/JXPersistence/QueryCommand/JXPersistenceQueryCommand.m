//
//  JXPersistenceQueryCommand.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand.h"
#import "JXPersistenceDatabasePool.h"

@interface JXPersistenceQueryCommand()

@property (nonatomic, weak, readwrite) JXPersistenceDatabase *database;
@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, assign) BOOL shouldKeepDatabase;

@property (nonatomic, strong) NSMutableDictionary *cachedStatements;
@end


@implementation JXPersistenceQueryCommand

#pragma mark - public method
- (instancetype)initWithDatabase:(JXPersistenceDatabase *)database {
    self = [super init];
    if (self) {
        self.cachedStatements = [NSMutableDictionary dictionary];
        self.shouldKeepDatabase = YES;
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        self.cachedStatements = [NSMutableDictionary dictionary];
        self.shouldKeepDatabase = NO;
        self.databaseName = databaseName;
    }
    return self;
}

- (void)dealloc {
    [self clearCachedStatements];
}

- (JXPersistenceSQLStatement *)compileSqlString:(NSString *)sqlString bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error {
    
    JXPersistenceSQLStatement *statement = nil;
    statement = [self cachedStatementForSqlString:sqlString];
    
    if (statement == nil) {
        
        statement = [[JXPersistenceSQLStatement alloc] initWithSqlString:sqlString bindValueList:bindValueList database:self.database error:error];
        [self setCachedStatements:statement forSqlString:sqlString];
        
    } else {
        
        sqlite3_stmt *stmt = statement.statement;
        [bindValueList enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull bindInvocation, NSUInteger idx, BOOL * _Nonnull stop) {
            [bindInvocation setArgument:(void *)&stmt atIndex:2];
            [bindInvocation invoke];
        }];
        [bindValueList removeAllObjects];

    }
    return statement;
}


#pragma mark - statement cache
- (JXPersistenceSQLStatement *)cachedStatementForSqlString:(NSString *)sqlString {
    NSMutableSet *statements = [self.cachedStatements objectForKey:sqlString];
    
    return [[statements objectsPassingTest:^BOOL(JXPersistenceSQLStatement *  _Nonnull statement, BOOL * _Nonnull stop) {
        *stop = !statement.inUse;
        return *stop;
    }] anyObject];
}

- (void)setCachedStatements:(JXPersistenceSQLStatement *)statement forSqlString:(NSString *)sqlString {
    sqlString = [sqlString copy];
    
    NSMutableSet *statements = [self.cachedStatements objectForKey:sqlString];
    if (!statements) {
        statements = [NSMutableSet set];
    }
    
    [statements addObject:statement];
    
    [self.cachedStatements setObject:statements forKey:sqlString];
}

- (void)clearCachedStatements {
    for (NSMutableSet *statements in [self.cachedStatements objectEnumerator]) {
        for (JXPersistenceSQLStatement *statement in statements) {
            [statement close];
        }
    }
    
    [self.cachedStatements removeAllObjects];
}

#pragma mark - getter and setter
- (JXPersistenceDatabase *)database {
    if (self.shouldKeepDatabase) {
        return _database;
    }
    
    _database = [[JXPersistenceDatabasePool sharedInstance] databaseWithName:self.databaseName];
    return _database;
}


@end
