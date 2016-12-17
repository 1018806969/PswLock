//
//  LockButton.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "LockButton.h"

@interface LockButton()

/**
 正常情况的图片
 */
@property(nonatomic,strong)UIImage *normalImg;

/**
 被选中状态的图片
 */
@property(nonatomic,strong)UIImage *selectedImg;

/**
 错误情况下的图片
 */
@property(nonatomic,strong)UIImage *errorImg;

@end

@implementation LockButton

-(void)lockButtonImage:(UIImage *)image forState:(TXLockButtonState)state
{
    switch (state) {
        case TXLockButtonStateNormal:{
            self.normalImg = image ;
            break;
        }
        case TXLockButtonStateSelected:{
            self.selectedImg = image ;
            break;
        }
        case TXLockButtonStateError:{
            self.errorImg = image ;
            break;
        }
        default:
            break;
    }
    //设置图片后，设置为默认状态
    self.lockButtonState = TXLockButtonStateNormal;
}
/**
 重写lockButtonState的set方法，改变lockButton的状态自定切换lockButton的图片
 */
-(void)setLockButtonState:(TXLockButtonState)lockButtonState
{
    _lockButtonState = lockButtonState ;
    
    switch (_lockButtonState) {
        case TXLockButtonStateNormal:{
            self.image = self.normalImg ;
            break;
        }
        case TXLockButtonStateSelected:{
            self.image = self.selectedImg ;
            break;
        }
        case TXLockButtonStateError:{
            self.image = self.errorImg ;
            break;
        }
            default:
            break;
    }
}
@end
