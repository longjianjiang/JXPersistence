//
//  JXPersistenceTable+Delete.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable.h"
#import "JXPersistenceRecord.h"

@interface JXPersistenceTable (Delete)

- (void)deleteRecord:(NSObject <JXPersistenceRecordProtocol> *)record error:(NSError **)error;

- (void)deleteRecordList:(NSArray <JXPersistenceRecordProtocol> *)recordList error:(NSError **)error;

- (void)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;

- (void)deleteWithPrimaryKey:(NSNumber *)primaryKey error:(NSError **)error;

- (void)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyList error:(NSError **)error;

- (void)deleteRecordWhereKey:(NSString *)key value:(id)value error:(NSError **)error;

/**
 delete all items in table!
 */
- (void)truncate;
@end
