//
//  InputPswView.m
//  PswLock
//
//  Created by txx on 16/12/17.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "InputPswView.h"


@interface InputPswView()

/**
 输入密码提示图片
 */
@property(nonatomic,strong)NSMutableArray *buttons;

/**
 分割线
 */
@property(nonatomic,strong)NSMutableArray *lines;

/**
 下面的分割线
 */
@property(nonatomic,strong)UIView         *underLineView;

/**
 密码长度
 */
@property(nonatomic,assign)NSInteger      pswLength;

@end
@implementation InputPswView

-(instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage separateLineColor:(UIColor *)color pswLength:(NSInteger)Length
{
    self = [super init];
    if (self) {
        _pswLength = Length;
        self.underLineView.backgroundColor = color;
        [self addSubview:self.underLineView];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        
        //初始化子控件
        for (int i = 0; i < _pswLength; i++) {
            UIImageView *imgView = [UIImageView new];
            imgView.contentMode = UIViewContentModeCenter;
            imgView.backgroundColor = [UIColor whiteColor];
            imgView.image = normalImage;
            imgView.highlightedImage = selectedImage;
            [self addSubview:imgView];
            [self.buttons addObject:imgView];
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = color;
            [self addSubview:lineView];
            [self.lines addObject:lineView];
        }
    }
    return self;
}
-(void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength
{
    for (int i = 0; i < currentPasswordLength; i++) {
        UIImageView *imageView = self.buttons[i];
        //切换图片显示
        if(i < currentPasswordLength)
        {
            //显示已经输入状态的图片
            imageView.highlighted = YES ;
        }else
        {
            //显示未输入状态的图片
            imageView.highlighted = NO;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat img_Width = (self.bounds.size.width - _pswLength -1)/_pswLength;
    for (int i = 0; i< _pswLength; i++) {
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(1+(img_Width +1)*(i%_pswLength), 0, img_Width, self.bounds.size.height-1);
        UIView *view = self.lines[i];
        view.frame = CGRectMake((img_Width+1)*(i%+_pswLength), 0, 1, self.bounds.size.height-1);
    }
    self.underLineView.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
}
- (UIView *)underLineView {
    if (!_underLineView) {
        _underLineView = [UIView new];
    }
    return _underLineView;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:_pswLength];
    }
    return _buttons;
}

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [NSMutableArray arrayWithCapacity:_pswLength];
    }
    return  _lines;
}

@end
