//
//  TDRemarkingListDataCenter.h
//  TeacherDashbord
//
//  Created by zl on 2018/7/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDRemarkingRecord.h"


@interface TDRemarkingListDataCenter : NSObject

- (void)insertOneRemarkingRecord:(TDRemarkingRecord *)record;

- (void)deleteOneRemarkingRecord:(NSNumber *)gid;

- (NSArray <NSDictionary *> *)getAllRemarkingList;

/**
 按条件获取点评中列表
 
 @param classroomId 传nil， 返回所有
 @param isVip 传nil, 返回所有； 1为vip
 @param isToday 传nil, 返回所有；1为今天
 @param isDesc 默认降序也就是时间从近到远; 1为降序
 */
- (NSArray <NSDictionary *> *)getRemarkingListClassroomId:(NSNumber *)classroomId
                                                         isVip:(NSNumber *)isVip
                                                       isToday:(NSNumber *)isToday
                                                        isDesc:(NSNumber *)isDesc;


@end
