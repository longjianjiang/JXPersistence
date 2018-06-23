//
//  JXPersistenceQueryCommand+Status.h
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPersistenceQueryCommand (Status)

- (NSNumber *)lastInsertRowId;
- (NSNumber *)rowsChanged;

@end

NS_ASSUME_NONNULL_END
