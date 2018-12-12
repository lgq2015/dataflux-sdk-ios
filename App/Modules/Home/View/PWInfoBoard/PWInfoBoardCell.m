//
//  PWInfoBoardCell.m
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/16.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWInfoBoardCell.h"


static NSString *const PWInfoTypeMonitor
= @"monitor";
static NSString *const PWInfoTypeConsume
= @"consume";
static NSString *const PWInfoTypeSecurity
= @"security";
static NSString *const PWInfoTypeService
= @"service";
static NSString *const PWInfoTypeOptimization
= @"optimization";
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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.06;
    }
    
    return self;
}
-(void)setDatas:(NSDictionary *)datas{
    _datas = datas;
    [self setupUI];
}

- (void)setupUI{
    self.tickImg.hidden = YES;
    //数据类型 ,type,为 monitor(监控)，consume（费用），security（安全） ，service（服务），optimization（优化）, serviceConnect（链接服务）

//    NSString *subtitle = [self.datas stringValueForKey:@"subtitle" defaultValue:@""];
//    self.subtitle.text = subtitle;
    NSString *messageCountStr = [NSString stringWithFormat:@"%@",self.datas[@"messageCount"]];
    if(![[self.datas allKeys] containsObject:@"messageCount"]){
        messageCountStr = @"";
    }
    if (messageCountStr.length != 0 && ![messageCountStr isEqualToString:@"0"]) {
        self.popView.hidden = NO;
        self.count.hidden = NO;
        [self fitPopFrameWithCount:messageCountStr];
    }else{
        _popView.hidden = YES;
        _count.hidden = YES;
    }
        UIColor *textColor;
        switch ([self.datas[@"state"] intValue]) {
            case PWInfoBoardItemStateRecommend:
                self.tickImg.hidden = NO;
                [self fitPopFrameWithCount:0];
                _count.hidden = YES;
                _popView.hidden = NO;
//                textColor = [UZAppUtils colorFromNSString:@"#3FEC67"];
                break;
            case PWInfoBoardItemStateWarning:
//                textColor = [UZAppUtils colorFromNSString:@"#FFE27E"];
                break;
            case PWInfoBoardItemStateSeriousness:
//                textColor = [UZAppUtils colorFromNSString:@"#FF7975"];
                break;
            default:
                break;
        }
        self.popView.backgroundColor = textColor;
    
    NSString *type = self.datas[@"type"];
    NSString *imageName;
    if ([type isEqualToString:PWInfoTypeConsume]) {
        self.title.text = @"费用";
        imageName = @"consume";
    }else if([type isEqualToString:PWInfoTypeMonitor]){
        self.title.text = @"监控";
        imageName = @"monitoring";
    }else if([type isEqualToString:PWInfoTypeService]){
        self.title.text = @"服务";
        imageName = @"service";
    }else if([type isEqualToString:PWInfoTypeSecurity]){
        self.title.text = @"安全";
        imageName = @"safe";
    }else if([type isEqualToString:PWInfoTypeOptimization]){
        self.title.text = @"优化";
        imageName = @"optimize";
    }
    self.iconImg.image = [UIImage imageNamed:imageName];
   
}

-(void)fitPopFrameWithCount:(NSString *)count{
//    self.count.text =count;
//    [self.count sizeToFit];
//    CGFloat width = self.count.frame.size.width+8>36? self.count.frame.size.width+8:36;
//    CGFloat realWidth = width<50? width:50;
//    self.subtitle.frame = CGRectMake(102*ZOOM_SCALE, 22*ZOOM_SCALE, 170*ZOOM_SCALE-(realWidth-36), 17*ZOOM_SCALE);
//    self.popView.frame = CGRectMake(280*ZOOM_SCALE, 12*ZOOM_SCALE, realWidth, realWidth);
//    self.popView.center = CGPointMake(298*ZOOM_SCALE,self.contentView.center.y);
//    self.popView.layer.cornerRadius = realWidth/2.00;
//    self.count.frame = self.popView.frame;
//    if (self.tickImg.hidden == NO) {
//        _tickImg.frame = CGRectMake(0, 0, 19*ZOOM_SCALE, 13*ZOOM_SCALE);
//        _tickImg.center =CGPointMake(298*ZOOM_SCALE,self.contentView.center.y);
//    }
//    initialCenter = CGPointMake(self.popView.frame.origin.x+self.popView.frame.size.width/2, self.popView.frame.origin.y+self.popView.frame.size.height/2);
//    [self bringSubviewToFront:self.count];
//    if (_tickImg.hidden==NO) {
//        [self bringSubviewToFront:self.tickImg];
//    }
}
-(UILabel *)subtitle{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _subtitle.font = [UIFont systemFontOfSize:12];
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
        _title = [[UILabel alloc]initWithFrame:CGRectMake(ZOOM_SCALE(60), ZOOM_SCALE(19), ZOOM_SCALE(32), ZOOM_SCALE(22))];
        _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _title.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [self addSubview:_title];
    }
    return _title;
}
-(UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(19), ZOOM_SCALE(15), ZOOM_SCALE(30), ZOOM_SCALE(30))];
        _iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImg];
    }
    return _iconImg;
}
-(UILabel *)count{
    if (!_count) {
        _count = [[UILabel alloc]initWithFrame:CGRectZero];
        _count.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _count.textAlignment = NSTextAlignmentCenter;
        _count.textColor = [UIColor whiteColor];
        _count.backgroundColor = [UIColor clearColor];
        [self addSubview:_count];
    }
    return _count;
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
-(UIImageView *)tickImg{
    if (!_tickImg) {
        _tickImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tick"]];
        _tickImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_tickImg];
    }
    return _tickImg;
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
