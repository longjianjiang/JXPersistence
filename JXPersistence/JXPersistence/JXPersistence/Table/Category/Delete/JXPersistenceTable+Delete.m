//
//  JXPersistenceTable+Delete.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable+Delete.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"

@implementation JXPersistenceTable (Delete)

- (void)deleteRecord:(NSObject<JXPersistenceRecordProtocol> *)record error:(NSError *__autoreleasing *)error {
    [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)deleteWithPrimaryKey:(NSNumber *)primaryKey error:(NSError *__autoreleasing *)error {
    if (primaryKey != nil) {
        NSMutableArray *bindValueList = [NSMutableArray array];
        
    }
}
@end
