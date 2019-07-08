//
//  AddIssueGuideView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/31.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddIssueGuideView.h"
#import "TriangleDrawRect.h"

@interface AddIssueGuideView()
@property (nonatomic, strong) UIView *contentView;
@end
@implementation AddIssueGuideView
-(instancetype)init{
    if (self) {
        self= [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.userInteractionEnabled = YES;
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = PWBlueColor;
    backView.layer.cornerRadius = ZOOM_SCALE(25);
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kTopHeight);
        make.right.mas_equalTo(self).offset(-Interval(16));
        make.width.offset(ZOOM_SCALE(240));
        make.height.offset(ZOOM_SCALE(50));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWWhiteColor text:@"在这里新建情报，以情报形式与您的团队共同解决"];
    tipLab.numberOfLines = 2;
    tipLab.backgroundColor = PWBlueColor;
    
    [backView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView);
        make.right.mas_equalTo(backView).offset(-Interval(5));
        make.width.offset(ZOOM_SCALE(220));
        make.height.offset(ZOOM_SCALE(50));
    }];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    TriangleDrawRect *triangle = [[TriangleDrawRect alloc]initStartPoint:CGPointMake(12, 0) middlePoint:CGPointMake(0, 16) endPoint:CGPointMake(24, 16) color:PWBlueColor];
    [self addSubview:triangle];
    [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backView.mas_top).offset(1);
        make.width.offset(24);
        make.height.offset(16);
        make.right.offset(-42);
    }];
    [self bringSubviewToFront:backView];
}
- (void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
}
- (void)disMissView{
    [self removeFromSuperview];
    [_contentView removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
