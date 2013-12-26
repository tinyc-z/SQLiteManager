//
//  SQLiteTask.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "SQLiteCondition.h"

@interface SQLiteCondition()
@property(nonatomic,strong)NSString *tabName;

@property(nonatomic,retain)NSString *where;
@property(nonatomic,retain)NSString *fields;
@property(nonatomic,retain)NSString *order;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger limit;

@end

@implementation SQLiteCondition

- (SQLiteCondition *)creatTab:(NSString *)tabName ifNotExists:(NSString *)fields,...
{
    self.tabName=tabName;
    NSMutableString *tfields=[[NSMutableString alloc] initWithFormat:@"%@",fields];
    va_list argList;
    va_start(argList,fields);
    NSString *arg;
    while ((arg=va_arg(argList, NSString *))) {
        [tfields appendFormat:@",%@",arg];
    }
    va_end(argList);
    NSString *sql=[[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",tabName,tfields];
//    [self.sqliter execSql:sql Error:nil];
    return self;
}

- (SQLiteCondition *)initWitTab:(NSString *)name
{
    if(self=[super init]){
         self.tabName=name;
    }
    return self;
}


- (SQLiteCondition *)limit:(NSInteger)count
{
    self.limit=count;
    return self;
}

-(SQLiteCondition *)page:(NSInteger)page
{
    self.page=page;
    return self;
}

- (SQLiteCondition *)orderBy:(NSString *)order
{
    self.order=order;
    return self;
}

- (SQLiteCondition *)fields:(id)fields
{
    if ([fields isKindOfClass:[NSArray class]]) {
        int count=[fields count];
        NSMutableString *fieldsStr=[[NSMutableString alloc] initWithCapacity:count];
        for (int i=0;i<count;i++) {
            if (i==count-1) {
                [fieldsStr appendFormat:@"%@",fields[i]];
            }else{
                [fieldsStr appendFormat:@"%@,",fields[i]];
            }
        }
        if (fieldsStr.length>0) {
            self.fields=fieldsStr;
        }
    }else if([fields isKindOfClass:[NSString class]]){
        self.fields=fields;
    }
    return self;
}

- (SQLiteCondition *)where:(id)condition
{
    if ([condition isKindOfClass:[NSArray class]]) {
        
    }else if([condition isKindOfClass:[NSString class]]){
        self.where=condition;
    }
    return self;
}

- (NSInteger)count
{

}

- (NSString *)selectSql
{
    //    SELECT * FROM PERSONINFO
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"SELECT"];
    if (self.fields) {
        [sql appendFormat:@" %@",self.fields];
    }else{
        [sql appendString:@" *"];
    }

    [sql appendFormat:@" FROM %@",self.tabName];
    if (self.where) {
        [sql appendFormat:@" WHERE %@",self.where];
    }
    
    if (self.limit) {
        [sql appendFormat:@" LIMIT %d,%d",self.limit*self.page,self.limit*(self.page+1)];
    }
    return sql;
}



- (SQLiteResult *)find
{

}

- (NSInteger)update:(NSDictionary *)data
{

}

- (NSInteger)save:(NSDictionary *)data
{

}
@end
