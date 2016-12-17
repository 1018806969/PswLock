//
//  ViewController.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "ViewController.h"
#import "LockViewController.h"
#import "PswView.h"

@interface ViewController ()<LockViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 创建密码
 */
- (IBAction)CreateClick:(UIButton *)sender {
    
    [self type:TXLockOperationTypeCreate mininumCount:3];
}
/**
 验证密码
 */
- (IBAction)verifyClick:(id)sender {
    
    NSString *psw = [[NSUserDefaults standardUserDefaults]objectForKey:@"TXPswKey"];
    if (psw) {
        [self type:TXLockOperationTypeValidate mininumCount:3];
    }else
    {
        NSLog(@"你没有原始密码无法验证，请先创建密码");
    }
}
/**
 修改密码
 */
- (IBAction)changeClick:(UIButton *)sender {
    NSString *psw = [[NSUserDefaults standardUserDefaults]objectForKey:@"TXPswKey"];
    if (psw) {
        [self type:TXLockOperationTypeModify mininumCount:3];
    }else
    {
        NSLog(@"你没有原始密码无法修改，请先创建密码");
    }
}
/**
 删除密码
 */
- (IBAction)deleteClick:(id)sender {
    NSString *psw = [[NSUserDefaults standardUserDefaults]objectForKey:@"TXPswKey"];
    if (psw) {
        [self type:TXLockOperationTypeRemove mininumCount:3];
    }else
    {
        NSLog(@"你没有原始密码无法删除，请先创建密码");
    }
}
-(void)type:(TXLockOperationType)type mininumCount:(NSInteger)count
{
    LockViewController *lockVC = [[LockViewController alloc]init];
    lockVC.type = type;
    lockVC.mininumCount = count;
    lockVC.delegate = self ;
    
    [lockVC.lockView setLockButtonImage:[UIImage imageNamed:@"normal"] forState:TXLockButtonStateNormal];
    [lockVC.lockView setLockButtonImage:[UIImage imageNamed:@"error"] forState:TXLockButtonStateError];
    [lockVC.lockView setLockButtonImage:[UIImage imageNamed:@"selected"] forState:TXLockButtonStateSelected];
    
    [self presentViewController:lockVC animated:YES completion:nil];
}

/**
 输入密码
 */
-(IBAction)putInClick:(id)sender {
    PswView *pswView = [[PswView alloc]initWithNormalImg:nil selectedImg:[UIImage imageNamed:@"circle"] separateLineColor:[UIColor redColor] pswLength:6 finishHandler:^(PswView *pswView, NSString *psw) {
        [pswView hide];
        NSLog(@"-------------------%@",psw);
    }];
    [pswView show];
}

#pragma mark - **************** 对密码操作结果的处理 ****************

/**
 成功创建面貌的代理

 @param lockViewController lockViewController
 @param psw 创建的密码
 */
-(void)lockViewController:(LockViewController *)lockViewController didSuccessedCreatePsw:(NSString *)psw
{
    [lockViewController dismissViewControllerAnimated:YES completion:nil ];
}
/**
 验证密码结果的代理

 @param lockViewController lockviewController
 @param psw 输入的密码
 @param isSuccessful 是否验证成功
 */
-(void)lockViewController:(LockViewController *)lockViewController VerifyPsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful
{
    NSString *result = isSuccessful ? @"密码验证成功":@"密码验证失败";
    NSLog(@"%@",result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 修改密码结果的代理

 @param lockViewController lockviewController
 @param psw 修改的密码
 @param isSuccessful 是否修改成功
 */
-(void)lockViewController:(LockViewController *)lockViewController modifyPsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful
{
    NSString *result = isSuccessful ? @"密码修改成功":@"密码修改失败";
    NSLog(@"%@",result);
    if (isSuccessful) {
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 删除密码结果的代理

 @param lockViewController lockViewController
 @param psw 删除的密码
 @param isSuccessful 是否删除成功
 */
-(void)lockViewController:(LockViewController *)lockViewController removePsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful
{
    NSString *result = isSuccessful ? @"删除密码成功":@"删除密码失败";
    NSLog(@"%@",result);
    if (isSuccessful) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TXPswKey"];
        [lockViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
