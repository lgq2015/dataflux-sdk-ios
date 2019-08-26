//
//  IgnoreItemView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/21.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IgnoreItemView.h"
@interface IgnoreItemView()
@property (nonatomic, strong) UIButton *ignoreBtn;
@end
@implementation IgnoreItemView
-(instancetype)init{
    if (self) {
        self= [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    [self.ignoreBtn setFrame:CGRectMake(kWidth-100, -40, 80, 35)];

   
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_ignoreBtn];
    
    [_ignoreBtn setFrame:CGRectMake(kWidth-100, kTopHeight, 80, 35)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_ignoreBtn setFrame:CGRectMake(kWidth-100, 12+kTopHeight, 80, 35)];
        
    } completion:nil];
    
}
-(UIButton *)ignoreBtn{
    if (!_ignoreBtn) {
        _ignoreBtn = [PWCommonCtrl buttonWithFrame:CGRectMake(kWidth-100, -40, 80, 35) type:PWButtonTypeWord text:NSLocalizedString(@"local.IgnoreIssue", @"")];
        _ignoreBtn.titleLabel.font = RegularFONT(13);
        [_ignoreBtn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
        [_ignoreBtn setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateSelected];
        [_ignoreBtn setTitleColor:PWTextColor forState:UIControlStateNormal];
        [_ignoreBtn setTitleColor:PWTextColor forState:UIControlStateSelected];
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _ignoreBtn.layer.cornerRadius = 8;
        _ignoreBtn.layer.masksToBounds = YES;
    }
    return _ignoreBtn;
}
- (void)ignoreBtnClick{
    if (self.itemClick) {
        self.itemClick();
    }
    [self disMissView];
}
- (void)disMissView{
    [_ignoreBtn setFrame:CGRectMake(kWidth-100, 12+kTopHeight, 80, 35)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_ignoreBtn removeFromSuperview];
                     }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
