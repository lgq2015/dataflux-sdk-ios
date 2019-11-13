//
//  IssueChartListCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChartListCell.h"
#import "ClassifyModel.h"
#import "MineCellModel.h"
#import "IssueModel.h"
@implementation IssueChartListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCardItem{

    NSMutableArray *titleAry = [NSMutableArray new];
    if (self.model.dayAry.count>0) {
        IssueModel *dayModel =[self.model.dayAry firstObject];
        MineCellModel *day = [MineCellModel new];
        day.title =NSLocalizedString(@"local.dailyReport", @"");
        day.describeText = dayModel.createTime;
        day.identify = 1;
        [titleAry addObject:day];
    }
    if (self.model.webAry.count>0) {
        IssueModel *webModel =[self.model.webAry firstObject];
        MineCellModel *web = [MineCellModel new];
        web.title =NSLocalizedString(@"local.webSecurityReport", @"");
        web.describeText = webModel.createTime;
        web.identify = 2;
        [titleAry addObject:web];
    }
    if (self.model.serviceAry.count>0) {
        IssueModel *serviceModel =[self.model.serviceAry firstObject];
        MineCellModel *service = [MineCellModel new];
        service.title =NSLocalizedString(@"local.serviceReport", @"");
        service.describeText = serviceModel.createTime;
        service.identify = 3;
        [titleAry addObject:service];
       }
    
    for (NSInteger i=0; i<titleAry.count; i++) {
        UIView *item =[self creatItemWithData:titleAry[i]];
        item.frame = CGRectMake(0, ZOOM_SCALE(46)+i*ZOOM_SCALE(44), kWidth-Interval(32), ZOOM_SCALE(44));
        [self addSubview:item];
        if (i!=titleAry.count-1) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
            line.frame =CGRectMake(Interval(20), ZOOM_SCALE(44)-0.5, kWidth-Interval(72), SINGLE_LINE_WIDTH);
            [item addSubview:line];
           
        }
    }
}
- (UIView *)creatItemWithData:(MineCellModel *)data{
    UIView *item = [UIView new];
    item.tag = data.identify+500;
    [[self viewWithTag:data.identify+55] removeFromSuperview];
    item.backgroundColor = PWWhiteColor;
    UILabel *titleLab =[PWCommonCtrl lableWithFrame:CGRectMake(Interval(20), ZOOM_SCALE(12), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:data.title];
    [item addSubview:titleLab];
    UILabel *desLab =[PWCommonCtrl lableWithFrame:CGRectMake(kWidth-Interval(52)-ZOOM_SCALE(150), ZOOM_SCALE(12), ZOOM_SCALE(150), ZOOM_SCALE(20)) font:RegularFONT(11) textColor:[UIColor colorWithHexString:@"#595860"] text:[NSString getLocalDateFormateUTCDate:data.describeText formatter:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outdateFormatted:@"yyyy-MM-dd"]];

    desLab.textAlignment = NSTextAlignmentRight;
    [item addSubview:desLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
    [item addGestureRecognizer:tap];
    return item;
}
- (void)itemTap:(UITapGestureRecognizer *)tap{
    NSInteger i = tap.view.tag-500;
    if (self.block) {
        self.block(i);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
