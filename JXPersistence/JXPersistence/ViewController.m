//
//  ViewController.m
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"
#import "JXTestDataCenter.h"

@interface ViewController ()
@property (nonatomic, strong) JXTestDataCenter *dataCenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"database path is %@",path);
    
    
    JXTestRecord *newRecord = [JXTestRecord new];
    newRecord.book_id = @7;
    newRecord.book_name = @"nancy";
    newRecord.book_last_open_page = @2;
    
    JXTestRecord *anotherRecord = [JXTestRecord new];
    anotherRecord.book_id = @6;
    anotherRecord.book_name = @"jx";
    anotherRecord.book_last_open_page = @8;

//    [self.dataCenter insertOneRecord:newRecord];
//    [self.dataCenter insertOneRecord:anotherRecord];
    
//    [self.dataCenter updateRecordWithBookId:@7 updatePageNumber:@12];
//    [self.dataCenter deleteRecordWithBookId:@6];
    
    
    NSLog(@"select jiang last page id %@", [self.dataCenter getLastPageIndexWithBookId:@7]);
//    NSLog(@"book list is %@", [self.dataCenter getAllRecord]);
    
//    NSLog(@"book total count is %ld", (long)[self.dataCenter getRecordCount]);
    
    
    

}


#pragma mark - getter and setter
- (JXTestDataCenter *)dataCenter {
    if (_dataCenter == nil) {
        _dataCenter = [JXTestDataCenter new];
    }
    return _dataCenter;
}

@end
