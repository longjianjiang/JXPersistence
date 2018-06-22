//
//  JXPersistenceQueryCommand+SchemaOperations.h
//  JXPersistence
//
//  Created by longjianjiang on 2018/6/22.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand.h"

@interface JXPersistenceQueryCommand (SchemaOperations)

- (JXPersistenceSQLStatement *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo;

- (JXPersistenceSQLStatement *)dropTable:(NSString *)tableName;

- (JXPersistenceSQLStatement *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName;

@end
