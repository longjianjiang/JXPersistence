//
//  JXPersistenceRecord.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceRecord.h"
#import "JXPersistenceTable.h"
#import <objc/runtime.h>


@implementation JXPersistenceRecord

- (NSDictionary *)dictionaryRepresentationWithTable:(JXPersistenceTable<JXPersistenceTableProtocol> *)table {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *propertyList = [[NSMutableDictionary alloc] init];
    while (count --> 0) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[count])];
        id value = [self valueForKey:key];
        if (value == nil) {
            propertyList[key] = [NSNull null];
        } else {
            propertyList[key] = value;
        }
    }
    free(properties);
    
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    [table.columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        
        if (!propertyList[columnName]) {
            return;
        }
        
        dictionaryRepresentation[columnName] = propertyList[columnName];
        
        if (propertyList[columnName] != [NSNull null]) {
            return;
        }
        
        if(table.columnDefaultValue) {
            id defaultValue = [table.columnDefaultValue valueForKey:columnName];
            if (defaultValue) {
                dictionaryRepresentation[columnName] = defaultValue;
            }
        }
    }];
    
    return dictionaryRepresentation;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setValue:value forKey:key];
    }];
}

- (NSObject<JXPersistenceRecordProtocol> *)mergeRecord:(NSObject<JXPersistenceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride {
    if ([self respondsToSelector:@selector(availableKeyList)]) {
        NSArray *availableKeyList = [self availableKeyList];
        [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record respondsToSelector:NSSelectorFromString(key)]) {
                id recordValue = [record valueForKey:key];
                if (shouldOverride) {
                    [self setValue:recordValue forKey:key];
                } else {
                    id selfValue = [self valueForKey:key];
                    if (selfValue == nil) {
                        [self setValue:recordValue forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

@end
