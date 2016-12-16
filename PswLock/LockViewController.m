//
//  LockViewController.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"
typedef NS_ENUM(NSInteger,TXLockViewControllerCurrentState)
{
    TXLockViewControllerCurrentStateCreate,//创建密码
    TXLockViewControllerCurrentStateVerify,//确认密码
    TXLockViewControllerCurrentStateValidate//验证密码
};

@interface LockViewController ()<LockViewDelegate>

@property(nonatomic,strong)UIButton     *backButton;
@property(nonatomic,strong)LockView     *lockView;

/**
 发生错误
 */
@property(nonatomic,assign)BOOL          occurError;

/**
 临时密码，比如第一次输入密码，还需要验证
 */
@property(nonatomic,strong)NSString     *tmpPsw;

/**
 当前操作的类型
 */
@property(nonatomic,assign)TXLockViewControllerCurrentState currentState;
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.stateLabel];
    
    
}
-(void)lockView:(LockView *)lockView didFinishCreatePsw:(NSString *)psw
{
    if (self.type == TXLockOperationTypeCreate) {
        [self createPsw:psw lockView:lockView];
    }
}
-(void)createPsw:(NSString *)psw lockView:(LockView *)lockView
{
    NSLog(@"--------%ld-------%ld",(long)self.type,psw.length);
    if (self.type == TXLockViewControllerCurrentStateCreate) {
        if (psw.length < self.mininumCount) {
            self.stateLabel.text = [NSString stringWithFormat:@"链接的密码数少于%ld个",(long)_mininumCount];
            self.occurError = YES ;
            __weak typeof(self) weakSelf = self ;
            [lockView errorPsw:psw time:1.0f finishHandle:^(LockView *lockView) {
                weakSelf.stateLabel.text = @"请绘制密码";
                weakSelf.occurError = NO ;
            }];
        }else
        {
            //暂时的密码 ------未写入本地
            _tmpPsw = psw ;
            
            //清楚绘制的密码
            [lockView resetDrawing];
            
            //更改操作步骤为确认密码
            self.stateLabel.text = @"请再次确认密码";
            self.currentState = TXLockViewControllerCurrentStateVerify;
        }
    }else if(self.currentState == TXLockViewControllerCurrentStateVerify)
    {
#pragma mark ---------------end---------start--------------
    }
}
-(void)setOccurError:(BOOL)occurError
{
    _occurError = occurError;
    self.stateLabel.textColor = _occurError ? [UIColor redColor] :[UIColor blackColor];
}
- (void)setType:(TXLockOperationType)type{
    _type = type;
    if (type == TXLockOperationTypeModify) {
        self.stateLabel.text = @"输入旧密码";
        self.currentState = TXLockViewControllerCurrentStateValidate;
    }
    else if (type == TXLockOperationTypeVerify) {
        self.stateLabel.text = @"输入密码";
        self.currentState = TXLockViewControllerCurrentStateVerify;
    }
    else if (type == TXLockOperationTypeRemove) {
        self.stateLabel.text = @"输入旧密码";
        self.currentState = TXLockViewControllerCurrentStateValidate;
    }
    else {
        self.stateLabel.text = @"输入初始密码";
        self.currentState = TXLockViewControllerCurrentStateCreate;
        
    }
}

-(LockView *)lockView
{
    if (!_lockView) {
        _lockView = [[LockView alloc]initWithDelegate:self];
        _lockView.bounds = CGRectMake(0, 0, 300, 300);
        _lockView.center = self.view.center ;
        _lockView.backgroundColor = [UIColor whiteColor];
    }
    return _lockView ;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.center = CGPointMake(self.view.center.x, 100);
        _stateLabel.bounds = CGRectMake(0, 0, 300, 40);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.text = @"请输入密码";
        _stateLabel.textColor = [UIColor blackColor];
    }
    return _stateLabel;
}

-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 20, 80, 40);
        [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        [_backButton setTitle:@"<" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton ;
}
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
