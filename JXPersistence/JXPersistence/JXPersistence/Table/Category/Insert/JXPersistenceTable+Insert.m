//
//  JXPersistenceTable+Insert.m
//  JXPersistence
//
//  Created by zl on 2018/6/22.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPersistenceTable+Insert.h"
#import "JXPersistenceQueryCommand+DataOperations.h"
#import "JXPersistenceQueryCommand+Status.h"
#import "JXPersistenceDefines.h"

static NSString * const kJXPersistenceErrorUserinfoKeyErrorRecord = @"kJXPersistenceErrorUserinfoKeyErrorRecord";

@implementation JXPersistenceTable (Insert)

- (BOOL)insertRecordList:(NSArray<NSObject<JXPersistenceRecordProtocol> *> *)recordList error:(NSError * _Nullable __autoreleasing *)error {
    BOOL result = YES;
    
    for (id<JXPersistenceRecordProtocol> record in recordList) {
        result = [self insertRecord:recordList error:error];
        
        if (result == NO) {
            break;
        }
    }
    
    return result;
}

- (BOOL)insertRecord:(NSObject<JXPersistenceRecordProtocol> *)record error:(NSError * _Nullable __autoreleasing *)error {
    BOOL isSuccess = YES;
    
    if (record) {
        
        if ([self.child isCorrectToInsertRecord:record]) {
            
            if ([[self.queryCommand insertTable:self.child.tableName columnInfo:self.child.columnInfo dataList:@[] error:error] executeWithError:error]) {
                
                if ([[self.queryCommand rowsChanged] integerValue] > 0) {
                    
                    [record setValue:[self.queryCommand lastInsertRowId] forKey:[self.child primaryKeyName]];
                    
                } else {
                    
                    isSuccess = NO;
                    if (error) {
                        *error = [self errorWithRecord:record];
                    }
                    
                }
                
            } else {
                
                isSuccess = NO;
                if (error) {
                    *error = [self errorWithRecord:record];
                }
            }
            
        } else {
            isSuccess = NO;
            if (error) {
                *error = [self errorWithRecord:record];
            }
        }
    }
    return isSuccess;
}

- (NSNumber *)insertValue:(id)value forKey:(NSString *)key error:(NSError * _Nullable __autoreleasing *)error {
    
    if (value == nil) {
        value = [NSNull null];
    }
    
    if (key == nil) {
        return nil;
    }
    
    if (self.child.columnDefaultValue && value == [NSNull null]) {
        id defaultValue = [self.child.columnDefaultValue valueForKey:key];
        
        if (defaultValue) {
            value = defaultValue;
        }
    }
    
    BOOL result = [self.queryCommand insertTable:self.child.tableName columnInfo:self.child.columnInfo dataList:@[@{key: value}] error:error];
    if (result) {
        return [self.queryCommand lastInsertRowId];
    } else {
        return nil;
    }
}


#pragma mark - private method
- (NSError *)errorWithRecord:(NSObject <JXPersistenceRecordProtocol> *)record {
    return [NSError errorWithDomain:kJXPersistanceErrorDomain
                               code:JXPersistanceErrorCodeRecordNotAvailableToInsert
                           userInfo:@{
                                      NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n%@\n is failed to pass validation, and can not insert", [record dictionaryRepresentationWithTable:self.child]],
                                      kJXPersistenceErrorUserinfoKeyErrorRecord:record
                                      }];
}
@end
