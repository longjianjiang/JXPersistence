//
//  JXPersistenceTransaction.h
//  JXPersistence
//
//  Created by zl on 2018/6/25.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPersistenceQueryCommand.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JXPersistenceTransactionType) {
    JXPersistenceExclusiveTransaction,
    JXPersistenceDeferredTransaction,
    JXPersistenceImmediateTransaction,
};


@interface JXPersistenceTransaction : NSObject

/**
 start a transaction with block

 @param transaction type
 @param queryCommand table query command
 @param block action to be execute in transaction
 */
+ (void)beginTransaction:(JXPersistenceTransactionType)transaction
            queryCommand:(JXPersistenceQueryCommand *)queryCommand
               withBlock:(void (^)(BOOL *rollback))block;



@end

NS_ASSUME_NONNULL_END
