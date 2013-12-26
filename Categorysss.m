//
//  NSObject+Objects_All.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-7-4.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "Categorysss.h"

@implementation NSArray(description)
//打印中文
-(NSString*)description
{
    NSMutableString *strs=[[NSMutableString alloc] initWithString:@"(\n"];
    for (id obj in self) {
        [strs appendFormat:@"%@,\n",[obj description]];
    }
    [strs appendString:@")"];
    return strs;
}
@end

@implementation NSDictionary(description)
//打印中文
-(NSString*)description
{
    NSMutableString *strs=[[NSMutableString alloc] initWithString:@"{\n"];
    NSArray *keys=[self allKeys];
    for (id key in keys) {
        id obj=[self objectForKey:key];
        [strs appendFormat:@"   %@ = %@ ;\n",key,[obj description]];
    }
    [strs appendString:@"}"];
    return strs;
}
@end
