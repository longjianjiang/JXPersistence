//
//  JXPersistenceDatabase.m
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceDatabase.h"
#import "JXPersistenceDefines.h"

@interface JXPersistenceDatabase ()

@property (nonatomic, unsafe_unretained, readwrite) sqlite3 *datebase;

@property (nonatomic, copy, readwrite) NSString *databaseName;

@property (nonatomic, copy, readwrite) NSString *databaseFilePath;

@end


@implementation JXPersistenceDatabase

#pragma mark - life cycle
- (instancetype)initWithDatabaeName:(NSString *)databaseName error:(NSError * _Nullable __autoreleasing *)error {
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
        
        self.databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:self.databaseName];
        
        NSFileManager *defaultFileManager = [NSFileManager defaultManager];
        BOOL isFileExistsBefore = [defaultFileManager fileExistsAtPath:self.databaseFilePath];
        
        const char *path = [self.databaseFilePath UTF8String];
        int result = sqlite3_open_v2(path,
                                     &(_datebase),
                                     SQLITE_OPEN_CREATE |
                                     SQLITE_OPEN_READWRITE |
                                     SQLITE_OPEN_NOMUTEX |
                                     SQLITE_OPEN_SHAREDCACHE,
                                     NULL);
        
        if (result != SQLITE_OK && error) {
            
            JXPersistanceErrorCode errorCode = JXPersistanceErrorCodeOpenError;
            NSString *errorString = [NSString stringWithFormat:@"open database at %@ failed with error:\n %@", self.databaseFilePath, [NSString stringWithCString:sqlite3_errmsg(self.datebase) encoding:NSUTF8StringEncoding]];
            
            BOOL isDatabaseExists = [defaultFileManager fileExistsAtPath:self.databaseFilePath];
            if (isDatabaseExists == NO) {
                errorCode = JXPersistanceErrorCodeCreateError;
                errorString = [NSString stringWithFormat:@"craate database at %@ failed with error:\n %@", self.databaseFilePath,
                               [NSString stringWithCString:sqlite3_errmsg(self.datebase) encoding:NSUTF8StringEncoding]];
            }
            
            *error = [NSError errorWithDomain:kJXPersistanceErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorString}];
            [self closeDatabase];
            return nil;
        }
     }
    return self;
}

- (void)dealloc {
    [self closeDatabase];
}


#pragma mark - public method
- (void)closeDatabase {
    sqlite3_close_v2(_datebase);
    
    _datebase = NULL;
    _databaseFilePath = nil;
}



@end
