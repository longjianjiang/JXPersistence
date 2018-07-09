//
//  TDRemarkingRecord.h
//  TeacherDashbord
//
//  Created by zl on 2018/7/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JXPersistence.h"

typedef NS_ENUM(NSInteger, TDRemarkingRecordUploadState) {
    TDRemarkingRecordUploadStateFail = -1, // 上传失败
    TDRemarkingRecordUploadStateDefault, // 未开始上传
    TDRemarkingRecordUploadStateSuccess, // 上传成功
};

//@"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
//@"child_nn":@"TEXT",
//@"gid": @"INTEGER",
//@"is_vip": @"INTEGER",
//@"course_name": @"TEXT",
//@"classroom_id": @"INTEGER",
//@"submit_time": @"INTEGER",
//@"photo_url": @"TEXT",
//@"file_path": @"TEXT"


@interface TDRemarkingRecord : JXPersistenceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSNumber *upload_state;

@property (nonatomic, strong) NSString *child_nn;
@property (nonatomic, strong) NSNumber *gid;
@property (nonatomic, strong) NSNumber *is_vip;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, copy) NSNumber *classroom_id;
@property (nonatomic, copy) NSNumber *submit_time;
@property (nonatomic, copy) NSString *photo_url;
@property (nonatomic, copy) NSString *file_path;

@end
