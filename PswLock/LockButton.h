//
//  LockButton.h
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXLockButtonState){
    TXLockButtonStateNormal,
    TXLockButtonStateSelected,
    TXLockButtonStateError
};






@interface LockButton : UIImageView

@property(nonatomic,assign)TXLockButtonState lockButtonState;

/**
 给某状态的lockbutton添加相应的Image
 */
- (void)lockButtonImage:(UIImage *)image forState:(TXLockButtonState)state;


@end
