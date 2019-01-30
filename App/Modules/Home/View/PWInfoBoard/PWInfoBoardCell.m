//
//  PWInfoBoardCell.m
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/16.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWInfoBoardCell.h"

//%%% pop values
static CGFloat const kPopStartRatio = .75;
static CGFloat const kPopOutRatio = 1.2;
static CGFloat const kPopInRatio = .95;

//%%% bump values
static CGFloat const kFirstBumpDistance = 8.0;
static CGFloat const kBumpTimeSeconds = 0.2;
static CGFloat const SECOND_BUMP_DIST = 4.0;
static CGFloat const kBumpTimeSeconds2 = 0.1;
@interface PWInfoBoardCell(){
    CGPoint initialCenter;
}
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UILabel *count;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIImageView *tickImg;
@property (nonatomic, strong) UIImageView *backgroundImg;
@end
@implementation PWInfoBoardCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 8;
        self.layer.shadowOpacity = 0.06;
    }
    
    return self;
}
-(void)setModel:(InfoBoardModel *)model{
    _model = model;
    [self setupUI];
}

- (void)setupUI{
    self.contentView.backgroundColor = PWWhiteColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    //数据类型 ,type,为 monitor(监控)，consume（费用），security（安全） ，service（服务），optimization（优化）, serviceConnect（链接服务）
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImg.mas_right).offset(Interval(15));
        make.centerY.mas_equalTo(self.iconImg);
        make.width.offset(ZOOM_SCALE(36));
    }];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-Interval(20));
        make.width.height.offset(ZOOM_SCALE(38));
        make.centerY.mas_equalTo(self);
    }];
    self.popView.layer.cornerRadius = ZOOM_SCALE(19);
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.title.mas_right).offset(Interval(10));
        make.right.mas_equalTo(self.popView.mas_left).offset(-Interval(10));
        make.height.offset(ZOOM_SCALE(18));
        make.centerY.mas_equalTo(self);
    }];
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.popView);
        make.center.mas_equalTo(self.popView);
        make.height.offset(ZOOM_SCALE(21));
    }];
    [self.tickImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ZOOM_SCALE(20));
        make.center.mas_equalTo(self.popView);
        make.height.offset(ZOOM_SCALE(14));
    }];
    self.subtitle.text = self.model.subTitle;
    NSString *messageCountStr = [NSString stringWithFormat:@"%@",self.model.messageCount];
       self.count.text = messageCountStr;
    
        self.popView.hidden = NO;
        self.count.hidden = NO;
        self.tickImg.hidden = YES;
        UIColor *popColor;
        switch (self.model.state) {
            case PWInfoBoardItemStateRecommend:
                self.tickImg.hidden = NO;
                _count.hidden = YES;
                popColor = [UIColor colorWithHexString:@"#3FEC67"];
                break;
            case PWInfoBoardItemStateWarning:
                popColor = [UIColor colorWithHexString:@"#FFE27E"];
                break;
            case PWInfoBoardItemStateSeriousness:
                popColor = [UIColor colorWithHexString:@"#FF7975"];
                break;
        }
        self.popView.backgroundColor = popColor;
    
    
    NSString *imageName;
    switch (self.model.type) {
        case PWInfoTypeConsume:
            self.title.text = @"费用";
            imageName = @"icon_expense";
            break;
        case PWInfoTypeMonitor:
            self.title.text = @"监控";
            imageName = @"icon_monitor";
            break;
        case PWInfoTypeAlert:
            self.title.text = @"提醒";
            imageName = @"icon_caution";
            break;
        case PWInfoTypeOptimization:
            self.title.text = @"优化";
            imageName = @"icon_optimize";
            break;
        case PWInfoTypeSecurity:
            self.title.text = @"安全";
            imageName = @"icon_safe";
            break;
    }

    self.iconImg.image = [UIImage imageNamed:imageName];

}

-(void)fitPopFrameWithCount:(NSString *)count{
    self.count.text =count;
    [self.count sizeToFit];
    CGFloat width = self.count.frame.size.width+8>36? self.count.frame.size.width+8:36;
    CGFloat realWidth = width<50? width:50;
    self.subtitle.frame = CGRectMake(ZOOM_SCALE(102), ZOOM_SCALE(22), ZOOM_SCALE(170)-(realWidth-36), ZOOM_SCALE(17));
    self.popView.frame = CGRectMake(ZOOM_SCALE(280), ZOOM_SCALE(12), realWidth, realWidth);
    self.popView.center = CGPointMake(ZOOM_SCALE(298),self.contentView.center.y);
    self.popView.layer.cornerRadius = realWidth/2.00;
    self.count.frame = self.popView.frame;
    if (self.tickImg.hidden == NO) {
        _tickImg.frame = CGRectMake(0, 0, ZOOM_SCALE(19), ZOOM_SCALE(13));
        _tickImg.center =CGPointMake(ZOOM_SCALE(298),self.contentView.center.y);
    }
    initialCenter = CGPointMake(self.popView.frame.origin.x+self.popView.frame.size.width/2, self.popView.frame.origin.y+self.popView.frame.size.height/2);
    [self bringSubviewToFront:self.count];
    if (_tickImg.hidden==NO) {
        [self bringSubviewToFront:self.tickImg];
    }
}
-(UILabel *)subtitle{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _subtitle.font = [UIFont systemFontOfSize:13];
        _subtitle.numberOfLines = 1;
        _subtitle.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self addSubview:_subtitle];
    }
    return _subtitle;
}
-(UIView *)popView{
    if (!_popView) {
        _popView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:_popView];
    }
    return _popView;
}
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectZero];
        _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _title.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:_title];
    }
    return _title;
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(11), ZOOM_SCALE(18), ZOOM_SCALE(28), ZOOM_SCALE(28))];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImg];
    }
    return _iconImg;
}
-(UILabel *)count{
    if (!_count) {
        _count = [[UILabel alloc]initWithFrame:CGRectZero];
        _count.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _count.textAlignment = NSTextAlignmentCenter;
        _count.textColor = [UIColor whiteColor];
        _count.backgroundColor = [UIColor clearColor];
        [self addSubview:_count];
    }
    return _count;
}
-(UIImageView *)tickImg{
    if (!_tickImg) {
        _tickImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick"]];
        _tickImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_tickImg];
    }
    return _tickImg;
}
- (void)pop
{
    const float height = self.popView.frame.size.height;
    const float width = self.popView.frame.size.width;
    const float pop_start_h = height * kPopStartRatio;
    const float pop_start_w = width * kPopStartRatio;
    const float time_start = 0.05;
    const float pop_out_h = height * kPopOutRatio;
    const float pop_out_w = width * kPopOutRatio;
    const float time_out = .2;
    const float pop_in_h = height * kPopInRatio;
    const float pop_in_w = width * kPopInRatio;
    const float time_in = 0.05;
    const float pop_end_h = height;
    const float pop_end_w = width;
    const float time_end = 0.05;
    
    [UIView animateWithDuration:time_start animations:^{
        CGRect frame = self.popView.frame;
        CGPoint center = self.popView.center;
        frame.size.height = pop_start_h;
        frame.size.width = pop_start_w;
        self.popView.frame = frame;
        self.popView.center = center;
    }completion:^(BOOL complete){
        [UIView animateWithDuration:time_out animations:^{
            CGRect frame = self.popView.frame;
            CGPoint center = self.popView.center;
            frame.size.height = pop_out_h;
            frame.size.width = pop_out_w;
            self.popView.frame = frame;
            self.popView.center = center;
        }completion:^(BOOL complete){
            [UIView animateWithDuration:time_in animations:^{
                CGRect frame = self.popView.frame;
                CGPoint center = self.popView.center;
                frame.size.height = pop_in_h;
                frame.size.width = pop_in_w;
                self.popView.frame = frame;
                self.popView.center = center;
            }completion:^(BOOL complete){
                [UIView animateWithDuration:time_end animations:^{
                    CGRect frame = self.popView.frame;
                    CGPoint center = self.popView.center;
                    frame.size.height = pop_end_h;
                    frame.size.width = pop_end_w;
                    self.popView.frame = frame;
                    self.popView.center = center;
                }];
            }];
        }];
    }];
}
- (void)bump
{
    [self bumpCenterY:0];
    [UIView animateWithDuration:kBumpTimeSeconds animations:^{
        [self bumpCenterY:kFirstBumpDistance];
    }completion:^(BOOL complete){
        [UIView animateWithDuration:kBumpTimeSeconds animations:^{
            [self bumpCenterY:0];
        }completion:^(BOOL complete){
            [UIView animateWithDuration:kBumpTimeSeconds2 animations:^{
                [self bumpCenterY:SECOND_BUMP_DIST];
            }completion:^(BOOL complete){
                [UIView animateWithDuration:kBumpTimeSeconds2 animations:^{
                    [self bumpCenterY:0];
                }];
            }];
        }];
    }];
}

- (void)bumpCenterY:(float)yVal
{
  
    if (!CGPointEqualToPoint(initialCenter,self.popView.center)) {
        //%%% canel previous animation
    }
    CGPoint center = self.popView.center;
    center.y = initialCenter.y-yVal;
    self.popView.center = center;
    self.count.center = center;
    _tickImg.center = center;
}
@end
