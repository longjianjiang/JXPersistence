//
//  JXPersistenceDatabasePool.h
//  JXPersistence
//
//  Created by zl on 2018/6/20.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPersistenceDatabase.h"


NS_ASSUME_NONNULL_BEGIN

@interface JXPersistenceDatabasePool : NSObject

+ (instancetype)sharedInstance;

- (JXPersistenceDatabase *)databaseWithName:(NSString *)databaseName;

- (void)closeDatabaseWithName:(NSString *)databaseName;

- (void)closeAllDatabase;

@end

NS_ASSUME_NONNULL_END
