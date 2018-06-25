//
//  JXTestRecord.h
//  JXPersistenceTests
//
//  Created by zl on 2018/6/25.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXTestRecord : JXPersistenceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSString *book_name;
@property (nonatomic, strong) NSNumber *book_id;
@property (nonatomic, strong) NSNumber *book_last_open_page;

@end

NS_ASSUME_NONNULL_END
