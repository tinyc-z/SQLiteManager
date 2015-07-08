//
//  SQLiteResult.h
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteResult : NSObject

@property (nonatomic, assign)NSInteger code;
@property (nonatomic, strong)NSString *msg;
@property (nonatomic, strong)NSString *sql;

@property (nonatomic, strong)NSMutableArray* data;
@property (nonatomic, strong)NSMutableArray* fileds;

- (NSDictionary*)objectAtIndex:(NSUInteger)index;
- (NSInteger)count;

@end
