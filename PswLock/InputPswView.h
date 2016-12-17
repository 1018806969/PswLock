//
//  InputPswView.h
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 
 密码输入区
 
 此控件只是一种显示的假象，通过切换不同的图片标记是否输入了一位密码，真正的密码还是在输入框中，只不过被盖住了看不到而已。
 
 
 经典：
    通过方法- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength改变自己的显示方式

  

 */

#import <UIKit/UIKit.h>


@interface InputPswView : UIView


/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param color      分割线的颜色
 *  @param Length 密码的位数
 *
 *  @return ZJPasswordInputView
 */
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage separateLineColor:(UIColor *)color pswLength:(NSInteger)Length;
/**
 *  设置输入的密码的状态
 *
 *  @param currentPasswordLength 已经输入的密码位数
 */
- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength;

@end
