//
//  SectionBgNumberView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SectionBgNumberView.h"
#import "CanlendarBgLayoutAttributes.h"
@interface SectionBgNumberView()
@property (nonatomic, strong) UILabel *bgMonthLab;
@end
@implementation SectionBgNumberView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.bgMonthLab];
    [self.bgMonthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(280));
    }];
}
-(UILabel *)bgMonthLab{
    if (!_bgMonthLab) {
        _bgMonthLab = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(200) textColor:[UIColor colorWithHexString:@"#EDF5FE"] text:@"5"];
        _bgMonthLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bgMonthLab];
    }
    return _bgMonthLab;
}
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[CanlendarBgLayoutAttributes class]]) {
        CanlendarBgLayoutAttributes *attr = (CanlendarBgLayoutAttributes *)layoutAttributes;
        if ([attr.bgText isEqualToString:@"0"]) {
            self.bgMonthLab.text = @"";
        }else{
            self.bgMonthLab.text = attr.bgText;
        }
        
//        self.backgroundColor = attr.bgText;
    }
}
@end
