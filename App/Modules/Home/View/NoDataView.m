//
//  IssueListNoDataView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/4/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NoDataView.h"
@interface NoDataView()
@property (nonatomic, assign) NoDataViewStyle style;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation NoDataView
-(instancetype)initWithFrame:(CGRect)frame style:(NoDataViewStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    CGFloat top = ZOOM_SCALE(72);
    CGFloat width = ZOOM_SCALE(222);
    CGFloat height = ZOOM_SCALE(190);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, width, height)];
    [image setImage:[UIImage imageNamed:@"blank_page"]];
    image.centerX = self.centerX;
    NSString *tip,*btnTitle = @"";
    BOOL hideBtn = NO;
    [self addSubview:image];
    switch (self.style) {
        case NoDataViewNormal:
            tip = @"暂无列表";
            hideBtn = YES;
            break;
        case NoDataViewIssueList:
            tip = @"暂无情报，试试更改筛选条件";
            hideBtn = YES;
            btnTitle = @"查看过去 24 小时恢复的情报";
            break;
        case NoDataViewLastDay:
            tip = @"过去 24 小时无情报";
            hideBtn = YES;
            btnTitle = @"进入日历";
            break;
    }
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:tip];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(ZOOM_SCALE(27));
        make.left.right.mas_equalTo(self);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(16));
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(ZOOM_SCALE(55));
        make.height.offset(ZOOM_SCALE(47));
    }];
    self.btn.hidden = hideBtn;
    [self.btn setTitle:btnTitle forState:UIControlStateNormal];
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@""];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }
    return _btn;
}
- (void)btnClick{
    if (self.btnClickBlock) {
        self.btnClickBlock();
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
