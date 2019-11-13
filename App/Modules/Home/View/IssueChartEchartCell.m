//
//  IssueChartEchartCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartEchartCell.h"
#import "EchartView.h"
#import "ClassifyModel.h"
@interface IssueChartEchartCell()
@property (nonatomic, strong) EchartView *echartView;
@end
@implementation IssueChartEchartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ClassifyModel *)model{
    [super setModel:model];
    if (!_echartView) {
        _echartView = [[EchartView alloc]initWithDict:model.echartDatas];
        _echartView.frame = CGRectMake(Interval(12), ZOOM_SCALE(140), kWidth-Interval(56), ZOOM_SCALE(200));
        _echartView.kEchartView.frame = CGRectMake(0, 0, kWidth-Interval(32), ZOOM_SCALE(250));
        [self addSubview:_echartView];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
