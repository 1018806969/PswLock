//
//  LockView.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockButton.h"
@class LockView;

@protocol LockViewDelegate <NSObject>

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


-(void)setLockButtonImage:(UIImage *)image forState:(TXLockButtonState)state;
@end
