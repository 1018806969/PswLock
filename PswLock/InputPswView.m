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
 输入密码提示的图片控件数组
 */
@property(nonatomic,strong)NSMutableArray *imgViews;

/**
 竖直分割线
 */
@property(nonatomic,strong)NSMutableArray *verticalLines;

/**
 self和keybroad的分割线
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
        
        //初始化图片控件和分割线控件
        for (int i = 0; i < _pswLength; i++) {
            UIImageView *imgView = [UIImageView new];
            imgView.contentMode = UIViewContentModeCenter;
            imgView.backgroundColor = [UIColor whiteColor];
            imgView.image = normalImage;
            imgView.highlightedImage = selectedImage;
            [self addSubview:imgView];
            [self.imgViews addObject:imgView];
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = color;
            [self addSubview:lineView];
            [self.verticalLines addObject:lineView];
        }
    }
    return self;
}
/**
 设置imageViews的高亮状态

 @param currentPasswordLength 当前已经输入的密码长度
 */
-(void)setupBtnWithCurrentPasswordLength:(NSInteger)currentPasswordLength
{
    for (int i = 0; i < _pswLength; i++) {
        UIImageView *imageView = self.imgViews[i];
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

/**
 布局输入视图
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat img_Width = (self.bounds.size.width - _pswLength -1)/_pswLength;
    for (int i = 0; i< _pswLength; i++) {
        UIButton *button = self.imgViews[i];
        button.frame = CGRectMake(1+(img_Width +1)*(i%_pswLength), 0, img_Width, self.bounds.size.height-1);
        UIView *view = self.verticalLines[i];
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

- (NSMutableArray *)imgViews {
    if (!_imgViews) {
        _imgViews = [NSMutableArray arrayWithCapacity:_pswLength];
    }
    return _imgViews;
}

- (NSMutableArray *)verticalLines {
    if (!_verticalLines) {
        _verticalLines = [NSMutableArray arrayWithCapacity:_pswLength];
    }
    return  _verticalLines;
}

@end
