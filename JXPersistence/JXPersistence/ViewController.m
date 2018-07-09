//
//  ViewController.m
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "TDRemarkingTable.h"
#import "TDRemarkingRecord.h"
#import "TDRemarkingListDataCenter.h"

#import <libkern/OSAtomic.h>


@interface ViewController () {
    volatile uint32_t _isUploading;
}

@property (nonatomic, strong) TDRemarkingListDataCenter *dataCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSet *set = [NSSet setWithObjects:@2, @5, @7, @10, nil];
    NSSet *result = [set objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
        *stop = YES;
        return *stop;
    }];

    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"item is %@",obj);
    }];
    NSLog(@"%@", result);
    
    TDRemarkingRecord *record = [TDRemarkingRecord new];
//    record.gid = @17;
//    record.is_vip = @1;
//    record.course_name = @"course name";
//    record.classroom_id = @3;
//    record.submit_time = @([[NSDate date] timeIntervalSince1970]);
//    record.photo_url = @"http";
//    record.file_path = @"path";
    
    [self.dataCenter insertOneRemarkingRecord:record];
    
    NSLog(@"path is %@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]);
    
    
    NSLog(@"%@", [self.dataCenter getRemarkingListClassroomId:nil isVip:nil isToday:nil isDesc:nil]);
}


#pragma mark - getter and setter
- (TDRemarkingListDataCenter *)dataCenter {
    if (_dataCenter == nil) {
        _dataCenter = [TDRemarkingListDataCenter new];
    }
    return _dataCenter;
}


@end
