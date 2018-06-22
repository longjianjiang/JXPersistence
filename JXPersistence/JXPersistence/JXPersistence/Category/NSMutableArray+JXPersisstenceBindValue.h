//
//  NSMutableArray+JXPersisstenceBindValue.h
//  JXPersistence
//
//  Created by zl on 2018/6/22.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (JXPersisstenceBindValue)

- (void)addBindKey:(NSString *)bindKey bindValue:(id)bindValue;

@end

NS_ASSUME_NONNULL_END
