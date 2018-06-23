//
//  NSArray+JXPersistenceRecordTransform.m
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "NSArray+JXPersistenceRecordTransform.h"
#import "JXPersistenceRecord.h"


@implementation NSArray (JXPersistenceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType {
    
    NSMutableArray *recordList = [NSMutableArray array];
    
    if ([self count] > 0) {
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id<JXPersistenceRecordProtocol> record = [classType new];
            if ([record respondsToSelector:@selector(objectRepresentationWithDictionary:)]) {
                [record objectRepresentationWithDictionary:obj];
                [recordList addObject:record];
            }
        }];
    }
    
    return recordList;
}


@end
