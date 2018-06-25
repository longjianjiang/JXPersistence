//
//  JXPersistenceTable+Update.m
//  JXPersistence
//
//  Created by zl on 2018/6/22.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable+Update.h"
#import "JXPersistenceQueryCommand+DataOperations.h"

#import "NSDictionary+JXPersistenceBindValue.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"
#import "NSString+Where.h"


@implementation JXPersistenceTable (Update)

- (void)updateRecord:(NSObject<JXPersistenceRecordProtocol> *)record error:(NSError * _Nullable __autoreleasing *)error {
    [self updateKeyValueList:[record dictionaryRepresentationWithTable:self.child] primaryKeyValue:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)updateRecordList:(NSArray<NSObject<JXPersistenceRecordProtocol> *> *)recordList error:(NSError * _Nullable __autoreleasing *)error {
    
    for (id<JXPersistenceRecordProtocol> record in recordList) {
        [self updateRecord:record error:error];
        
        if (error != NULL && *error != nil) {
            return;
        }
    }
    
}

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error {
    if (key) {
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error {
    NSMutableArray *bindValueList = [NSMutableArray array];

    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];
    NSString *whereString = [whereCondition whereStringWithConditionParams:whereConditionParams bindValueList:bindValueList];

    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}


- (void)updateValue:(id)value forKey:(NSString *)key primaryKey:(NSNumber *)primaryValue error:(NSError **)error {
    if (!value) {
        value = [NSNull null];
    }
    
    if (self.child.columnDefaultValue && [value isKindOfClass:[NSNull class]]) {
        id defaultValue = [self.child.columnDefaultValue valueForKey:key];
        
        if (defaultValue) {
            value = defaultValue;
        }
    }
    
    if (key && primaryValue) {
        
        NSMutableArray *bindValueList = [NSMutableArray array];
        NSString *valueKey = [NSString stringWithFormat:@":%@",key];
        NSString *valueString = [NSString stringWithFormat:@"%@ = %@", key, valueKey];
        
        [bindValueList addBindKey:valueKey bindValue:value];
        
        NSString *whereKey = [NSString stringWithFormat:@":JXPersistenceWhere_%@",self.child.primaryKeyName];
        NSString *whereString = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
        
        [bindValueList addBindKey:whereKey bindValue:primaryValue];
        
        [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}


- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray<NSNumber *> *)primaryKeyValueList error:(NSError * _Nullable __autoreleasing *)error {
    if (key) {
        [self updateValue:value forKey:key whereKey:self.child.primaryKeyName inList:primaryKeyValueList error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)valueList error:(NSError * _Nullable __autoreleasing *)error {
    
    if (!value) {
        value = [NSNull null];
    }
    
    if (self.child.columnDefaultValue && [value isKindOfClass:[NSNull class]]) {
        id defaultValue = [self.child.columnDefaultValue valueForKey:key];
        
        if (defaultValue) {
            value = defaultValue;
        }
    }
    
    if (key && wherekey && valueList.count > 0) {
        NSMutableArray *bindValueList = [NSMutableArray array];
        NSString *valueKey = [NSString stringWithFormat:@":%@",key];
        
        NSString *valueString = [NSString stringWithFormat:@"%@ = %@",key, valueKey];
        [bindValueList addBindKey:valueKey bindValue:value];
        
        NSMutableArray *valueKeyList = [NSMutableArray array];
        [valueList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueKey = [NSString stringWithFormat:@":JXPersistenceWhere_%lu",(unsigned long)idx];
            [valueKeyList addObject:valueKey];
            [bindValueList addBindKey:valueKey bindValue:obj];
        }];
        
        NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)",wherekey, [valueKeyList componentsJoinedByString:@","]];
        [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
    }
}


- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError * _Nullable __autoreleasing *)error {
    
    if (primaryKeyValue == nil) {
        return;
    }
    
    NSMutableArray *bindValueList = [NSMutableArray array];
    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];
    
    NSString *whereKey = [NSString stringWithFormat:@":JXPersistenceWhere_%@", self.child.primaryKeyName];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = %@", self.child.primaryKeyName, whereKey];
    [bindValueList addBindKey:whereKey bindValue:primaryKeyValue];
    
    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereCondition bindValueList:bindValueList error:error] executeWithError:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray<NSNumber *> *)primaryKeyValueList error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableArray *bindValueList = [NSMutableArray array];
    keyValueList = [self defaultValueProcessBeforeUpdate:keyValueList];
    NSString *valueString = [keyValueList bindToUpdateValueList:bindValueList];
    
    NSMutableArray *valueKeyList = [NSMutableArray array];
    [primaryKeyValueList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":JXPersistenceWhere_%lu",(unsigned long)idx];
        [valueKeyList addObject:valueKey];
        [bindValueList addBindKey:valueKey bindValue:obj];
    }];
    
    NSString *whereString = [NSString stringWithFormat:@"%@ IN (%@)", self.child.primaryKeyName, [valueKeyList componentsJoinedByString:@","]];
    [[self.queryCommand updateTable:self.child.tableName valueString:valueString whereString:whereString bindValueList:bindValueList error:error] executeWithError:error];
}


#pragma mark - private method
- (NSDictionary *)defaultValueProcessBeforeUpdate:(NSDictionary *)keyValueList {
    if(!self.child.columnDefaultValue) {
        return keyValueList;
    }
    
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    
    [keyValueList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        
        if(!keyValueList[columnName]) {
            dictionaryRepresentation[columnName] = [NSNull null];
        } else {
            dictionaryRepresentation[columnName] = keyValueList[columnName];
        }
        
        
        if (dictionaryRepresentation[columnName] != [NSNull null]) {
            return;
        }
        
        //setting default value
        if(self.child.columnDefaultValue) {
            id defaultValue = [self.child.columnDefaultValue valueForKey:columnName];
            
            if(defaultValue) {
                dictionaryRepresentation[columnName] = defaultValue;
            }
        }
    }];
    
    return dictionaryRepresentation;
}
@end
