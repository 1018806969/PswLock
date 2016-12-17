//
//  LockButton.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "LockButton.h"

@interface LockButton()

@property(nonatomic,strong)UIImage *normalImg;

@property(nonatomic,strong)UIImage *selectedImg;

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
 重写lockButtonState的set方法
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
