//
//  PswView.h
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//


/*
 
 点击输入密码，弹出的视图
 思路是:
 
 设置一个自定义的inputPswView覆盖在一个输入框上面，这样就可以使用输入框的代理方法
 inputPswView控件只是一种显示的假象，通过切换不同的图片标记是否输入了一位密码，真正的密码还是在输入框中，只不过被盖住了看不到而已。

 
 在初始化界面的时候就设置输入框为第一相应者，然后键盘就会弹出，然后布局界面。
 
 利用输入框的代理，当内容发生变化时，改变inputPswView覆盖图片的高亮状态，这样就可以让控件显示不同的图片
 
 利用输入框的代理，当密码长度满足要求时，截取预设密码长度的密码，然后回调输入完成的代码块
 
 
 经典：
    对内:通过方法- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength进行控制
    对外：通过初始化时候的一个回调代码块将结果传递出去
 */
#import <UIKit/UIKit.h>


@interface PswView : UIView

/**
 输入完成的block
 */
typedef void(^InputFinishHandler)(PswView *pswView,NSString *psw);


/**
 初始化方法

 @param normalImg 未输入密码的图片
 @param selectedImg 输入密码的图片
 @param color 分割线的颜色
 @param length 密码长度
 @param handler 回调函数
 @return PswView
 */
-(instancetype)initWithNormalImg:(UIImage *)normalImg selectedImg:(UIImage *)selectedImg separateLineColor:(UIColor *)color pswLength:(NSInteger)length finishHandler:(InputFinishHandler)handler;

/** 展示 */
- (void)show;
/** 移除 */
- (void)hide;

@end
