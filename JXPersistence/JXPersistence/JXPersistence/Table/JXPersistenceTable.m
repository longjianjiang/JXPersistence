//
//  JXPersistenceTable.m
//  JXPersistence
//
//  Created by zl on 2018/6/20.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable.h"
#import "JXPersistenceQueryCommand+SchemaOperations.h"

@interface JXPersistenceTable()

@property (nonatomic, weak, readwrite) JXPersistenceTable <JXPersistenceTableProtocol> *child;
@property (nonatomic, strong, readwrite) JXPersistenceQueryCommand *queryCommand;

@end


@implementation JXPersistenceTable

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(JXPersistenceTableProtocol)]) {
        
        self.child = (JXPersistenceTable <JXPersistenceTableProtocol> *)self;
        [self configTable:self.queryCommand];
        
    } else {
        NSException *exception = [NSException exceptionWithName:@"JXPersistenceTable init error" reason:@"the child class must conforms to protocol: <JXPersistenceTableProtocol>" userInfo:nil];
        @throw exception;
    }

    return self;
}

- (void)configTable:(JXPersistenceQueryCommand *)queryCommand {
    NSError *error = nil;
    
    // create table if not exists
    [[queryCommand createTable:self.child.tableName columnInfo:self.child.columnInfo] executeWithError:&error];
    
    if (error) {
        NSLog(@"Error at [%s]:[%d]:%@", __FILE__, __LINE__, error);
    }
}

#pragma mark - public method
- (BOOL)executeSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error {
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] executeWithError:error];
}

- (NSArray<NSDictionary *> *)fetchWithSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error {
    return [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] fetchWithError:error];
}

#pragma mark - getter and setter
- (JXPersistenceQueryCommand *)queryCommand {
    if (_queryCommand == nil) {
        _queryCommand = [[JXPersistenceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
    }
    return _queryCommand;
}
@end
