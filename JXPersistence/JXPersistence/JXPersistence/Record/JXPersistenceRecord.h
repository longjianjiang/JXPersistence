//
//  JXPersistenceRecord.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXPersistenceTable;
@protocol JXPersistenceTableProtocol;

@protocol JXPersistenceRecordProtocol <NSObject>

@required

- (NSDictionary *)dictionaryRepresentationWithTable:(JXPersistenceTable <JXPersistenceTableProtocol> *)table;

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary;

- (NSObject <JXPersistenceRecordProtocol> *)mergeRecord:(NSObject <JXPersistenceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride;

@optional

- (NSArray *)availableKeyList;

@end


@interface JXPersistenceRecord : NSObject <JXPersistenceRecordProtocol>

@end
