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

@interface SQLiteDriver : NSObject

@property (nonatomic, strong)NSString *dbPath;
@property (nonatomic, assign)sqlite3 *dbHandler;


- (id)initWithDatabase:(NSString *)database;

- (void)execSql:(NSString *)sql result:(void(^)(NSError* err))result;

- (void)execSql:(NSString *)sql call:(void(^)(SQLiteResult* res))result;

- (void)close;
@end