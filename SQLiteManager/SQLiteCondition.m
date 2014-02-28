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

@property(nonatomic,strong)NSString *where;
@property(nonatomic,strong)NSString *fields;
@property(nonatomic,strong)NSString *groupBy;
@property(nonatomic,strong)NSString *order;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger limit;

@end

@implementation SQLiteCondition

- (SQLiteCondition *)initWitTabName:(NSString *)name
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

- (SQLiteCondition *)descOrderBy:(NSString *)order
{
    return [self orderBy:[order stringByAppendingString:@" DESC"]];;
}

- (SQLiteCondition *)ascOrderBy:(NSString *)order
{
    return [self orderBy:order];;
}


- (SQLiteCondition *)fields:(id)fields
{
    if (!fields) {
        self.fields=nil;
    }else if ([fields isKindOfClass:[NSArray class]]) {
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

- (SQLiteCondition *)groupBy:(id)fields
{
    if (!fields) {
        self.groupBy=nil;
    }else if ([fields isKindOfClass:[NSArray class]]) {
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
            self.groupBy=fieldsStr;
        }
    }else if([fields isKindOfClass:[NSString class]]){
        self.groupBy=fields;
    }
    return self;
}

- (SQLiteCondition *)where:(id)condition
{
    if(!condition){
        self.where=nil;
    }else if ([condition isKindOfClass:[NSArray class]]) {
        
    }else if([condition isKindOfClass:[NSString class]]){
        self.where=condition;
    }
    return self;
}

- (NSString *)countSql
{
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"SELECT"];
    if ([_fields length]>0) {
        [sql appendFormat:@" %@,",self.fields];
    }
    
    [sql appendFormat:@" COUNT(*) FROM `%@`",self.tabName];
    if ([_where length]>0) {
        [sql appendFormat:@" WHERE %@",self.where];
    }
    
    if([_groupBy length]>0){
        [sql appendFormat:@" GROUP BY %@",self.groupBy];
    }
    
    if ([_order length]>0) {
        [sql appendFormat:@" ORDER BY %@",self.order];
    }
    
    if (_limit>0) {
        [sql appendFormat:@" LIMIT %d,%d",self.limit*self.page,self.limit*(self.page+1)];
    }
    return sql;
}

- (NSString *)selectSql
{
    NSMutableString *sql=[[NSMutableString alloc] initWithString:@"SELECT"];
    if ([_fields length]>0) {
        [sql appendFormat:@" %@",self.fields];
    }else{
        [sql appendString:@" *"];
    }

    [sql appendFormat:@" FROM `%@`",self.tabName];
    if ([_where length]>0) {
        [sql appendFormat:@" WHERE %@",self.where];
    }
    
    if([_groupBy length]>0){
        [sql appendFormat:@" GROUP BY %@",self.groupBy];
    }
    
    if ([_order length]>0) {
        [sql appendFormat:@" ORDER BY %@",self.order];
    }
    
    if (_limit>0) {
        [sql appendFormat:@" LIMIT %d,%d",self.limit*self.page,self.limit*(self.page+1)];
    }
    return sql;
}

- (NSString *)insertSql:(NSArray *)rows
{
    //NSERT INTO tbl_name (col1,col2) VALUES(col2*2,15);
    NSMutableString *sql=[[NSMutableString alloc] initWithFormat:@"INSERT INTO `%@`",self.tabName];
    
    if ([_fields length]>0) {
        [sql appendFormat:@"(%@)",self.fields];//keys and values
    }
    if ([rows isKindOfClass:[NSArray class]]&&[rows count]>0) {
        NSMutableString *valuesStr=[[NSMutableString alloc] init];
        
        if ([rows[0] isKindOfClass:[NSArray class]]) {
            int countj = [rows count];
            for (int i=0;i<countj;i++) {
                NSArray *vs=rows[i];
                [valuesStr appendString:@"("];
                int count = [vs count];
                for (int j=0;j<count;j++) {
                    if (count==j+1) {
                        [valuesStr appendString:[self getSqlValue:vs[j]]];
                    }else{
                        [valuesStr appendFormat:@"%@,",[self getSqlValue:vs[j]]];
                    }
                }
                if (i==countj-1) {
                    [valuesStr appendString:@")"];
                }else{
                    [valuesStr appendString:@"),"];
                }
                
            }
        }else{
            [valuesStr appendString:@"("];
            int count = [rows count];
            for (int i=0;i<count;i++) {
                if (count==i+1) {
                    [valuesStr appendString:[self getSqlValue:rows[i]]];
                }else{
                    [valuesStr appendFormat:@"%@,",[self getSqlValue:rows[i]]];
                }
            }
            [valuesStr appendString:@")"];
        }
        
        [sql appendFormat:@" values%@",valuesStr];//values
    }
    return sql;
}

- (NSString *)deleteSql
{
    NSMutableString *sql=[[NSMutableString alloc] initWithFormat:@"DELETE FROM `%@`",self.tabName];

    if ([_where length]>0) {
        [sql appendFormat:@" WHERE %@",self.where];
    }else{
        //为了防止误操作清空全表，加上如果没有条件就不执行的限制
        return @"";
    }

    if (_limit>0) {
        [sql appendFormat:@" LIMIT %d,%d",self.limit*self.page,self.limit*(self.page+1)];
    }

    return sql;
}

- (NSString *)updateSql:(NSArray *)values
{
    NSMutableString *sql=[[NSMutableString alloc] initWithFormat:@"UPDATE `%@` SET ",self.tabName];
    if (_fields) {
        NSArray *fiels=[self.fields componentsSeparatedByString:@","];
        int num = [fiels count]>[values count]?[values count]:[fiels count];
        for (int i=0;i<num;i++) {
            if (i==num-1) {
                [sql appendFormat:@"%@=%@",fiels[i],[self getSqlValue:values[i]]];
            }else{
                [sql appendFormat:@"%@=%@,",fiels[i],[self getSqlValue:values[i]]];
            }
        }
    }else{
        return @"";
    }
    
    if ([_where length]>0) {
        [sql appendFormat:@" WHERE %@",self.where];
    }else{
        //为了防止误操作修改全表，加上如果没有条件就不执行的限制
        return @"";
    }
    
    if (_limit>0) {
        [sql appendFormat:@" LIMIT %d,%d",self.limit*self.page,self.limit*(self.page+1)];
    }
    
    return sql;
}

- (NSString *)getSqlValue:(id)v
{
    if ([v isKindOfClass:[NSNumber class]]) {
        return [v description];
    }else{
        return [NSString stringWithFormat:@"'%@'",[v description]];
    }
}

- (void)clean
{
    self.where=nil;
    self.fields=nil;
    self.groupBy=nil;
    self.order=nil;
    self.page=0;
    self.limit=0;
}

@end
