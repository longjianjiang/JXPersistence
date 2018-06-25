//
//  JXTestDataCenter.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/24.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXTestRecord.h"

@interface JXTestDataCenter : NSObject

- (void)insertOneRecord:(JXTestRecord *)record;

- (void)updateRecordWithBookId:(NSNumber *)bookId updatePageNumber:(NSNumber *)updatePage;

- (void)deleteRecordWithBookId:(NSNumber *)bookId;

- (NSArray <JXTestRecord *> *)getAllRecord;

- (NSNumber *)getLastPageIndexWithBookId:(NSNumber *)bookId;

- (NSInteger)getRecordCount;
@end
