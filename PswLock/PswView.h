//
//  PswView.h
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//

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
