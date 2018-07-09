//
//  TDRemarkingTable.m
//  TeacherDashbord
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "TDRemarkingTable.h"
#import "TDRemarkingRecord.h"

@implementation TDRemarkingTable

#pragma mark - JXPersistenceTableProtocol
- (NSString *)tableName {
  return @"remarking_t";
}

- (NSString *)databaseName {
  return @"task.sqlite";
}

- (NSDictionary *)columnInfo {
  return @{
           @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
           @"child_nn":@"TEXT",
           @"gid": @"INTEGER",
           @"is_vip": @"INTEGER",
           @"course_name": @"TEXT",
           @"classroom_id": @"INTEGER",
           @"submit_time": @"INTEGER",
           @"photo_url": @"TEXT",
           @"file_path": @"TEXT",
            @"upload_state": @"INTEGER" // 上传状态
           };
}

- (Class)recordClass {
  return [TDRemarkingRecord class];
}

- (NSString *)primaryKeyName {
  return @"primaryKey";
}

- (NSDictionary *)columnDefaultValue {
    return @{@"upload_state": @(TDRemarkingRecordUploadStateDefault)};
}

@end
