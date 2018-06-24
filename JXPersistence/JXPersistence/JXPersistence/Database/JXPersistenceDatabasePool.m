//
//  JXPersistenceDatabasePool.m
//  JXPersistence
//
//  Created by zl on 2018/6/20.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceDatabasePool.h"

@interface JXPersistenceDatabasePool ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, JXPersistenceDatabase *> *databaseList;
@end


@implementation JXPersistenceDatabasePool

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JXPersistenceDatabasePool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JXPersistenceDatabasePool new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _databaseList = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNSThreadWillExitNotification:) name:NSThreadWillExitNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self closeAllDatabase];
}

#pragma mark - public method
- (JXPersistenceDatabase *)databaseWithName:(NSString *)databaseName {
    if (databaseName == nil || databaseName.length < 1) {
        return nil;
    }
    
    @synchronized (self) {
        NSString *key = [NSString stringWithFormat:@"%@ - %@", [NSThread currentThread], [self filePathWithDatabaseName:databaseName]];
        JXPersistenceDatabase *databaseItem = self.databaseList[key];
        if (databaseItem == nil) {
            NSError *error = nil;
            databaseItem = [[JXPersistenceDatabase alloc] initWithDatabaeName:databaseName error:&error];
            if (error) {
                NSLog(@"Error at %s:[%d]:%@",__FILE__, __LINE__, error);
            } else {
                self.databaseList[key] = databaseItem;
            }
        }
        return databaseItem;
    }
}

- (void)closeAllDatabase {
    @synchronized (self) {
        [self.databaseList  enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JXPersistenceDatabase * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[JXPersistenceDatabase class]]) {
                [obj closeDatabase];
            }
        }];
        
        [self.databaseList removeAllObjects];
    }
}

- (void)closeDatabaseWithName:(NSString *)databaseName {
    @synchronized (self) {
        NSArray <NSString *> *allKeys = self.databaseList.allKeys;
        [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:[NSString stringWithFormat:@" - %@", [self filePathWithDatabaseName:databaseName]]]) {
                JXPersistenceDatabase *database = self.databaseList[obj];
                [database closeDatabase];
                [self.databaseList removeObjectForKey:obj];
            }
        }];
    }
}

#pragma mark - event response
- (void)didReceiveNSThreadWillExitNotification:(NSNotification *)noti {
    @synchronized (self) {
        NSMutableArray <JXPersistenceDatabase *> *databaseShouldClose = [NSMutableArray array];
        NSMutableArray <NSString *> *keyShouldDelete = [NSMutableArray array];
        
        [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, JXPersistenceDatabase * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key containsString:[NSString stringWithFormat:@"%@", [NSThread currentThread]]]) {
                [databaseShouldClose addObject:obj];
                [keyShouldDelete addObject:key];
            }
        }];
        
        [databaseShouldClose makeObjectsPerformSelector:@selector(closeDatabase)];
        [keyShouldDelete enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.databaseList removeObjectForKey:obj];
        }];
    }
}


#pragma mark - private methods
- (NSString *)filePathWithDatabaseName:(NSString *)databaseName {
    NSString *databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
    
    return databaseFilePath;
}
@end
