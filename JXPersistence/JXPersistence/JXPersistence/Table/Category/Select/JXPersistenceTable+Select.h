//
//  JXPersistenceTable+Select.h
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable.h"
#import "JXPersistenceRecord.h"




@interface JXPersistenceTable (Select)


- (NSObject <JXPersistenceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKey error:(NSError **)error;
- (NSObject <JXPersistenceRecordProtocol> *)findLatestRecordWithError:(NSError **)error;
- (NSObject <JXPersistenceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;
- (NSObject <JXPersistenceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

- (NSInteger)countTotalRecord;
- (NSInteger)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;
- (NSInteger)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithError:(NSError **)error;
- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;
- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;
- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyList error:(NSError **)error;
- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyName value:(id)value error:(NSError **)error;
- (NSArray<NSObject <JXPersistenceRecordProtocol> *> *)findAllWithKeyName:(NSString *)keyName inValueList:(NSArray *)valueList error:(NSError **)error;

@end


