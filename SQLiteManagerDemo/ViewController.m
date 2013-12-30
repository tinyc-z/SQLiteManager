//
//  ViewController.m
//  SQLiteHelperDemo
//
//  Created by iBcker on 13-6-26.
//  Copyright (c) 2013年 iBcker. All rights reserved.
//

#import "ViewController.h"
#import "SQLiteManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)onStart:(id)sender
{
    
    NSString *tbName=@"friends";
    
    SQLiteManager *mnger=[SQLiteManager connectdb:@"tab1.sqlite"];
    [mnger creatTab:tbName ifNotExists:@"ID INTEGER PRIMARY KEY AUTOINCREMENT",
                                        @"name TEXT",
                                        @"age INTEGER",
                                        @"address TEXT",nil];
    
    SQLiteCondition *cdt=[[SQLiteCondition alloc] initWitTabName:tbName];

    [cdt fields:@[@"name",@"age",@"address"]];
    
    //insert data
    [mnger add:@[@[@"xiaoming",@21,@"北海"],@[@"huazai",@20,@"深圳"],@[@"xiaoxiao",@13,@"广州"]] condition:cdt back:nil];

    //select
    [cdt clean];
    [mnger select:cdt back:^(SQLiteResult *res) {
        NSAssert(res.code==0, @"select error");
        NSLog(@"%@",res);
    }];
    
    //update
    [cdt clean];
    [cdt fields:@[@"name",@"age"]];
    [mnger update:@[@"shagua",@111] condition:cdt back:^(SQLiteResult *res) {
        NSAssert(res.code==0, @"update error");
        NSLog(@"%@",res);
    }];

    //delete
    [cdt clean];
    [cdt where:@"id = 3"];
    [mnger del:cdt back:^(SQLiteResult *res) {
        NSAssert(res.code==0, @"delete error");
        NSLog(@"%@",res);
    }];

    //select
    [cdt clean];
    [mnger select:cdt back:^(SQLiteResult *res) {
        NSAssert(res.code==0, @"select error");
        NSLog(@"%@",res);
    }];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
