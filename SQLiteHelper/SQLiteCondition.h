//
//  SQLiteTask.h
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteResult.h"
#import "SQLiteDriver.h"



@interface SQLiteCondition : NSObject

- (SQLiteCondition *)initWitTabName:(NSString *)name;

- (SQLiteCondition *)limit:(NSInteger)count;
- (SQLiteCondition *)page:(NSInteger)page;

- (SQLiteCondition *)orderBy:(NSString *)order;
- (SQLiteCondition *)descOrderBy:(NSString *)order;
- (SQLiteCondition *)ascOrderBy:(NSString *)order;

- (SQLiteCondition *)fields:(id)fields;
- (SQLiteCondition *)groupBy:(id)fields;

- (SQLiteCondition *)where:(id)condition;

- (NSString *)selectSql;
- (NSString *)countSql;
- (NSString *)insertSql:(NSArray *)rows;
- (NSString *)deleteSql;
- (NSString *)updateSql:(NSArray *)values;

- (void)clean;
@end
