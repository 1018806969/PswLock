//
//  LockView.m
//  PswLock
//
//  Created by txx on 16/12/16.
//  Copyright © 2016年 txx. All rights reserved.
//

#import "LockView.h"
#import "LockButton.h"

@interface LockView()
{
    CGPoint _point;
}
@property(nonatomic,strong)NSMutableArray *lockButtons;
@property(nonatomic,strong)NSMutableArray *selectedLoakButtons;
@property(nonatomic,strong)NSString       *psw;

@end
@implementation LockView

-(instancetype)initWithDelegate:(id<LockViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate ;
        
        _margin = 20;
        _w_h = 44;
        _lineColor = [UIColor redColor];
        _lineWidth = 2 ;
        _psw = @"";
        
        [self addLockButton];
    }
    return self ;
}
-(void)addLockButton
{
    for (int i = 0; i < 9; i++) {
        LockButton *button = [[LockButton alloc]init];
        button.lockButtonState = TXLockButtonStateNormal;
        button.tag = i ;
        [self.lockButtons addObject:button];
        [self addSubview:button];
    }
}
-(void)setLockButtonImage:(UIImage *)image forState:(TXLockButtonState)state
{
    for (LockButton *button in self.lockButtons) {
        [button lockButtonImage:image forState:state];
    }
}
-(void)layoutSubviews
{
    CGFloat interval = (self.bounds.size.width - 3 *_w_h)/4;
    for (int i=0; i<9; i++) {
        CGFloat x        = interval + (_w_h +interval)*(i/3);
        CGFloat y        = interval +(_w_h +interval)*(i%3);
        LockButton *button =self.lockButtons[i];
        button.frame = CGRectMake(x, y, _w_h, _w_h);
//        button.backgroundColor = [UIColor grayColor];
        button.layer.cornerRadius = _w_h/2;
        button.layer.masksToBounds = YES ;
    }
}
-(void)drawRect:(CGRect)rect
{
    
    if (self.selectedLoakButtons.count == 0) return;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = _lineWidth ;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [_lineColor set];
    
 
    NSInteger count = _selectedLoakButtons.count;
    for ( NSInteger i = 0; i<count; i++) {
        LockButton *button = self.selectedLoakButtons[i];
        if (i == 0) {
            [bezierPath moveToPoint:button.center];
        }else
        {
            [bezierPath addLineToPoint:button.center];
        }
    }
    [bezierPath addLineToPoint:_point];
    [bezierPath stroke];
    
}
-(void)updateDraw
{
    for (LockButton *button in self.lockButtons) {
        //如果手指在其中一个lockButton之内
        if (CGRectContainsPoint(button.frame, _point)) {
            //并且这个按钮之前没有被选中
            if (button.lockButtonState == TXLockButtonStateNormal) {
                //标记按钮被选中，并添加数组
                [_selectedLoakButtons addObject:button];
                button.lockButtonState = TXLockButtonStateSelected;
                break;
            }
        }
    }
    //重新绘制
    [self setNeedsDisplay];
}
-(void)setupPsw
{
    NSString *psw = @"";
    for (LockButton *button in self.selectedLoakButtons) {
        psw = [psw stringByAppendingString:[NSString stringWithFormat:@"%ld",button.tag]];
    }
    _psw = psw ;
    if (_delegate && [_delegate respondsToSelector:@selector(lockView:didFinishCreatePsw:)]) {
        [self.delegate lockView:self didFinishCreatePsw:_psw];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    _point = [touch locationInView:self];
    
    [self updateDraw];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    _point = [[touches anyObject] locationInView:self];
    // 更新密码绘制状态
    [self updateDraw];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    // 获取绘制好的密码
    [self setupPsw];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    // 获取绘制好的密码
    [self setupPsw];
}
-(void)errorPsw:(NSString *)psw time:(CGFloat)time finishHandle:(void (^)(LockView *))handler
{
    //情况选中值
    self.selectedLoakButtons = nil ;
    
    //使用c语言的方式获取字符串的每一位，比较方便
    const char *cPsw = [psw cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i<psw.length; i++) {
        //将char转换为对应的int （ASII 48）
        int index = cPsw[i] - '0';
        LockButton *errorButton = self.lockButtons[index];
        errorButton.lockButtonState = TXLockButtonStateError;
        [self.selectedLoakButtons addObject:errorButton];
    }
    [self setNeedsDisplay];
    
    // 这个时候不接受触摸事件
    self.userInteractionEnabled = NO;
    __weak LockView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LockView *strongSelf = weakSelf;
        if (strongSelf) {
            // 展示错误 延时后重置状态
            [strongSelf resetDrawing];
            // 开启交互
            strongSelf.userInteractionEnabled = YES;
            if (handler) {
                handler(strongSelf);
            }
        }
    });

}
- (void)resetDrawing {
    for (LockButton *button in _selectedLoakButtons) {
        button.lockButtonState = TXLockButtonStateNormal;
    }
    [_selectedLoakButtons removeAllObjects];
    [self setNeedsDisplay];
}

-(NSMutableArray *)selectedLoakButtons
{
    if (!_selectedLoakButtons) {
        _selectedLoakButtons = [[NSMutableArray alloc]init];
    }
    return _selectedLoakButtons ;
}
-(NSMutableArray *)lockButtons
{
    if (!_lockButtons) {
        _lockButtons = [[NSMutableArray alloc]init];
    }
    return _lockButtons;
}
@end
