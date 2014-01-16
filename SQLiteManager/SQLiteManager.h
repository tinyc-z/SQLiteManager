//
//  SQLiteHelper.h
//  SQLiteHelper
//
//  Created by iBcker on 13-6-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteResult.h"
#import "SQLiteCondition.h"
#import "SQLiteDriver.h"


@interface SQLiteManager : NSObject

@property(nonatomic,retain)NSString *dbPath;
@property(nonatomic,retain)NSString *dbName;

/**
 *  创建数据库连接
 *      1)先从管理池中寻找有无已经创建了的，如果有直接返回，如果没有建立一个新的
 *      2)结束操作后不会自动释放，如有必要请手动关闭
 *
 *  @param dbName 数据库名称
 *
 *  @return 数据库管理对象
 */
+ (id)connectdb:(NSString *)dbName;


/**
 *  数据库关闭操作
 *  1)从管理池里面寻找，如果存在则销毁
 *
 *  @param dbName 数据库名称
 */
- (void)close:(NSString *)dbName;




/**
 *  如果表不存在，创建
 *
 *  @param name   表名
 *  @param fields 字段属性
 *                  eg. @"ID INTEGER PRIMARY KEY AUTOINCREMENT",
 *                      @"name TEXT",
 *                      @"age INTEGER",
 *                      @"address TEXT",nil
 *
 */
- (void)creatTab:(NSString *)name ifNotExists:(NSString *)fields,...;


/**
 *  执行sql语句
 *
 *  @param sql      sql
 *  @param callBack  执行结果
 */
- (void)execute:(NSString *)sql back:(void(^)(SQLiteResult *res))callBack;


/**
 *  查询操作
 *
 *  @param cdt      查询条件，指定表名字段条件等
 *  @param callBack 执行结果
 */
- (void)select:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;


/**
 *  统计操作
 *
 *  @param cdt      查询条件，指定表名字段条件等
 *  @param callBack 执行结果
 */
- (void)count:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;


/**
 *  添加数据
 *
 *  @param rows     指数组，需要和cdt中字段一一对应，可以位以为数据组也可以位二维数组
 *                  eg. @[@1,@"luxi"] or @[@[@1,@"luxi"],@[@2,@"lili"]]
 *
 *  @param cdt      条件,指定需要插入数据的表名和字段
 *
 *  @param callBack 执行结果
 */
- (void)add:(NSArray *)rows condition:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;


/**
 *  删除操作
 *
 *  @param cdt      条件,指定删除条件等
 *                  ps:为了防止误操作清空整个表，此方法必须包含where条件，不然无法执行
 *
 *  @param callBack 执行结果
 */
- (void)del:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;


/**
 *  更新数据库
 *
 *  @param values   键值对应值数组
 *                  eg. @[@"xiaoming",@(18)]
 *
 *  @param cdt      条件,指定删除条件等
 *                  ps:为了防止误操作清空整个表，此方法必须包含where条件，不然无法执行
 *
 *  @param callBack 执行结果
 */
- (void)update:(NSArray *)values condition:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;

@end


