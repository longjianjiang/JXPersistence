//
//  JXPersistenceQueryCommand+DataOperations.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/21.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand.h"

@interface JXPersistenceQueryCommand (DataOperations)

- (JXPersistenceSQLStatement *)insertTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo dataList:(NSArray *)dataList error:(NSError *__autoreleasing *)error;

- (JXPersistenceSQLStatement *)updateTable:(NSString *)tableName valueString:(NSString *)valueString whereString:(NSString *)whereString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList error:(NSError * __autoreleasing *)error;

- (JXPersistenceSQLStatement *)deleteTable:(NSString *)tableName whereString:(NSString *)whereString bindValueList:(NSMutableArray <NSInvocation *> *)bindValueList error:(NSError * __autoreleasing *)error;

@end
