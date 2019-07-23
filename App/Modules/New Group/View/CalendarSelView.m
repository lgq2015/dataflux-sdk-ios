//
//  CalendarSelView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CalendarSelView.h"
@interface CalendarSelView()
@property (nonatomic, assign) CGFloat topCons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *issueLogBtn;
@property (nonatomic, strong) UIButton *issueBtn;
@end
@implementation CalendarSelView
-(instancetype)initWithTop:(CGFloat)top{
    if (self) {
        self= [super init];
        _topCons = top;
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, self.topCons, kWidth, kHeight-self.topCons);
    self.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
   
    UILabel *issueLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(144), ZOOM_SCALE(70), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#333333"] text:@"情报视图"];
    issueLab.textAlignment = NSTextAlignmentCenter;
    issueLab.centerX = self.issueBtn.centerX;
    [self.contentView addSubview:issueLab];
    UILabel *issueLogLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(144), ZOOM_SCALE(70), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#333333"] text:@"日志视图"];
    issueLogLab.textAlignment = NSTextAlignmentCenter;
    issueLogLab.centerX = self.issueLogBtn.centerX;
    [self.contentView addSubview:issueLogLab];
    
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    self.isShow = YES;
    [view addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    CalendarViewType type  = [userManager getCurrentCalendarViewType];
    if (type == CalendarViewTypeGeneral) {
        self.issueBtn.selected = YES;
        self.issueLogBtn.selected = NO;
    }else{
        self.issueLogBtn.selected = YES;
        self.issueBtn.selected = NO;
    }
    
    
    [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(192), kWidth,ZOOM_SCALE(192))];
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.alpha = 1.0;
        _contentView.alpha =1.0;
        [_contentView setFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(192))];
        
    } completion:nil];
    
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(192))];
        _contentView.backgroundColor = PWWhiteColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap)];
        [_contentView addGestureRecognizer:tap];
        [self addSubview:_contentView];
    }
    return _contentView;
}
- (void)contentTap{}
-(UIButton *)issueBtn{
    if (!_issueBtn) {
        _issueBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(42), ZOOM_SCALE(28), ZOOM_SCALE(126), ZOOM_SCALE(106))];
        [_issueBtn setBackgroundImage:[UIImage imageNamed:@"issue_nor"] forState:UIControlStateNormal];
        [_issueBtn setBackgroundImage:[UIImage imageNamed:@"issue_sel"] forState:UIControlStateSelected];
        [_issueBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_issueBtn];
    }
    return _issueBtn;
}
-(UIButton *)issueLogBtn{
    if (!_issueLogBtn) {
        _issueLogBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-ZOOM_SCALE(42)-ZOOM_SCALE(126), ZOOM_SCALE(28), ZOOM_SCALE(126), ZOOM_SCALE(106))];
        [_issueLogBtn setBackgroundImage:[UIImage imageNamed:@"issuelog_nor"] forState:UIControlStateNormal];
        [_issueLogBtn setBackgroundImage:[UIImage imageNamed:@"issuelog_sel"] forState:UIControlStateSelected];
        [_issueLogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_issueLogBtn];
    }
    return _issueLogBtn;
}
- (void)btnClick:(UIButton *)button{
    if ([button isEqual:self.issueBtn]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectCalendarViewType:)]) {
            [self.delegate selectCalendarViewType:CalendarViewTypeGeneral];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectCalendarViewType:)]) {
            [self.delegate selectCalendarViewType:CalendarViewTypeLog];
        }
    }
}
- (void)disMissView{
    if (self.disMissClick) {
        self.disMissClick();
    }
    self.isShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.contentView.frame = CGRectMake(0, -ZOOM_SCALE(192), kWidth, ZOOM_SCALE(192));
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [UIView commitAnimations];
}
- (void)commitClick{
    
    [self disMissView];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
