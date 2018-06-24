//
//  JXTestDataCenter.m
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/24.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXTestDataCenter.h"
#import "JXTestTable.h"
#import "JXPersistence.h"

@interface JXTestDataCenter()

@property (nonatomic, strong) JXTestTable *testTable;
@end


@implementation JXTestDataCenter

- (void)insertOneRecord:(JXTestRecord *)record {
    [self.testTable insertRecord:record error:NULL];
}

- (void)updateRecordWithBookId:(NSNumber *)bookId updatePageNumber:(NSNumber *)updatePage {
    [self.testTable updateValue:updatePage forKey:@"book_last_open_page" whereKey:@"book_id" inList:@[bookId] error:NULL];
}

- (void)deleteRecordWithBookId:(NSNumber *)bookId {
    [self.testTable deleteRecordWhereKey:@"book_id" value:bookId error:NULL];
}


- (NSArray<JXTestRecord *> *)getAllRecord {
    return [self.testTable findAllWithError:NULL];
}

- (NSNumber *)getLastPageIndexWithBookId:(NSNumber *)bookId {
    JXTestRecord *record = [self.testTable findFirstRowWithWhereCondition:@"book_id = :book_id" conditionParams:@{@":book_id": bookId} isDistinct:YES error:NULL];
    return record.book_last_open_page;
}

#pragma mark - getter and setter
- (JXTestTable *)testTable {
    if (_testTable == nil) {
        _testTable = [JXTestTable new];
    }
    return _testTable;
}
@end
