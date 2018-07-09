//
//  JXPersistenceQueryCommand+SchemaOperations.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand+SchemaOperations.h"
#import "JXPersistenceDefines.h"

@implementation JXPersistenceQueryCommand (SchemaOperations)

- (JXPersistenceSQLStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo {
    if (JXPersistance_isEmptyString(tableName)) {
        return nil;
    }
    
    NSMutableArray *columnList = [NSMutableArray array];
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull columnName, NSString *  _Nonnull columnDesc, BOOL * _Nonnull stop) {
        if (JXPersistance_isEmptyString(columnDesc)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@`",columnName]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@",columnName, columnDesc]];
        }
    }];
    
    NSString *columns = [columnList componentsJoinedByString:@","];
    
    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];
    
    return [self compileSqlString:sqlString bindValueList:nil error:NULL];
}

- (JXPersistenceSQLStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo columnDefaultValue:(NSDictionary *)defaultSetting {
    
    if (JXPersistance_isEmptyString(tableName)) {
        return nil;
    }
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        id defaultValue = [defaultSetting valueForKey:columnName];
        
        if ([defaultValue isKindOfClass:[NSString class]]) {
            defaultValue = [NSString stringWithFormat:@"'%@'",defaultValue];
        }
        
        NSString *defaultSetting = @"";
        if(defaultValue) {
            defaultSetting = [NSString stringWithFormat:@"DEFAULT %@",defaultValue];
        }
        
        if (JXPersistance_isEmptyString(columnDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", columnName, defaultSetting]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@ %@", columnName, columnDescription, defaultSetting]];
        }
    }];
    
    NSString *columns = [columnList componentsJoinedByString:@","];
    
    NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", tableName, columns];
    
    return [self compileSqlString:sqlString bindValueList:nil error:NULL];
}


- (JXPersistenceSQLStatement *)dropTable:(NSString *)tableName {
    if (JXPersistance_isEmptyString(tableName)) {
        return nil;
    }
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;", tableName];
    
    return [self compileSqlString:sqlString bindValueList:nil error:NULL];
}

- (JXPersistenceSQLStatement *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName {
    if (JXPersistance_isEmptyString(tableName) || JXPersistance_isEmptyString(columnInfo) || JXPersistance_isEmptyString(columnName)) {
        return nil;
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", tableName, columnName, columnInfo];
    
    return [self compileSqlString:sqlString bindValueList:nil error:NULL];

}
@end
