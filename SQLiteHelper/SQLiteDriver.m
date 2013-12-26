//
//  SQLiteDriver.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "SQLiteDriver.h"

@interface SQLiteDriver()

@property(nonatomic,strong)dispatch_queue_t taskQueue;
@end


@implementation SQLiteDriver


- (id)initWithDatabase:(NSString *)database
{
    
	if (self = [super init]) {
        
        self.taskQueue=dispatch_queue_create("sqlite.q", DISPATCH_QUEUE_SERIAL);
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/SQLite/"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.dbPath = [documentsDir stringByAppendingPathComponent:database];
        
        //		[self checkAndCreateDatabase:database];
		if(SQLITE_OK == sqlite3_open([self.dbPath UTF8String], &_dbHandler)) {
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

-(BOOL)execSql:(NSString *)sql Error:(NSError **)error
{
    dispatch_async(self.taskQueue, ^{
        char *err;
        int res=sqlite3_exec(self.dbHandler, [sql UTF8String], NULL, NULL, &err);
        if ( res!= SQLITE_OK) {
            if (error) {
                *error=[[NSError alloc] initWithDomain:[NSString stringWithUTF8String:err] code:res userInfo:nil];
            }
        }
     });
    return YES;
}

- (void)parseSql:(NSString *)sql call:(void(^)(SQLiteResult* res))result
{
    dispatch_async(self.taskQueue, ^{
        SQLiteResult *res = [self parseSql:sql];
        result(res);
    });
}

- (SQLiteResult* )parseSql:(NSString *)sql
{
    SQLiteResult* res = [[SQLiteResult alloc] init];
	sqlite3_stmt *compiledStatement;
	const char *sqlStatement = [[NSString stringWithString:sql] UTF8String];
	res.code= sqlite3_prepare_v2(self.dbHandler, sqlStatement, -1, &compiledStatement, NULL);
	if(SQLITE_OK != res.code) {
		res.msg = [NSString stringWithUTF8String:sqlite3_errmsg(self.dbHandler)];
		return res;
	}
    int resCount=sqlite3_data_count(compiledStatement);
    res.data=[[NSMutableArray alloc] initWithCapacity:resCount];
    BOOL run=YES;
    NSMutableArray *fields=[[NSMutableArray alloc] init];
    res.fileds=fields;
    int columnNum;
    while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
        if (run) {
            columnNum = sqlite3_column_count(compiledStatement);
            for (int i = 0; i < columnNum; i ++) {
                char *name=(char *)sqlite3_column_name(compiledStatement,i);
                [fields addObject:[NSString stringWithUTF8String:name]];
            }
            run=NO;
        }
        NSMutableDictionary *rowData = [[NSMutableDictionary alloc] initWithCapacity:columnNum];
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
	sqlite3_reset(compiledStatement);
	return res;
}

/**
 *  close db connect
 */
- (void)close
{
    sqlite3_close(_dbHandler);
    
}

@end
