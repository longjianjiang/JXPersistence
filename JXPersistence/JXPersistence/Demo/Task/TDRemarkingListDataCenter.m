//
//  TDRemarkingListDataCenter.m
//  TeacherDashbord
//
//  Created by zl on 2018/7/3.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "TDRemarkingListDataCenter.h"
#import "TDRemarkingTable.h"

@interface TDRemarkingListDataCenter()

@property (nonatomic, strong) TDRemarkingTable *remarkingTable;

@end


@implementation TDRemarkingListDataCenter

- (void)insertOneRemarkingRecord:(TDRemarkingRecord *)record {
  [self.remarkingTable insertRecord:record error:NULL];
}

- (void)deleteOneRemarkingRecord:(NSNumber *)gid {
    [self.remarkingTable deleteRecordWhereKey:@"gid" value:gid error:NULL];
}

- (NSArray<NSDictionary *> *)getAllRemarkingList {
  
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM `%@` ORDER BY %@ DESC", self.remarkingTable.child.tableName, @"submit_time"];
    
    NSArray *recordList = [self.remarkingTable findAllWithSQL:sqlString params:nil error:NULL];
    NSMutableArray *result = [NSMutableArray array];
    for (TDRemarkingRecord *record in recordList) {
        [result addObject:[record dictionaryRepresentationWithTable:self.remarkingTable]];
    }
    
    return result;
}

- (NSArray<NSDictionary *> *)getRemarkingListClassroomId:(NSNumber *)classroomId
                                                        isVip:(NSNumber *)isVip
                                                      isToday:(NSNumber *)isToday
                                                       isDesc:(NSNumber *)isDesc {
    
    NSString *tableName = self.remarkingTable.child.tableName;
    
    NSString *columnTime = @"submit_time";
    NSString *columnClassroomId = @"classroom_id";
    NSString *columnIsVip = @"is_vip";
    
    NSMutableString *sqlString = [NSMutableString stringWithFormat:@"SELECT * FROM `%@`", tableName];
    
    NSString *classroomWhereString = nil;
    NSString *isVipWhereString = nil;
    NSString *isTodayWhereString = nil;
    NSString *orderbyString = nil;
    
    NSMutableDictionary *bindParams = [NSMutableDictionary dictionary];
    
    if (classroomId) {
        NSString *valueClassroomId = [NSString stringWithFormat:@":JXPersistenceWhere_%@",columnClassroomId];
        classroomWhereString = [NSString stringWithFormat:@"%@ = %@", columnClassroomId, valueClassroomId];
        [sqlString appendString:[NSString stringWithFormat:@" WHERE %@", classroomWhereString]];
        [bindParams setObject:classroomId forKey:valueClassroomId];
    }
    
    if (isVip) {
        NSString *valueIsVip = [NSString stringWithFormat:@":JXPersistenceWhere_%@",columnIsVip];
        isVipWhereString = [NSString stringWithFormat:@"%@ = %@", columnIsVip, valueIsVip];
        
        if ([sqlString rangeOfString:@"WHERE"].length) {
            [sqlString appendString:[NSString stringWithFormat:@" AND %@", isVipWhereString]];
        } else {
            [sqlString appendString:[NSString stringWithFormat:@" WHERE %@", isVipWhereString]];
        }
        
        [bindParams setObject:isVip forKey:valueIsVip];
    }
    
    if ([isToday integerValue] == 1) {
        isTodayWhereString = [NSString stringWithFormat:@"date(datetime(%@ , 'unixepoch')) = date('now')", columnTime];
        
        if ([sqlString rangeOfString:@"WHERE"].length) {
            [sqlString appendString:[NSString stringWithFormat:@" AND %@", isTodayWhereString]];
        } else {
            [sqlString appendString:[NSString stringWithFormat:@" WHERE %@", isTodayWhereString]];
        }
        
    }
    
    NSString *descString = ([isDesc integerValue] == 1 || isDesc == nil) ? @"DESC" : @"ASC";
    orderbyString = [NSString stringWithFormat:@" ORDER BY %@ %@", columnTime, descString];
    
    [sqlString appendString:orderbyString];
    
    
    NSArray *recordList = [self.remarkingTable findAllWithSQL:sqlString params:bindParams error:NULL];
    NSMutableArray *result = [NSMutableArray array];
    for (TDRemarkingRecord *record in recordList) {
        [result addObject:[record dictionaryRepresentationWithTable:self.remarkingTable]];
    }
    
    return result;
    
}

#pragma mark - getter and setter
- (TDRemarkingTable *)remarkingTable {
  if (_remarkingTable == nil) {
    _remarkingTable = [TDRemarkingTable new];
  }
  return _remarkingTable;
}


@end
