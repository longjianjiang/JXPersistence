//
//  JXPersistenceTable+Delete.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable+Delete.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"
#import "JXPersistenceQueryCommand+DataOperations.h"
#import "NSString+Where.h"


@implementation JXPersistenceTable (Delete)

- (void)deleteRecord:(NSObject<JXPersistenceRecordProtocol> *)record error:(NSError *__autoreleasing *)error {
    
    [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]] error:error];
    
}

-(void)deleteRecordList:(NSArray<JXPersistenceRecordProtocol> *)recordList error:(NSError *__autoreleasing *)error {
    
    NSMutableArray *primaryKeyList = [NSMutableArray new];
    [recordList enumerateObjectsUsingBlock:^(NSObject<JXPersistenceRecordProtocol> *  _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *primaryKey = [record valueForKey:[self.child primaryKeyName]];
        if (primaryKey != nil) {
            [primaryKeyList addObject:primaryKey];
        }
    }];
    
    [self deleteWithPrimaryKeyList:primaryKeyList error:error];

}

- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError *__autoreleasing *)error {
     
    NSMutableArray *bindValueList = [NSMutableArray array];
    NSString *whereString = [whereCondition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];
    [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}


- (void)deleteWithPrimaryKey:(NSNumber *)primaryKey error:(NSError *__autoreleasing *)error {
    
    if (primaryKey != nil) {
        NSMutableArray *bindValueList = [NSMutableArray array];
        NSString *whereKey = [NSString stringWithFormat:@":JXPersistenceWhere_%@", self.child.primaryKeyName];
        [bindValueList addBindKey:whereKey bindValue:primaryKey];
        
        NSString *whereString = [NSString stringWithFormat:@"%@ = %@",self.child.primaryKeyName, whereKey];
        [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)deleteWithPrimaryKeyList:(NSArray<NSNumber *> *)primaryKeyList error:(NSError *__autoreleasing *)error {
    
    if ([primaryKeyList count] > 0) {
        NSMutableArray *valueList = [NSMutableArray array];
        NSMutableArray *bindValueList = [NSMutableArray array];
        
        [primaryKeyList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *whereKey = [NSString stringWithFormat:@":JXPersistenceWhere_%lu", (unsigned long)idx];
            [valueList addObject:whereKey];
            [bindValueList addBindKey:whereKey bindValue:obj];
        }];
        
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueList componentsJoinedByString:@","]];
        [[self.queryCommand deleteTable:self.child.tableName whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}

- (void)deleteRecordWhereKey:(NSString *)key value:(id)value error:(NSError *__autoreleasing *)error {
    
    if (key == nil || value == nil) {
        return;
    }
    
    NSString *conditionKey = [@":" stringByAppendingString:key];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = %@", key, conditionKey];
    NSDictionary *conditionParams = @{conditionKey: value};
    [self deleteWithWhereCondition:whereCondition conditionParams:conditionParams error:error];
}

- (void)truncate {
    
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@`;", self.child.tableName];
    [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] executeWithError:NULL];
    
    sqlString = @"VACUUM;";
    [[self.queryCommand compileSqlString:sqlString bindValueList:nil error:NULL] executeWithError:NULL];
    
}
@end
