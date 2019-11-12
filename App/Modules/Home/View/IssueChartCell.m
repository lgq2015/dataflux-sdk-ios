//
//  IssueChartCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartCell.h"
#import "ClassifyModel.h"
@interface IssueChartCell()
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation IssueChartCell
-(void)setFrame:(CGRect)frame{
    frame.origin.x += Interval(16);
    frame.size.width -= Interval(32);
    frame.size.height -= Interval(10);
    [super setFrame:frame];
}
-(void)setModel:(ClassifyModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(Interval(12), ZOOM_SCALE(46), kWidth-Interval(56), SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:line];
    self.layer.cornerRadius = 4;
    [self initCardItem];
}
- (void)initCardItem{
    
    NSArray *level = @[[NSString stringWithFormat:@"%lu",(unsigned long)self.model.dangerAry.count],[NSString stringWithFormat:@"%lu",(unsigned long)self.model.warningAry.count],[NSString stringWithFormat:@"%lu",(unsigned long)self.model.commonAry.count]];
    NSArray *title = @[NSLocalizedString(@"local.danger", @""),NSLocalizedString(@"local.warning", @""),NSLocalizedString(@"local.info", @"")];
    NSArray *color = @[PWDangerColor,PWWarningColor,PWCommonColor];
    CGFloat itemSpacing = ZOOM_SCALE(85);
    CGFloat left = (kWidth-Interval(32)-itemSpacing*2-ZOOM_SCALE(30)*3)/2.00;
    for(NSInteger i=0; i<title.count; i++) {
        UILabel *countLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(61), ZOOM_SCALE(50), ZOOM_SCALE(33)) font:BOLDFONT(24) textColor:color[i] text:level[i]];
        countLab.tag = i+100;
        [[self viewWithTag:i+100] removeFromSuperview];
        countLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLab];
        UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(left+i*(ZOOM_SCALE(30)+itemSpacing), ZOOM_SCALE(94), ZOOM_SCALE(30), ZOOM_SCALE(18)) font:RegularFONT(13) textColor:PWTextBlackColor text:title[i]];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.tag = i+200;
        [[self viewWithTag:i+200] removeFromSuperview];
        [self addSubview:nameLab];
        [countLab sizeToFit];
        countLab.centerX = nameLab.centerX;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(12), ZOOM_SCALE(12), ZOOM_SCALE(100), ZOOM_SCALE(22)) font:BOLDFONT(16) textColor:PWTextBlackColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
