//
//  ViewController.m
//  JXPersistence
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    NSSet *set = [NSSet setWithObjects:@2, @5, @7, @10, nil];
    NSSet *result = [set objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
        *stop = YES;
        return *stop;
    }];

    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"item is %@",obj);
    }];
    NSLog(@"%@", result);
}



@end
