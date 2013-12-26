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
@interface SQLiteManager : NSObject

@property(nonatomic,retain)NSString *tabName;

- (void)doit;

+ (id)connetdb:(NSString *)dbName;

- (void)close:(NSString *)dbName;

- (SQLiteManager *)addTask:(SQLiteCondition *)cdt back:(void(^)(id result))callBack;


- (void)select:(SQLiteCondition *)cdt back:(void(^)(SQLiteResult *res))callBack;


- (void)count:(SQLiteCondition *)cdt back:(void(^)(NSUInteger count,NSError *err))callBack;

//- (SQLiteManager *)update:(SQLiteCondition *)cdt back:(void(^)(NSUInteger count,NSError *err))callBack;

- (NSInteger)update:(NSDictionary *)data;
- (NSInteger)save:(NSDictionary *)data;
@end


