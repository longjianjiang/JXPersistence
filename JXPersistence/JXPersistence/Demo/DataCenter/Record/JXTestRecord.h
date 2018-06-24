//
//  JXTestRecord.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/24.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceRecord.h"

//@"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
//@"book_name":@"TEXT",
//@"book_id": @"INTEGER",
//@"book_last_open_page": @"INTEGER"

@interface JXTestRecord : JXPersistenceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSString *book_name;
@property (nonatomic, strong) NSNumber *book_id;
@property (nonatomic, strong) NSNumber *book_last_open_page;

@end
