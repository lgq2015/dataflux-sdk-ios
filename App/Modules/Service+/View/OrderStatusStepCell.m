//
//  OrderStatusStepCell.m
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "OrderStatusStepCell.h"
#define titleLabLeftMargin 16
#define titleLabRightMargin 16
@interface OrderStatusStepCell()
@end
@implementation OrderStatusStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(FounctionIntroductionModel *)model{
    NSLog(@"子控件的数量---%ld",self.subviews.count);
    _model = model;
    NSArray *titles = @[@"上云迁移实施上云迁移实施上云迁移实施上云迁移实施上云迁移实施",@"互联网应用托管服务互联网应用托管服务互联网应用托管服务互联网应用托管服务互联网应用托管服务",@"云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入云资源（消费）-财务倒入"];
    NSArray *times = @[@"2019/01/01-2019/10/10",@"2019/01/01-2019/10/10",@"2019/01/01-2019/10/10"];
    times = @[];
    //排除复用cell的干扰
    [self.contentView removeAllSubviews];
    //添加子控件
    [self createSubViews:times withTitles:titles];
}

- (void)createSubViews:(NSArray *)times withTitles:(NSArray *)titles{
    for (NSInteger i = 0; i<titles.count; i++) {
        //创建titlelab
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = RegularFONT(16);
        titleLab.text = titles[i];
        titleLab.tag = 100 + i;
        titleLab.numberOfLines = 0;
        titleLab.textColor = [UIColor colorWithHexString:@"#140F26"];
        [self.contentView addSubview:titleLab];
        //创建timelab
        UILabel *timeLab = nil;
        if (times.count > 0){
            timeLab = [[UILabel alloc] init];
            timeLab.text = times[i];
            timeLab.font = RegularFONT(14);
            timeLab.tag = 200 + i;
            timeLab.textColor = [UIColor colorWithHexString:@"#8E8E93"];
            [self.contentView addSubview:timeLab];
        }
        //创建分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [self.contentView addSubview:line];
        //布局子控件
        if (i == 0){
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(titleLabLeftMargin);
                make.top.equalTo(self.contentView).offset(20);
                make.right.equalTo(self.contentView).offset(-titleLabRightMargin);
            }];
        }else{
            //找到上一个titleLab
            UILabel *lastTitleLab = [self.contentView viewWithTag:100 + i - 1];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(titleLabLeftMargin);
                make.top.equalTo(lastTitleLab.mas_bottom).offset(35);
                make.right.equalTo(self.contentView).offset(-titleLabRightMargin);
            }];
        }
        if (timeLab != nil){
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLab.mas_left);
                make.top.equalTo(titleLab.mas_bottom).offset(3);
            }];
        }
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@1);
            make.width.equalTo(self.contentView.mas_width);
            make.left.equalTo(self.contentView.mas_left);
        }];
    }
}

@end
