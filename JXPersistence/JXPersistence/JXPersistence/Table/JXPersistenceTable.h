//
//  JXPersistenceTable.h
//  JXPersistence
//
//  Created by zl on 2018/6/20.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JXPersistenceTableProtocol <NSObject>
@required

- (NSString *)databaseName;

- (NSString *)tableName;

- (NSDictionary *)columnInfo;

- (Class)recordClass;

- (NSString *)primaryKeyName;

@optional
- (NSDictionary *)columnDefaultValue;

- (BOOL)isCorrectToInsertRecord:(NSObject *)record;

- (BOOL)isCorrectToUpdateRecord:(NSString *)record;
@end


@interface JXPersistenceTable : NSObject

@end

NS_ASSUME_NONNULL_END
