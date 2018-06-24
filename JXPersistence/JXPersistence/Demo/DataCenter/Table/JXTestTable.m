//
//  JXTestTable.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/24.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXTestTable.h"
#import "JXTestRecord.h"

@implementation JXTestTable

#pragma mark - JXPersistenceTableProtocol
- (NSString *)tableName {
    return @"test_t";
}

- (NSString *)databaseName {
    return @"test.sqlite";
}

- (NSDictionary *)columnInfo {
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"book_name":@"TEXT",
             @"book_id": @"INTEGER",
             @"book_last_open_page": @"INTEGER"
             };
}

- (Class)recordClass {
    return [JXTestRecord class];
}

- (NSString *)primaryKeyName {
    return @"primaryKey";
}

@end
