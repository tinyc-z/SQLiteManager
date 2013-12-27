//
//  SQLiteResult.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-12-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "SQLiteResult.h"

@implementation SQLiteResult

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSDictionary*)objectAtIndex:(NSUInteger)index
{
    return self.data[index];
}

- (NSInteger)count
{
    return [self.data count];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"code:%d\nmsg:%@\nsql:%@\ndata:%@",self.code,self.msg,self.sql,[self.data description]];
}

@end
