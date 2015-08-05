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
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/WOWSQLite/"];
    NSString *dbpath=[documentsDir stringByAppendingPathComponent:@"tab1.sqlite"];

    SQLiteManager *mnger=[SQLiteManager connectdb:dbpath];
    BOOL succ = [mnger creatTab:tbName ifNotExists:@"id INTEGER PRIMARY KEY AUTOINCREMENT",
                                        @"name TEXT",
                                        @"age INTEGER",
                                        @"address TEXT",nil];
    if (succ) {
        //    for (NSInteger i=0;i<1000;i++) {
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SQLiteCondition *cdt=[[SQLiteCondition alloc] initWitTabName:tbName];
        
//        [cdt fields:@[@"name",@"age",@"address"]];
//        
//        //insert data
//        [mnger add:@[@[@"xiaoming",@21,@"北海"],@[@"huazai",@20,@"深圳"],@[@"xiaoxiao",@13,@"广州"]] condition:cdt back:nil];
//        //
//        //    //select
//        [cdt clean];
//        [mnger select:cdt back:^(SQLiteResult *res) {
//            NSAssert(res.code==0, @"select error");
//            NSLog(@"%@",res);
//        }];
//        
//        //update
//        [cdt clean];
//        [cdt fields:@[@"name",@"age"]];
//        [cdt where:@"id > 1"];
//        [mnger update:@[@"shagua",[NSNull null]] condition:cdt back:^(SQLiteResult *res) {
//            NSAssert(res.code==0, @"update error");
//            NSLog(@"%@",res);
//        }];
//        
//        //delete
//        [cdt clean];
        [cdt where:@"id = 4"];
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
        
        //        });
        //    }
    }
    
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
