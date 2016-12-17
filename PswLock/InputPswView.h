//
//  InputPswView.h
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPswView : UIView


/**
 *  初始化方法
 *
 *  @param normalImage    未输入密码的图片
 *  @param selectedImage  输入密码的图片
 *  @param Color      分割线的颜色
 *  @param Length 密码的位数
 *
 *  @return ZJPasswordInputView
 */
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage separateLineColor:(UIColor *)Color pswLength:(NSInteger)Length;
/**
 *  设置输入的密码的状态
 *
 *  @param currentPasswordLength 已经输入的密码位数
 */
- (void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength;

@end
