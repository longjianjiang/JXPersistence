//
//  NSDictionary+JXPersistenceBindValue.m
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "NSDictionary+JXPersistenceBindValue.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"

@implementation NSDictionary (JXPersistenceBindValue)

- (NSString *)bindToValueList:(NSMutableArray<NSInvocation *> *)bindValueList {
    
    NSMutableArray *valueList = [NSMutableArray array];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":%@",key];
        if ([obj isKindOfClass:[NSNull class]]) {
            [valueList addObject:[NSString stringWithFormat:@"%@ is %@",key, valueKey]];
        } else {
            [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        }
        [bindValueList addBindKey:valueKey bindValue:obj];
    }];
    
    return [valueList componentsJoinedByString:@","];
}


- (NSString *)bindToUpdateValueList:(NSMutableArray<NSInvocation *> *)bindValueList {
    
    NSMutableArray *valueList = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *valueKey = [NSString stringWithFormat:@":%@",key];
        [valueList addObject:[NSString stringWithFormat:@"%@ = %@", key, valueKey]];
        [bindValueList addBindKey:valueKey bindValue:obj];
    }];
    
    return [valueList componentsJoinedByString:@","];
}


@end
