//
//  IssueChartEchartCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartEchartCell.h"
#import "EchartView.h"

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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
