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
//    SQLiteManager *mnger=[SQLiteManager connetdb:@"tab1.sqlite"];
//    [mnger doit];
    
//    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
    
    
//    [mnger creatTab:@"PERSONINFO" ifNotExists:
//                                        @"ID INTEGER PRIMARY KEY AUTOINCREMENT",
//                                        @"name TEXT",
//                                        @"age INTEGER",
//                                        @"address TEXT",nil];
    
//    mnger.tabName=@"PERSONINFO";
//    
//    SQLiteResult *res=[[[[[mnger where:@"ID>5"] limit:3] page:2] fields:@[@"ID",@"name"]] select];
    
    CFTimeInterval start= CFAbsoluteTimeGetCurrent();
    SQLiteManager *mnger=[SQLiteManager connetdb:@"tab1.sqlite"];
    SQLiteCondition *cdt=[[SQLiteCondition alloc] initWitTab:@"PERSONINFO"];
    [cdt where:@"age=23"];
    [cdt orderBy:@"id"];
    
    for (int i=0;i<10000;i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [mnger select:cdt back:^(SQLiteResult *res) {
                NSLog(@"%f",CFAbsoluteTimeGetCurrent()-start);
            }];
            
        });
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
