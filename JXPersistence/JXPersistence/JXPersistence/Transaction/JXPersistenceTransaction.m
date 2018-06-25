//
//  JXPersistenceTransaction.m
//  JXPersistence
//
//  Created by zl on 2018/6/25.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTransaction.h"

@implementation JXPersistenceTransaction

+ (void)beginTransaction:(JXPersistenceTransactionType)transaction queryCommand:(JXPersistenceQueryCommand *)queryCommand withBlock:(void (^)(BOOL * _Nonnull))block {
    if (queryCommand == nil || block == nil) {
        return;
    }
    
    switch (transaction) {
        case JXPersistenceExclusiveTransaction:
            [[queryCommand compileSqlString:@"BEGIN EXCLUSIVE TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
        case JXPersistenceImmediateTransaction:
            [[queryCommand compileSqlString:@"BEGIN IMMEDIATE TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
        case JXPersistenceDeferredTransaction:
            [[queryCommand compileSqlString:@"BEGIN DEFERRED TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
            break;
    }
    
    
    BOOL isRollback = NO;
    block(&isRollback);
    
    if (isRollback) {
        [[queryCommand compileSqlString:@"ROLLBACK TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
    } else {
        [[queryCommand compileSqlString:@"COMMIT TRANSACTION;" bindValueList:nil error:NULL] executeWithError:NULL];
    }
    
    
}


@end
