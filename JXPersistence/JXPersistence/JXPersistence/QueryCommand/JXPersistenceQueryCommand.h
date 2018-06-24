//
//  JXPersistenceQueryCommand.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPersistenceSQLStatement.h"
#import "JXPersistenceDatabase.h"


@interface JXPersistenceQueryCommand : NSObject

@property (nonatomic, weak, readonly) JXPersistenceDatabase *database;

- (instancetype)initWithDatabaseName:(NSString *)databaseName;

- (instancetype)initWithDatabase:(JXPersistenceDatabase *)database;

- (JXPersistenceSQLStatement *)compileSqlString:(NSString *)sqlString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList error:(NSError **)error;

@end
