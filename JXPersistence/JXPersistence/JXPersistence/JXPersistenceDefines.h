//
//  JXPersistenceDefines.h
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#ifndef JXPersistenceDefines_h
#define JXPersistenceDefines_h


#define JXPersistance_isEmptyString(string) ((string == nil || string.length == 0) ? YES : NO)

static NSString * const kJXPersistanceErrorDomain = @"kJXPersistanceErrorDomain";

/**
 *  error code in JXPersistance
 */
typedef NS_ENUM(NSUInteger, JXPersistanceErrorCode){
    /**
     *  failed to open database file
     */
    JXPersistanceErrorCodeOpenError,
    /**
     *  failed to create database file
     */
    JXPersistanceErrorCodeCreateError,
    /**
     *  failed to execute SQL
     */
    JXPersistanceErrorCodeQueryStringError,
    /**
     *  record is not available to INSERT
     */
    JXPersistanceErrorCodeRecordNotAvailableToInsert,
    /**
     *  record is not available to UPDATE
     */
    JXPersistanceErrorCodeRecordNotAvailableToUpdate,
    /**
     *  failed to set key for value in record
     */
    JXPersistanceErrorCodeFailedToSetKeyForValue,
};


#endif /* JXPersistenceDefines_h */
