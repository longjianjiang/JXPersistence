//
//  JXPersistenceQueryCommand+DataOperations.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand+DataOperations.h"
#import "JXPersistenceDefines.h"

@implementation JXPersistenceQueryCommand (DataOperations)

- (JXPersistenceSQLStatement *)insertTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo dataList:(NSArray *)dataList error:(NSError *__autoreleasing *)error {
    
    if (JXPersistance_isEmptyString(tableName) || dataList == nil) {
        return nil;
    }
    
    NSMutableArray *valueItemList = [[NSMutableArray alloc] init];
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    NSMutableArray <NSInvocation *> *bindValueList = [[NSMutableArray alloc] init];
    
    [dataList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull recordItem, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *valueList = [[NSMutableArray alloc] init];
        [recordItem enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull columnKey, id  _Nonnull columnValue, BOOL * _Nonnull stop) {
            if ([columnList containsObject:columnKey] == NO) {
                [columnList addObject:columnKey];
            }
            NSString *valueKey = [NSString stringWithFormat:@":%@%lu", columnKey, (unsigned long)idx];
            [valueList addObject:valueKey];
//            [bindValueList addBindKey:valueKey bindValue:columnValue columnDescription:columnInfo[columnName]];
        }];
        [valueItemList addObject:[NSString stringWithFormat:@"(%@)", [valueList componentsJoinedByString:@","]]];
    }];
    
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO `%@` (%@) VALUES %@;", tableName, [columnList componentsJoinedByString:@","], [valueItemList componentsJoinedByString:@","]];
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}

- (JXPersistenceSQLStatement *)deleteTable:(NSString *)tableName whereString:(NSString *)whereString bindValueList:(NSArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error {
    
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE %@", tableName, whereString];
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}

- (JXPersistenceSQLStatement *)updateTable:(NSString *)tableName valueString:(NSString *)valueString whereString:(NSString *)whereString bindValueList:(NSArray<NSInvocation *> *)bindValueList error:(NSError *__autoreleasing *)error {
    
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName, valueString, whereString];
    return [self compileSqlString:sqlString bindValueList:bindValueList error:error];
}
@end
