//
//  SQLiteHelper.m
//  SQLiteHelper
//
//  Created by iBcker on 13-6-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "SQLiteManager.h"
#import "SQLiteDriver.h"


#define SQL_HELPER_CONNECT_COUNT 5


@interface SQLiteManager()
@property(nonatomic,retain)NSString *dbName;
@property(nonatomic,retain)NSMutableArray *dbConnectPool;

//测试发现，两条连接效率比较均衡，反而如果用容器来产生N条连接更耗时
@property(nonatomic,retain)SQLiteDriver *sqliter1;
@property(nonatomic,retain)SQLiteDriver *sqliter2;


@end

@implementation SQLiteManager

static NSMutableDictionary *dbMgrPool;


- (id)initWithDatabase:(NSString *)dbName
{
    self=[super init];
    if (self) {
        self.dbName=dbName;
        self.dbConnectPool=[[NSMutableArray alloc] initWithCapacity:2];
        self.sqliter1 = [[SQLiteDriver alloc] initWithDatabase:self.dbName];
        self.sqliter2 = [[SQLiteDriver alloc] initWithDatabase:self.dbName];
    }
    return self;
}


static NSString *mlobck=@"dbMgrMap";

+ (id)connetdb:(NSString *)dbName{
    @synchronized(self){
        if (!dbMgrPool) {
            dbMgrPool=[[NSMutableDictionary alloc] initWithCapacity:5];
        }
        id db=dbMgrPool[dbName];
        if (db){
            return db;
        }else{
            db = [[SQLiteManager alloc] initWithDatabase:dbName];
            @synchronized(mlobck){
                dbMgrPool[dbName]=db;
            }
            return db;
        }
    }
}

- (void)close:(NSString *)dbName
{
    if (dbMgrPool) {
        SQLiteManager *mgr=(id)dbMgrPool[dbName];
        [mgr.sqliter1 close];
        [mgr.sqliter2 close];
        @synchronized(mlobck){
            [dbMgrPool removeObjectForKey:dbName];
        }
    }
}



- (SQLiteDriver *)sqliter
{
    if (arc4random()%2==1) {
        return self.sqliter1;
    }else{
        return self.sqliter2;
    }
}


- (SQLiteManager *)addTask:(SQLiteCondition *)task back:(void(^)(id result))callBack
{
//    if (task.taskType==SQLiteTaskTypeWrite) {
//        [self.writeSqliter parseSql:@"" call:^(SQLiteResult *res) {
//            callBack(res);
//        }];
//    }else{
//        [self.readSqliter parseSql:@"" call:^(SQLiteResult *res) {
//            callBack(res);
//        }];
//    }
    return self;
}

- (void)select:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    [self.sqliter parseSql:cdt.selectSql call:^(SQLiteResult *res) {
        callBack(res);
    }];
}

//- (void)doit
//{
//
//    SQLiteDriver *d=[[SQLiteDriver alloc] initWithDatabase:@"tab1.sqlite" readOnly:NO];
//    [d execSql:@"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)" Error:nil];
////    [d execSql:@"INSERT INTO 'PERSONINFO' ('name', 'age', 'address') VALUES ('张三', '23', NULL)" Error:nil];
//
//    SQLiteResult *res2=[d parseSql:@"SELECT * FROM PERSONINFO"];
//
//}

@end
