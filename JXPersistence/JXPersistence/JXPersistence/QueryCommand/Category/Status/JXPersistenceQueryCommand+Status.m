//
//  JXPersistenceQueryCommand+Status.m
//  JXPersistence
//
//  Created by zl on 2018/6/23.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceQueryCommand+Status.h"
#import <sqlite3.h>

@implementation JXPersistenceQueryCommand (Status)

- (NSNumber *)lastInsertRowId {
    return @(sqlite3_last_insert_rowid(self.database.database));
}

- (NSNumber *)rowsChanged {
    return @(sqlite3_changes(self.database.database));
}

@end
