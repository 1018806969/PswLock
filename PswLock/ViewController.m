//
//  ViewController.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"
#import "LockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)CreateClick:(UIButton *)sender {
    LockViewController *lockVC = [[LockViewController alloc]init];
    lockVC.type = TXLockOperationTypeCreate;
    lockVC.mininumCount = 3;
    [self presentViewController:lockVC animated:YES completion:nil];
}
- (IBAction)verifyClick:(id)sender {
    
}
- (IBAction)changeClick:(UIButton *)sender {
    
}
- (IBAction)deleteClick:(id)sender {
    
}
- (IBAction)putInClick:(id)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
