//
//  LockViewController.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXLockOperationType){
    
    TXLockOperationTypeCreate,
    TXLockOperationTypeVerify,
    TXLockOperationTypeModify,
    TXLockOperationTypeRemove
    
};



@interface LockViewController : UIViewController

/**
 操作类型
 */
@property(nonatomic,assign)TXLockOperationType type;

/**
 最少要链接的密码位数
 */
@property(nonatomic,assign)NSInteger mininumCount;

@property(nonatomic,strong)UILabel *stateLabel;

@end
