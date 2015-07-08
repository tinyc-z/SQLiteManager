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

//测试发现，两条连接效率比较均衡，反而如果用容器来产生N条连接更耗时
@property(nonatomic,retain)SQLiteDriver *sqliter1;
@property(nonatomic,retain)SQLiteDriver *sqliter2;


@end

@implementation SQLiteManager

static NSMutableDictionary *dbMgrPool;


- (id)initWithDatabaseFile:(NSString *)dbPath
{
    self=[super init];
    if (self) {
        _dbPath=dbPath;
        
        NSString *documentsDir = [dbPath stringByDeletingLastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        self.sqliter1 = [[SQLiteDriver alloc] initWithDbPathPath:self.dbPath];
        
    }
    return self;
}

-(SQLiteDriver *)sqliter2
{
    if (!_sqliter2) {
        @synchronized(self) {
            if (!_sqliter2) {
                _sqliter2 = [[SQLiteDriver alloc] initWithDbPathPath:self.dbPath];
            }
        }
    }
    return _sqliter2;
}

static NSString *mlobck=@"dbMgrMap";

+ (id)connectdb:(NSString *)dbName{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbMgrPool=[[NSMutableDictionary alloc] initWithCapacity:5];
    });
    
    @synchronized(mlobck){
        id db=dbMgrPool[dbName];
        if (db){
            return db;
        }else{
            db = [[SQLiteManager alloc] initWithDatabaseFile:dbName];
            dbMgrPool[dbName]=db;
            return db;
        }
    }
}

- (void)close:(NSString *)dbName
{
    if (dbMgrPool) {
        @synchronized(mlobck){
            SQLiteManager *mgr=(id)dbMgrPool[dbName];
            [mgr.sqliter1 close];
            [mgr->_sqliter2 close];
            [dbMgrPool removeObjectForKey:dbName];
        }
    }
}

- (SQLiteDriver *)sqliter
{
    if (!self.sqliter1.isRunning) {
        return self.sqliter1;
    }else if(!self.sqliter2.isRunning){
        return self.sqliter2;
    }else{
        if (arc4random()%2==1) {
            return self.sqliter1;
        }else{
            return self.sqliter2;
        }
    }
}

- (BOOL)creatTab:(NSString *)tabName ifNotExists:(NSString *)fields,...
{
    NSMutableString *tfields=[[NSMutableString alloc] initWithFormat:@"%@",fields];
    va_list argList;
    va_start(argList,fields);
    NSString *arg;
    while ((arg=va_arg(argList, NSString *))) {
        [tfields appendFormat:@",%@",arg];
    }
    va_end(argList);
    NSString *sql=[[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",tabName,tfields];
    SQLiteResult *res = [self.sqliter execSql:sql];
    return res.code==0;
}

- (void)execute:(NSString *)sql back:(void(^)(SQLiteResult *res))callBack
{
    [self.sqliter execSql:sql call:callBack];
}

- (void)select:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    [self execute:cdt.selectSql back:callBack];
}

- (void)count:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    [self execute:cdt.countSql back:callBack];
}

- (void)add:(NSArray *)rows condition:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    NSString *sql=[cdt insertSql:rows];
    [self execute:sql back:callBack];
}

- (void)del:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    [self execute:cdt.deleteSql back:callBack];
}


- (void)update:(NSArray *)values condition:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack
{
    NSString *sql=[cdt updateSql:values];
    [self execute:sql back:callBack];
}

@end
