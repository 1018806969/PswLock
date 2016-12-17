//
//  LockViewController.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "LockViewController.h"

static NSString *const TXPswKey = @"TXPswKey";

typedef NS_ENUM(NSInteger,TXLockViewControllerCurrentState)
{
    TXLockViewControllerCurrentStateCreate,//创建密码
    TXLockViewControllerCurrentStateCreateEnsure,//确认密码
    TXLockViewControllerCurrentStateValidate //验证密码
};

@interface LockViewController ()<LockViewDelegate>

@property(nonatomic,strong)UIButton     *backButton;

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
    if (self.type == TXLockOperationTypeCreate)
    {
        [self createPsw:psw lockView:lockView];
    }else if (self.type == TXLockOperationTypeValidate)
    {
        [self verifyPsw:psw lockView:lockView];
    }else if (self.type == TXLockOperationTypeModify)
    {
        [self modifyPsw:psw LockView:lockView];
    }else
    {
        [self removePsw:psw lockView:lockView];
    }
}
-(void)createPsw:(NSString *)psw lockView:(LockView *)lockView
{
    NSLog(@"--------%ld-------%ld",(long)self.type,psw.length);
    if (self.currentState == TXLockViewControllerCurrentStateCreate) {
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
            
            //清除绘制的密码
            [lockView resetDrawing];
            
            //更改操作步骤为确认密码
            self.stateLabel.text = @"请再次确认密码";
            self.currentState = TXLockViewControllerCurrentStateCreateEnsure;
        }
    }else if(self.currentState == TXLockViewControllerCurrentStateCreateEnsure)
    {
        if ([psw isEqualToString:_tmpPsw]) {
            
            [lockView resetDrawing];
            [LockViewController savePsw:psw];
            
            if (self.type == TXLockOperationTypeCreate) {
                self.stateLabel.text = @"密码创建成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:didSuccessedCreatePsw:)]) {
                    [_delegate lockViewController:self didSuccessedCreatePsw:psw];
                }
            }else if (self.type == TXLockOperationTypeModify)
            {
                self.stateLabel.text = @"修改密码成功";
                if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPsw:isSuccessful:)]) {
                    [_delegate lockViewController:self modifyPsw:psw isSuccessful:YES];
                }
            }
        }else
        {
            self.stateLabel.text = @"两次绘制密码不相同，创建失败";
            self.occurError = YES ;
            __weak typeof(self) weakself = self ;
            [lockView errorPsw:psw time:1 finishHandle:^(LockView *lockView) {
                if (weakself.type == TXLockOperationTypeModify || weakself.type == TXLockOperationTypeCreate) {
                    weakself.stateLabel.text = @"请重新绘制密码";
                }
                weakself.occurError = NO;
            }];
            self.currentState = TXLockViewControllerCurrentStateCreate;
        }
    }
}
-(void)verifyPsw:(NSString *)psw lockView:(LockView *)lockView
{
    self.stateLabel.text = @"请绘制旧密码";
    NSString *originPsw = [[NSUserDefaults standardUserDefaults]objectForKey:TXPswKey];
    if ([psw isEqualToString:originPsw]) {//正确
        [lockView resetDrawing];
        if (self.type == TXLockOperationTypeValidate) {
            self.stateLabel.text = @"密码验证正确";
            if (_delegate &&[_delegate respondsToSelector:@selector(lockViewController:VerifyPsw:isSuccessful:)]) {
                [_delegate lockViewController:self VerifyPsw:psw isSuccessful:YES];
            }
        }else if (self.type == TXLockOperationTypeModify)
        {
            self.stateLabel.text = @"请绘制新的密码";
            self.currentState = TXLockViewControllerCurrentStateCreate;
        }else if (self.type == TXLockOperationTypeRemove)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePsw:isSuccessful:)]) {
                [_delegate lockViewController:self removePsw:psw isSuccessful:YES];
            }
        }
    }else //错误
    {
        self.stateLabel.text = @"绘制密码错误";
        self.occurError = YES ;
        __weak typeof(self) weakSelf = self ;
        [lockView errorPsw:psw time:1 finishHandle:^(LockView *lockView) {
            weakSelf.stateLabel.text = @"请重新绘制密码";
            weakSelf.occurError = NO;
        }];
        
        if (self.type == TXLockOperationTypeValidate) {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:VerifyPsw:isSuccessful:)]) {
                [_delegate lockViewController:self VerifyPsw:psw isSuccessful:NO];
            }
        }else if (self.type == TXLockOperationTypeRemove)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:removePsw:isSuccessful:)]) {
                [_delegate lockViewController:self removePsw:psw isSuccessful:NO];
            }
        }else if (self.type == TXLockOperationTypeModify)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(lockViewController:modifyPsw:isSuccessful:)]) {
                [_delegate lockViewController:self modifyPsw:psw isSuccessful:NO];
            }
        }
    }
}
-(void)modifyPsw:(NSString *)psw LockView:(LockView *)lockView
{
    if (self.currentState == TXLockViewControllerCurrentStateValidate) {
         //验证旧密码
        [self verifyPsw:psw lockView:lockView];
    }else
    {
        //创建新密码
        [self createPsw:psw lockView:lockView];
    }
}
-(void)removePsw:(NSString *)psw lockView:(LockView *)lockView
{
    [self verifyPsw:psw lockView:lockView];
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
    else if (type == TXLockOperationTypeValidate) {
        self.stateLabel.text = @"输入密码";
        self.currentState = TXLockViewControllerCurrentStateValidate;
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
+(void)savePsw:(NSString *)psw
{
    [[NSUserDefaults standardUserDefaults]setValue:psw forKey:TXPswKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
