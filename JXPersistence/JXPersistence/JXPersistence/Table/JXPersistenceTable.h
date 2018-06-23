//
//  JXPersistenceTable.h
//  JXPersistence
//
//  Created by zl on 2018/6/20.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPersistenceQueryCommand.h"
#import "JXPersistenceRecord.h"

@protocol JXPersistenceTableProtocol <NSObject>

@required
- (NSString *)databaseName;

- (NSString *)tableName;

- (NSDictionary *)columnInfo;

- (Class)recordClass;

- (NSString *)primaryKeyName;

@optional
- (NSDictionary *)columnDefaultValue;
- (BOOL)isCorrectToInsertRecord:(NSObject <JXPersistenceRecordProtocol> *)record;
- (BOOL)isCorrectToUpdateRecord:(NSObject <JXPersistenceRecordProtocol> *)record;

@end


@interface JXPersistenceTable : NSObject

@property (nonatomic, weak, readonly) JXPersistenceTable <JXPersistenceTableProtocol> *child;
@property (nonatomic, strong, readonly) JXPersistenceQueryCommand *queryCommand;

- (BOOL)executeSQL:(NSString *)sqlString error:(NSError **)error;

- (NSArray <NSDictionary *> *)fetchWithSQL:(NSString *)sqlString error:(NSError **)error;

@end

