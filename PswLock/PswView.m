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

/**
 键盘弹出监听到的键盘高度
 */
@property(nonatomic,assign)CGFloat keyBoardHeight;

/**
 密码输入长度达到预设长度时，调用block
 */
@property(nonatomic,copy)InputFinishHandler inputFinishHandle;

/**
 没有输入密码的imageView控件的Image
 */
@property(nonatomic,strong)UIImage *normalImg;

/**
 输入密码的imageView控件的Image，这里是一个黑点
 */
@property(nonatomic,strong)UIImage *selectedImg ;

/**
 分割线的颜色
 */
@property(nonatomic,strong)UIColor *separateLineColor;

/**
 密码长度
 */
@property(nonatomic,assign)NSInteger pswLength;

@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;

/**
 被覆盖的输入框
 */
@property(nonatomic,strong)UITextField *pswTf;

/**
 自定义的密码输入视图
 */
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
/**
 键盘弹出监听事件----获取键盘高度
 */
-(void)keyboardWillShow:(NSNotification *)notif
{
    CGRect keyBoardBounds = [notif.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    _keyBoardHeight = keyBoardBounds.size.height ;
    
    [self setNeedsLayout];
}
/**
 输入框代理 -----当输入框内容变化时，调整inputView的图片显示，并当输入长度符合设定长度时回调
 */
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
/**
 输入框代理-----当输入框内容长度大于设定位数时，只取设定位数长度,同时避免多次调用textFieldValueDidChanged:这个代理方法，也就是避免对此回调
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= _pswLength) {
        // 限制密码输入位
        return NO;
    }
    return YES;
}
/**
 点击手势---------点击self，销毁pswView
 */
-(void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    [self hide];
}
/**
 布局subViews-----当键盘弹出时，根据键盘高度布局
 */
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
        
        /**
         输入框内容改变时处理响应，这个可以监听UITextFieldTextDidChangeNotification实现
         两者存在不同
         如果利用通知监听，当输入一个中文时会多次触发通知绑定的方法，代理只会一次
         不过在这里不会有影响，因为输入的密码都是数字，不存在中文字符。
         */
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
