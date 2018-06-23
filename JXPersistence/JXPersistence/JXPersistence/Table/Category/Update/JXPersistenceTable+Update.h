//
//  JXPersistenceTable+Update.h
//  JXPersistence
//
//  Created by zl on 2018/6/22.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable.h"
#import "JXPersistenceRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPersistenceTable (Update)

- (void)updateRecord:(NSObject <JXPersistenceRecordProtocol> *)record error:(NSError **)error;
- (void)updateRecordList:(NSArray <NSObject <JXPersistenceRecordProtocol> *> *)recordList error:(NSError **)error;

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;
- (void)updateValue:(id)value forKey:(NSString *)key primaryKey:(NSNumber *)primaryValue error:(NSError **)error;
- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;
- (void)updateValue:(id)value forKey:(NSString *)key whereKey:(NSString *)wherekey inList:(NSArray *)valueList error:(NSError **)error;

- (void)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error;
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
