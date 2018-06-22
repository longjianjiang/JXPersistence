//
//  JXPersistenceTable+Insert.h
//  JXPersistence
//
//  Created by zl on 2018/6/22.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable.h"
#import "JXPersistenceRecord.h"
NS_ASSUME_NONNULL_BEGIN

@interface JXPersistenceTable (Insert)

- (BOOL)insertRecordList:(NSArray <NSObject <JXPersistenceRecordProtocol> *> *)recordList error:(NSError **)error;

- (BOOL)insertRecord:(NSObject <JXPersistenceRecordProtocol> *)record error:(NSError **)error;

- (NSNumber *)insertValue:(id)value forKey:(NSString *)key error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
