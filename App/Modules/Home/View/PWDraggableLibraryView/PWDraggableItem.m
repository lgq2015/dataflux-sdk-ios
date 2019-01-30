//
//  PWDraggableItem.m
// 
//
//  Created by 胡蕾蕾 on 2018/9/12.
//  Copyright © 2018年 andezhou. All rights reserved.
//

#import "PWDraggableItem.h"
#import "LongPressControl.h"

static CGFloat kDuration = .3f;

#define screenHeight self.superview.frame.size.height //[UIScreen mainScreen].bounds.size.height
@interface PWDraggableItem ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger dragIndex;
@property (nonatomic, assign) CGPoint dragCenter;
@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, assign) NSMutableArray *dragButtons;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSUInteger startIndex;

@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UIButton *topView, *bottomView;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGes;

@property (nonatomic, assign) BOOL canMove;
@end
@implementation PWDraggableItem
#pragma mark -
#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        self.longPressGes.delegate = self;
        [self addGestureRecognizer:self.longPressGes];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)setModel:(PWDraggableModel *)model{

    _model = model;
    [self createUI];
}

- (void)createUI{
 
   
    CGFloat height = ZOOM_SCALE(116);
    if (!_iconImgVie) {
        _iconImgVie = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
        _iconImgVie.contentMode = UIViewContentModeBottom;
        [self addSubview:_iconImgVie];
    }
    
    self.iconImgVie.contentMode = UIViewContentModeScaleAspectFit;
    [self bringSubviewToFront:self.upTitleLab];
    [self bringSubviewToFront:self.subTitleLab];
//    self.upTitleLab.text = self.model.title;
//    self.subTitleLab.text = self.model.subtitle;
//    CGSize maximumLabelSize = CGSizeMake(ZOOM_SCALE(80), 34);//labelsize的最大值
//
//    CGSize expectSize = [_subTitleLab sizeThatFits:maximumLabelSize];
    //sizeThatsFits根据textLabel的字符长度显示label的大小，当textLabel的字符长度大于maximumLabelSize时，自动换行。
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    
}


- (void)tapGes:(UITapGestureRecognizer *)tap{

    if (self.clickBlock) {
        self.clickBlock([self.dragButtons indexOfObject:self]);
    }
}
- (void)setBtnArray:(NSMutableArray *)btnArray
{
    _btnArray = btnArray;
    
    for (PWDraggableItem *btn in btnArray) {
        btn.dragButtons = btnArray;
    }
}

#pragma mark -
#pragma mark init methods

#pragma mark -
#pragma mark GestureRecognizer
// 手势响应，并判断状态
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self touchesBegan:gestureRecognizer];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        [self touchesMoved:gestureRecognizer];
        
    } else {
         [[LongPressControl shareInfo] removeLongPressAction:LONG_PRESS_VIEW_DEMO];
        [self touchesEnded:gestureRecognizer];
    }
}

// 拖拽开始
- (void)touchesBegan:(UILongPressGestureRecognizer *)gestureRecognizer {
    [[self superview] bringSubviewToFront:self];
    
    self.startPoint = [gestureRecognizer locationInView:self];
    self.bgColor = self.backgroundColor;
    self.dragCenter = self.center;
    self.dragIndex = [self.dragButtons indexOfObject:self];
    self.startIndex = [self.dragButtons indexOfObject:self];
    
    //item 放大效果
        [UIView animateWithDuration:kDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
}

// 拖拽移动
- (void)touchesMoved:(UILongPressGestureRecognizer *)gestureRecognizer {
    // 调整被拖拽按钮的center， 保证它根手指一起滑动
    CGPoint newPoint = [gestureRecognizer locationInView:self];
    CGFloat deltaX = newPoint.x - self.startPoint.x;
    CGFloat deltaY = newPoint.y - self.startPoint.y;
    self.center = CGPointMake(self.center.x + deltaX, self.center.y + deltaY);
    if ([self.delegate respondsToSelector:@selector(dragCenter:)]) {
        [self.delegate dragCenter:self.center];
    }
    for (NSInteger index = 0; index < self.dragButtons.count; index ++) {
        UIButton *button = self.dragButtons[index];
        
        if (self.dragIndex != index) {
            if (CGRectContainsPoint(button.frame, self.center)) {
                [self adjustItems:self index:index];
            }
        }
    }
}

// 拖拽结束
- (void)touchesEnded:(UILongPressGestureRecognizer *)gestureRecognizer {
  
    [UIView animateWithDuration:kDuration animations:^{
       self.transform = CGAffineTransformIdentity;
        self.center = self.dragCenter;
    }];
    
    // 判断按钮位置是否已经改变，如果发生改变通过代理通知父视图
    if (self.startIndex != self.dragIndex) {
        if ([self.delegate respondsToSelector:@selector(dragButton:dragButtons:startIndex:endIndex:)]) {
            [self.delegate dragButton:self dragButtons:self.dragButtons startIndex:self.startIndex endIndex:self.dragIndex];
        }
    }
}
//  调整按钮位置
- (void)adjustItems:(PWDraggableItem *)dragBtn index:(NSInteger)index {
    UIButton *moveBtn = self.dragButtons[index];
    CGPoint moveCenter = moveBtn.center;
    
    __block CGPoint oldCenter = self.dragCenter;
    __block CGPoint nextCenter = CGPointZero;
    
    if (index < self.dragIndex) {  // 将靠前的按钮移动到靠后的位置
        
        for (NSInteger num = self.dragIndex - 1; num >= index; num--) {
            // 将上一个按钮的位置赋值给当前按钮
            [UIView animateWithDuration:kDuration animations:^{
                UIButton *nextBtn = [self.dragButtons objectAtIndex:num];
                nextCenter = nextBtn.center;
                nextBtn.center = oldCenter;
                oldCenter = nextCenter;
            }];
        }
        
        // 调整顺序
        [self.dragButtons insertObject:dragBtn atIndex:index];
        [self.dragButtons removeObjectAtIndex:self.dragIndex + 1];
        
    } else {  // 将靠后的按钮移动到前边
        
        for (NSInteger num = self.dragIndex + 1; num <= index; num ++) {
            // 将上一个按钮的位置赋值给当前按钮
            [UIView animateWithDuration:kDuration animations:^{
                UIButton *nextBtn = [self.dragButtons objectAtIndex:num];
                nextCenter = nextBtn.center;
                nextBtn.center = oldCenter;
                oldCenter = nextCenter;
            }];
        }
        
        // 调整顺序
        [self.dragButtons insertObject:dragBtn atIndex:index + 1];
        [self.dragButtons removeObjectAtIndex:self.dragIndex];
    }
    
    self.dragIndex = index;
    self.dragCenter = moveCenter;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
     if ([[LongPressControl shareInfo] isExistLongPressAction:LONG_PRESS_VIEW_DEMO]){
        return NO;
    }else{
        if (gestureRecognizer==self.longPressGes) {
            [[LongPressControl shareInfo] addLongPressAction:LONG_PRESS_VIEW_DEMO];
        }
        return YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
