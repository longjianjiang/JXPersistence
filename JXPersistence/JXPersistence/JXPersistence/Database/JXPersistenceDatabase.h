//
//  JXPersistenceDatabase.h
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


NS_ASSUME_NONNULL_BEGIN

@interface JXPersistenceDatabase : NSObject

@property (nonatomic, unsafe_unretained, readonly) sqlite3 *datebase;

@property (nonatomic, copy, readonly) NSString *databaseName;

@property (nonatomic, copy, readonly) NSString *databaseFilePath;

- (instancetype)initWithDatabaeName:(NSString *)databaseName error:(NSError **)error;

- (void)closeDatabase;

@end

NS_ASSUME_NONNULL_END
