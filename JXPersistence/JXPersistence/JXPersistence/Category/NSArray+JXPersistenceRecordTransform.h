//
//  NSArray+JXPersistenceRecordTransform.h
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (JXPersistenceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType;

@end

NS_ASSUME_NONNULL_END
