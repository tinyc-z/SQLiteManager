//
//  SQLiteDriver.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "SQLiteDriver.h"

@interface SQLiteDriver()

@property(assign)dispatch_queue_t taskQueue;

@end


@implementation SQLiteDriver


- (void)dealloc
{
    [self close];
}


- (id)initWithDatabase:(NSString *)database
{
    
	if (self = [super init]) {
        
        self.taskQueue=dispatch_queue_create("sqlite.q", DISPATCH_QUEUE_SERIAL);
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/WOWSQLite/"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.dbPath = [documentsDir stringByAppendingPathComponent:database];
        
		if(SQLITE_OK == sqlite3_open([self.dbPath UTF8String], &_dbHandler)) {
            char *errorMsg;
            if (sqlite3_exec(_dbHandler, "PRAGMA journal_mode=WAL;", NULL, NULL, &errorMsg) != SQLITE_OK) {
                NSLog(@"Failed to set WAL mode: %s", errorMsg);
            }
			return self;
		}
        
	}
	return nil;
}

- (void)checkAndCreateDatabase:(NSString *)database {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(! [fileManager fileExistsAtPath:self.dbPath]) {
        [fileManager createFileAtPath:self.dbPath contents:nil attributes:nil];
        //		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:database];
        //		[fileManager copyItemAtPath:databasePathFromApp toPath:self.dbPath error:nil];
	}
}

//- ()

- (void)execSql:(NSString *)sql result:(void(^)(NSError* err))result
{
    dispatch_async(self.taskQueue, ^{
        char *err;
        int res=sqlite3_exec(self.dbHandler, [sql UTF8String], NULL, NULL, &err);
        if (res!= SQLITE_OK) {
            NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithUTF8String:err] code:res userInfo:nil];
            if(result)result(error);
        }else{
            if(result)result(nil);
        }
     });
}

- (void)execSql:(NSString *)sql call:(void(^)(SQLiteResult* res))result
{
    dispatch_async(self.taskQueue, ^{
        SQLiteResult *res = [self execSql:sql];
        if(result)result(res);
    });
}

- (SQLiteResult* )execSql:(NSString *)sql
{
    SQLiteResult* res = [[SQLiteResult alloc] init];
    res.sql=sql;
	sqlite3_stmt *compiledStatement;
	const char *sqlStatement = [sql UTF8String];
	res.code= sqlite3_prepare_v2(self.dbHandler, sqlStatement, -1, &compiledStatement, NULL);
	if(SQLITE_OK != res.code) {
		res.msg = [NSString stringWithUTF8String:sqlite3_errmsg(self.dbHandler)];
		return res;
	}
    int resCount=sqlite3_data_count(compiledStatement);
    res.data=[[NSMutableArray alloc] initWithCapacity:resCount];
    NSMutableArray *fields=[[NSMutableArray alloc] init];
    res.fileds=fields;
    int columnNum;
    BOOL run=YES;
    NSMutableDictionary *rowData;
    while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
        if (run) {
            columnNum = sqlite3_column_count(compiledStatement);
            for (int i = 0; i < columnNum; i ++) {
                char *name=(char *)sqlite3_column_name(compiledStatement,i);
                [fields addObject:[NSString stringWithUTF8String:name]];
            }
            run=NO;
        }
        rowData = [[NSMutableDictionary alloc] initWithCapacity:columnNum];
		for (int i = 0; i < columnNum; i ++) {
            char *text=(char *)sqlite3_column_text(compiledStatement, i);
			if (NULL != text) {
				[rowData setValue:[NSString stringWithUTF8String:text] forKey:fields[i]];
			}else {
                [rowData setValue:[NSNull null] forKey:fields[i]];
			}
		}
		[res.data addObject:rowData];
	}
//	sqlite3_reset(compiledStatement);
    sqlite3_finalize(compiledStatement);
	return res;
}

/**
 *  close db connect
 */
- (void)close
{
    sqlite3_close(_dbHandler);
    _dbHandler=NULL;
}

@end
