//
//  PswView.m
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "PswView.h"
#import "InputPswView.h"

@interface PswView()<UITextFieldDelegate>

@property(nonatomic,assign)CGFloat keyBoardHeight;

@property(nonatomic,copy)InputFinishHandler inputFinishHandle;

@property(nonatomic,strong)UIImage *normalImg;

@property(nonatomic,strong)UIImage *selectedImg ;

@property(nonatomic,strong)UIColor *separateLineColor;

@property(nonatomic,assign)NSInteger pswLength;

@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;

@property(nonatomic,strong)UITextField *pswTf;

@property(nonatomic,strong)InputPswView *pswInputView;

@end

@implementation PswView
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
-(instancetype)initWithNormalImg:(UIImage *)normalImg selectedImg:(UIImage *)selectedImg separateLineColor:(UIColor *)color pswLength:(NSInteger)length finishHandler:(InputFinishHandler)handler
{
    self = [super init];
    if (self) {
        _normalImg = normalImg ;
        _selectedImg = selectedImg ;
        _pswLength = length;
        _separateLineColor = color ;
        self.inputFinishHandle = [handler copy];
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6f];
        [self addSubview:self.pswTf];
        [self addSubview:self.pswInputView];
        [self addGestureRecognizer:self.tapGesture];
        [self.pswTf becomeFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self ;
}
-(void)keyboardWillShow:(NSNotification *)notif
{
    CGRect keyBoardBounds = [notif.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyBoardHeight = keyBoardBounds.size.height ;
    
    [self setNeedsLayout];
}
-(void)textFieldValueDidChanged:(UITextField *)tf
{
    NSString *text = tf.text ;
    
    //设置已经输入的密码位数----调整状态
    [self.pswInputView setupBtnWithCurrentPasswordLength:text.length];
    
    //输入完整位数，调用handler
    
    if (text.length >= _pswLength) {
        // 延时0.1 为了让上面设置的显示输入密码的图片切换完成在调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_inputFinishHandle) {
                self.inputFinishHandle(self, text);
            }
        });
    }
}
// 是否要改变文本
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= _pswLength) {
        // 限制密码输入位
        return NO;
    }
    return YES;
}
-(void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    [self hide];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.superview) {
        //已经被添加到Window上就设置frame
        self.frame = self.superview.bounds;//这样就可以设配旋转
        
        CGFloat y = self.bounds.size.height - _keyBoardHeight - 44;
        self.pswTf.frame = CGRectMake(0, y, self.bounds.size.width, 44);
        self.pswInputView.frame = self.pswTf.frame ;
    }
}
-(UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHandle:)];
    }
    return _tapGesture ;
}
-(InputPswView *)pswInputView
{
    if (!_pswInputView) {
        _pswInputView = [[InputPswView alloc]initWithNormalImage:_normalImg selectedImage:_selectedImg separateLineColor:_separateLineColor pswLength:_pswLength];
    }
    return _pswInputView ;
}
-(UITextField *)pswTf
{
    if (!_pswTf) {
        _pswTf = [[UITextField alloc]init];
        _pswTf.secureTextEntry = YES ;
        _pswTf.keyboardType = UIKeyboardTypeNumberPad;
        _pswTf.delegate = self ;
        
        [_pswTf addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pswTf ;
}
-(void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}
-(void)hide
{
    [self removeFromSuperview];
}
@end
