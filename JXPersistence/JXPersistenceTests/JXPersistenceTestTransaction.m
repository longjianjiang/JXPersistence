//
//  JXPersistenceTestTransaction.m
//  JXPersistenceTests
//
//  Created by zl on 2018/6/25.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JXPersistence.h"

#import "JXTestTable.h"
#import "JXTestRecord.h"


@interface JXPersistenceTestTransaction : XCTestCase

@property (nonatomic, strong) JXTestTable *testTable;

@end

@implementation JXPersistenceTestTransaction

- (void)setUp {
    [super setUp];
    self.testTable = [JXTestTable new];
    
    NSMutableArray *recordList = [NSMutableArray array];
    NSInteger count = 10;
    while (count --> 0) {
        JXTestRecord *record = [JXTestRecord new];
        record.book_id = @(count);
        record.book_name = [NSString stringWithFormat:@"book%ld",(long)count];
        record.book_last_open_page = @-1;
        [recordList addObject:record];
    }
    
    [self.testTable insertRecordList:recordList error:NULL];
}

- (void)tearDown {
   
    [self.testTable truncate];
    
    [super tearDown];
}

- (void)testInsertTransactionCommit {
    
    [JXPersistenceTransaction beginTransaction:JXPersistenceExclusiveTransaction queryCommand:self.testTable.queryCommand withBlock:^(BOOL * _Nonnull rollback) {
        NSMutableArray *recordList = [NSMutableArray array];
        NSInteger count = 7;
        while (count --> 0) {
            JXTestRecord *record = [JXTestRecord new];
            record.book_id = @(count);
            record.book_name = @"nancy";
            record.book_last_open_page = @-1;
            [recordList addObject:record];
        }
        
        [self.testTable insertRecordList:recordList error:NULL];
        
        *rollback = NO;
    }];
    
    NSInteger totalCount = [self.testTable countWithWhereCondition:@"book_name = :book_name" conditionParams:@{@":book_name" : @"nancy"} error:NULL];
    
    XCTAssertEqual(totalCount, 7);
}


- (void)testInsertTransactionRollback {
    
    [JXPersistenceTransaction beginTransaction:JXPersistenceExclusiveTransaction queryCommand:self.testTable.queryCommand withBlock:^(BOOL * _Nonnull rollback) {
        NSMutableArray *recordList = [NSMutableArray array];
        NSInteger count = 7;
        while (count --> 0) {
            JXTestRecord *record = [JXTestRecord new];
            record.book_id = @(count);
            record.book_name = @"jx";
            record.book_last_open_page = @-1;
            [recordList addObject:record];
        }
        
        [self.testTable insertRecordList:recordList error:NULL];
        
        *rollback = YES;
    }];
    
    
    NSInteger totalCount = [self.testTable countWithWhereCondition:@"book_name = :book_name" conditionParams:@{@":book_name" : @"jx"} error:NULL];
    
    XCTAssertEqual(totalCount, 0);
}

@end
