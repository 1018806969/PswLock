//
//  LockView.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 绘制密码界面
 1.通过自定义手势的方式，绘制出一个密码，然后通过代理在手势结束的时候把绘制的结果传递出去到lockViewcontroller中。
 2.在lockViewcontroller中判断密码是否符合规定，
   如果绘制不符合规定就再传递回来错误信息，然后改变对应lockButton的状态，一段时间（如1s）之后再重置并回调到lockViewController中改变状态，
   如果绘制符合规定就通过代理将结果传递到其他页面如ViewController中去。
 
 
 经典：
     对内：通过改变lockButton的状态属性@property(nonatomic,assign)TXLockButtonState lockButtonState;改变展示不同的图片效果，
     对外：通过一个代理-(void)lockView:(LockView *)lockView didFinishCreatePsw:(NSString *)psw;将绘制结果传递出去。
 */
#import <UIKit/UIKit.h>
#import "LockButton.h"

@class LockView;

@protocol LockViewDelegate <NSObject>

/**
 绘制结束的协议----------将绘制的密码传递出去

 @param lockView lockView
 @param psw 绘制的密码
 */
-(void)lockView:(LockView *)lockView didFinishCreatePsw:(NSString *)psw;

@end

@interface LockView : UIView

@property(nonatomic,assign)id <LockViewDelegate> delegate;

/**
 距离，默认为20
 */
@property(nonatomic,assign)CGFloat margin;

/**
 lockButton的宽高，默认44.0f
 */
@property(nonatomic,assign)CGFloat w_h;

/**
 连接线的颜色，默认为red
 */
@property(nonatomic,strong)UIColor *lineColor;

/**
 链接线宽度，默认为2
 */
@property(nonatomic,assign)CGFloat lineWidth;

/**
 设置的密码，只读
 */
@property(nonatomic,strong,readonly)NSString *psw;


/**
 初始化方法
 */
-(instancetype)initWithDelegate:(id<LockViewDelegate>)delegate;

/**
 重置状态
 */
-(void)resetDrawing;

/**
 密码出现错误

 @param psw error psw
 @param time 显示时间
 @param handle 处理完成的回调
 */
-(void)errorPsw:(NSString *)psw time:(CGFloat)time finishHandle:(void(^)(LockView *lockView))handle;


/**
 设置不同状态下lockButton对应的图片

 @param image 图片
 @param state 状态
 */
-(void)setLockButtonImage:(UIImage *)image forState:(TXLockButtonState)state;
@end
