//
//  LockViewController.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

/*
 
  此控制器展示一切密码处理相关逻辑
 
 经典：
     对外：绘制成功，通过代理将结果传递出去
     对内：绘制失败，通过lockView的方法传递进去
 */

#import <UIKit/UIKit.h>
#import "LockView.h"

/**
 操作密码的类型，一直不变

 - TXLockOperationTypeCreate: 创建密码
 - TXLockOperationTypeValidate: 验证密码
 - TXLockOperationTypeModify: 修改密码
 - TXLockOperationTypeRemove: 删除密码
 */
typedef NS_ENUM(NSInteger, TXLockOperationType){
    
    TXLockOperationTypeCreate,
    TXLockOperationTypeValidate,
    TXLockOperationTypeModify,
    TXLockOperationTypeRemove
    
};

@class LockViewController;
@protocol LockViewControllerDelegate <NSObject>

@optional

/**
 创建密码成功
 */
-(void)lockViewController:(LockViewController *)lockViewController didSuccessedCreatePsw:(NSString *)psw;

/**
  验证密码
 */
- (void)lockViewController:(LockViewController *)lockViewController VerifyPsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful;
/**
 *  修改密码
 *  @param psw     修改后的密码
 *  @param isSuccessful 是否修改成功
 */
- (void)lockViewController:(LockViewController *)lockViewController modifyPsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful;
/**
 *  删除密码
 */
- (void)lockViewController:(LockViewController *)lockViewController removePsw:(NSString *)psw isSuccessful:(BOOL)isSuccessful;

@end

@interface LockViewController : UIViewController

/**
 操作类型，
 */
@property(nonatomic,assign)TXLockOperationType type;

/**
 最少要链接的密码位数
 */
@property(nonatomic,assign)NSInteger mininumCount;

/**
 显示当前状态
 */
@property(nonatomic,strong)UILabel *stateLabel;

/**
 绘制密码View
 */
@property(nonatomic,strong)LockView     *lockView;


@property(nonatomic,weak)id <LockViewControllerDelegate>delegate;

@end
