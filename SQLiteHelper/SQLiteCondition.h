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

- (SQLiteCondition *)initWitTab:(NSString *)name;
- (SQLiteCondition *)creatTab:(NSString *)name ifNotExists:(NSString *)fields,...;
- (SQLiteCondition *)limit:(NSInteger)count;
- (SQLiteCondition *)page:(NSInteger)page;
- (SQLiteCondition *)orderBy:(NSString *)order;
- (SQLiteCondition *)fields:(id)fields;
- (SQLiteCondition *)where:(id)condition;

- (NSString *)selectSql;
@end
