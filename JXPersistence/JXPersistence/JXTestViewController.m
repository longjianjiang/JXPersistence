//
//  JXTestViewController.m
//  JXPersistence
//
//  Created by zl on 2018/6/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXTestViewController.h"
#import "JXTestDataCenter.h"

@interface JXTestViewController ()
@property (nonatomic, strong) JXTestDataCenter *dataCenter;
@end

@implementation JXTestViewController

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
    
    JXTestRecord *threeRecord = [JXTestRecord new];
    threeRecord.book_id = @8;
    threeRecord.book_name = @"jiang";
    threeRecord.book_last_open_page = @9;
    
    [self.dataCenter insertOneRecord:newRecord];
    [self.dataCenter insertOneRecord:anotherRecord];
    [self.dataCenter insertOneRecord:threeRecord];
    
//    [self.dataCenter updateRecordWithBookId:@7 updatePageNumber:@12];
    //    [self.dataCenter deleteRecordWithBookId:@6];
    
    
//    NSLog(@"select jiang last page id %@", [self.dataCenter getLastPageIndexWithBookId:@7]);
    //    NSLog(@"book list is %@", [self.dataCenter getAllRecord]);
    //
    //    NSLog(@"book total count is %ld", (long)[self.dataCenter getRecordCount]);
    
    NSArray *bookList = [self.dataCenter getAllRecord];
    for (JXTestRecord *record in bookList) {
        NSLog(@"book name is %@, last open page is %@",record.book_name, record.book_last_open_page);
    }
}



#pragma mark - getter and setter
- (JXTestDataCenter *)dataCenter {
    if (_dataCenter == nil) {
        _dataCenter = [JXTestDataCenter new];
    }
    return _dataCenter;
}
@end
