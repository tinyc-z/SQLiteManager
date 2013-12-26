//
//  SQLiteDriver.h
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteResult.h"

typedef NS_ENUM(NSUInteger,SQLiteTaskType)
{
    SQLiteTaskTypeWrite,
    SQLiteTaskTypeRead,
};

@interface SQLiteDriver : NSObject

@property (nonatomic, retain)NSString *dbPath;
@property (nonatomic, assign)sqlite3 *dbHandler;


- (id)initWithDatabase:(NSString *)database;
//-(BOOL)execSql:(NSString *)sql;
-(BOOL)execSql:(NSString *)sql Error:(NSError **)error;
- (SQLiteResult* )parseSql:(NSString *)sql;

- (void)parseSql:(NSString *)sql call:(void(^)(SQLiteResult* res))result;

- (void)close;
@end