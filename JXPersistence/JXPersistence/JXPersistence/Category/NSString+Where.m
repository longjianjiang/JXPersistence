//
//  NSString+Where.m
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "NSString+Where.h"
#import "NSMutableArray+JXPersisstenceBindValue.h"

@implementation NSString (Where)


//[self.testTable deleteWithWhereCondition:@"name = :name" conditionParams:@{@":name":@"casa"} error:NULL];

- (NSString *)whereStringWithConditionParams:(NSDictionary *)conditionParams bindValueList:(NSMutableArray<NSInvocation *> *)bindValueList {
    
    NSMutableString *whereString = [self mutableCopy];
    [conditionParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString *whereKey = [key mutableCopy];
        [whereKey deleteCharactersInRange:NSMakeRange(0, 1)];
        [whereKey insertString:@":JXPersistenceWhere_" atIndex:0];
        [whereString replaceOccurrencesOfString:key withString:whereKey options:0 range:NSMakeRange(0, whereString.length)];
        [bindValueList addBindKey:whereKey bindValue:obj];
    }];
    
    return whereString;
}

@end
