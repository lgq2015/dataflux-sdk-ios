//
//  HomeNoticeScrollView.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/29.
//  Copyright © 2018 hll. All rights reserved.
//

#import "HomeNoticeScrollView.h"
#import "SDCycleScrollView.h"
@interface HomeNoticeScrollView()<SDCycleScrollViewDelegate>
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic , strong) SDCycleScrollView *cycleScrollView;
@end
@implementation HomeNoticeScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.index = 0;
        [self createUI];
    }
    return self;
}
-(void)createUI{

    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(26));
        make.width.height.offset(ZOOM_SCALE(30));
        make.top.mas_equalTo(self).offset(-ZOOM_SCALE(15));
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(Interval(15));
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-Interval(16));
    }];
    [self bringSubviewToFront:self.leftView];
    
}
-(UIImageView *)leftView{
    if (!_leftView) {
        _leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_hat"]];
         [self addSubview:_leftView];
    }
    return _leftView;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView= [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.autoScrollTimeInterval = (float)300/(float)1000;
        _cycleScrollView.titleLabelTextColor =PWTitleColor;
        _cycleScrollView.titleLabelTextFont = RegularFONT(15);
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        [_cycleScrollView disableScrollGesture];
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}
-(void)createUIWithTitleArray:(NSArray *)array{
    self.cycleScrollView.titlesGroup = array;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
