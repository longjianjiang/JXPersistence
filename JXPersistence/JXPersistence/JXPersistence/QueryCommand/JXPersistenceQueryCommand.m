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

@end


@implementation JXPersistenceQueryCommand

#pragma mark - public method
- (instancetype)initWithDatabase:(JXPersistenceDatabase *)database {
    self = [super init];
    if (self) {
        self.shouldKeepDatabase = YES;
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        self.shouldKeepDatabase = NO;
        self.databaseName = databaseName;
    }
    return self;
}

- (JXPersistenceSQLStatement *)compileSqlString:(NSString *)sqlString bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error {

    return [[JXPersistenceSQLStatement alloc] initWithSqlString:sqlString bindValueList:bindValueList database:self.database error:error];
    
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
