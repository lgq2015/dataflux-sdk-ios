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
//    NSInteger durationTime = [paramsDict_ integerValueForKey:@"duration" defaultValue:0];
//    NSString *leftImage = [paramsDict_ stringValueForKey:@"leftImage" defaultValue:@""];
    //    NSString *rightImage =  [[paramsDict_ dictValueForKey:@"rightBtn" defaultValue:@{}]stringValueForKey:@"image" defaultValue:@""];
    
    CGPoint center = self.leftView.center;
    center.x = self.cycleScrollView.center.x;
    self.cycleScrollView.center = center;
    [self bringSubviewToFront:self.leftView];
    
}
-(UIImageView *)leftView{
    if (!_leftView) {
        CGFloat leftView_Size  = ZOOM_SCALE(30);
        _leftView = [[UIImageView alloc]initWithFrame:CGRectMake(ZOOM_SCALE(17),(self.frame.size.height - leftView_Size)/2.0, leftView_Size, leftView_Size)];
        NSLog(@"%@",NSStringFromCGRect(self.frame));
         [self addSubview:_leftView];
    }
    return _leftView;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(ZOOM_SCALE(37), ZOOM_SCALE(10), ZOOM_SCALE(304), ZOOM_SCALE(40)) delegate:self placeholderImage:nil];
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView.onlyDisplayText = YES;
        _cycleScrollView.autoScrollTimeInterval = (float)300/(float)1000;
        _cycleScrollView.titleLabelTextColor =[UIColor colorWithHexString:@"#333333"];
        _cycleScrollView.titleLabelTextFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
        _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        [_cycleScrollView disableScrollGesture];
        [self addSubview:_cycleScrollView];
    }
    return _cycleScrollView;
}
-(void)createUIWithImgAndTitleArray:(NSArray *)array{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
