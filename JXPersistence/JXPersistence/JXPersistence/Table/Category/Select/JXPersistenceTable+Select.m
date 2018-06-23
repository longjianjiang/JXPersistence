//
//  JXPersistenceTable+Select.m
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable+Select.h"

#import "NSDictionary+JXPersistenceBindValue.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"
#import "NSString+Where.h"
#import "NSArray+JXPersistenceRecordTransform.h"

#import "JXPersistenceDefines.h"

@implementation JXPersistenceTable (Select)

- (NSArray<NSObject<JXPersistenceRecordProtocol> *> *)findAllWithError:(NSError * _Nullable __autoreleasing *)error {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@`", self.child.tableName];
    return [[[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}



- (NSArray<NSObject<JXPersistenceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableArray *bindValueList = [NSMutableArray array];
    
    NSString *whereString = [whereCondition whereStringWithConditionParams:conditionParams bindValueList:bindValueList];
    NSString *sqlString = nil;
    if (isDistinct) {
        sqlString = [NSString stringWithFormat:@"SELECT DISTINCT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    } else {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@", self.child.tableName, whereString];
    }
    
    return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}

- (NSArray<NSObject<JXPersistenceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableArray *bindValueList = [NSMutableArray array];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [bindValueList addBindKey:key bindValue:obj];
    }];
    
    return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
}


- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyList error:(NSError **)error {
    return [self findAllWithKeyName:self.child.primaryKeyName inValueList:primaryKeyList error:error];
}

- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyName value:(id)value error:(NSError **)error {
    
    if (keyName && value) {
        return [self findAllWithWhereCondition:[NSString stringWithFormat:@"%@ = :%@",keyName, keyName]
                               conditionParams:@{[NSString stringWithFormat:@":%@",keyName] : value}
                                    isDistinct:NO error:error];
    }
    
    return nil;
}

- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyName inValueList:(NSArray *)valueList error:(NSError **)error {
    
    if (keyName.length && valueList.count) {
        NSMutableArray *bindValueList = [NSMutableArray array];
        NSMutableArray *valueKeyList = [NSMutableArray array];
        
        [valueList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *whereKey = [NSString stringWithFormat:@":JXPersistenceWhere_%lu",(unsigned long)idx];
            [bindValueList addBindKey:whereKey bindValue:obj];
            [valueKeyList addObject:whereKey];
        }];
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ IN (%@)", self.child.tableName, keyName, [valueKeyList componentsJoinedByString:@","]];
        
        return [[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass];
    }
    
    return nil;
}


- (NSObject<JXPersistenceRecordProtocol> *)findLatestRecordWithError:(NSError * _Nullable __autoreleasing *)error {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` ORDER BY %@ DESC LIMIT 1", self.child.tableName, self.child.primaryKeyName];
    return [[[[self.queryCommand compileSqlString:sqlString bindValueList:nil error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSObject <JXPersistenceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKey error:(NSError **)error {
    if (primaryKey == nil) {
        if (error) {
            *error = [NSError errorWithDomain:kJXPersistanceErrorDomain
                                         code:JXPersistanceErrorCodeQueryStringError
                                     userInfo:@{NSLocalizedDescriptionKey:@"primaryKey is nil"}];
        }
        return nil;
    }
    
    NSString *valueKey = @":JXPersistenceWhere_primaryKey";
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [bindValueList addBindKey:valueKey bindValue:primaryKey];
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` WHERE %@ = %@ LIMIT 1;", self.child.tableName, self.child.primaryKeyName, valueKey];
    
    return [[[[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error] transformSQLItemsToClass:self.child.recordClass] firstObject];
}

- (NSObject <JXPersistenceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error {
    return [[self findAllWithWhereCondition:whereCondition conditionParams:conditionParams isDistinct:isDistinct error:error] firstObject];
}

- (NSObject <JXPersistenceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error {
    return [[self findAllWithSQL:sqlString params:params error:error] firstObject];
}


- (NSInteger)countTotalRecord {
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM `%@`", self.child.tableName];
    return [self countWithSQL:sqlString params:nil error:NULL];
}


- (NSInteger)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSMutableString *whereString = [whereCondition mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSMutableString *valueKey = [key mutableCopy];
        [valueKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [valueKey insertString:@":JXPersistenceWhere_" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:valueKey options:0 range:NSMakeRange(0, whereString.length)];
        params[valueKey] = value;
    }];
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ WHERE %@;", self.child.tableName, whereString];
    return [self countWithSQL:sqlString params:params error:error];
}


- (NSInteger)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error {
    NSMutableArray *bindValueList = [[NSMutableArray alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop) {
        [bindValueList addBindKey:key bindValue:value];
    }];
    
    NSArray *result = [[self.queryCommand compileSqlString:sqlString bindValueList:bindValueList error:error] fetchWithError:error];
    return [[result firstObject][@"count"] integerValue];
}

@end
