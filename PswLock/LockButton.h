//
//  LockButton.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//


/*
 自定义的一个imageView，主要是添加了一个状态属性，用于标记不同的自己的状态，并重写状态属性的set方法
 
 首先设置好imageView在不同状态下的图片，重写状态属性的set方法，当改变imageView的状态时就会改变为对应的Image
 
 经典：
     对外：通过一个状态属性改变自身的图片
 
 */
#import <UIKit/UIKit.h>

/**
 lockButton的状态-----根据不同的状态显示不同的图片

 - TXLockButtonStateNormal: 正常状态
 - TXLockButtonStateSelected: 选中状态
 - TXLockButtonStateError: 错误状态
 */
typedef NS_ENUM(NSInteger, TXLockButtonState){
    TXLockButtonStateNormal,
    TXLockButtonStateSelected,
    TXLockButtonStateError
};






@interface LockButton : UIImageView

@property(nonatomic,assign)TXLockButtonState lockButtonState;

/**
 自定三个Image属性代表三种不同状态，为不同的状态赋值不同的图片
 */
- (void)lockButtonImage:(UIImage *)image forState:(TXLockButtonState)state;


@end
