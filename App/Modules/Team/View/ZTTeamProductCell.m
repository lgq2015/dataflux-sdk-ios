//
//  ZTTeamProductCell.m
//  App
//
//  Created by tao on 2019/5/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTTeamProductCell.h"
@interface ZTTeamProductCell()
@property (nonatomic, strong)NSMutableArray *productLabs;
@end
@implementation ZTTeamProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setTeamProduct:(NSArray *)product{
    [self.contentView removeAllSubviews];
    NSMutableArray *dots = [NSMutableArray array];
    _productLabs = [NSMutableArray array];
    for (NSInteger i = 0; i < product.count; i++)  {
        NSDictionary *dict = product[i];
        NSDictionary *displayString = dict[@"displayString"];
        //添加点
        UIView *dot = [[UIView alloc]init];
        dot.backgroundColor = [UIColor colorWithHexString:@"72A2EE"];
        dot.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:dot];
        [dots addObject:dot];
        //添加产品及餐产品数
        UILabel *productLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTitleColor text:[displayString stringValueForKey:@"name" default:@""]];
        UILabel *productNumLab =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWBlueColor text:[displayString stringValueForKey:@"value" default:@""]];
        [self.contentView addSubview:productLab];
        [self.contentView addSubview:productNumLab];
        [_productLabs addObject:productLab];
        if (i == 0) {
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(16);
                make.top.mas_equalTo(self.contentView).offset(17);
                make.width.height.offset(ZOOM_SCALE(8));
            }];
        }else{
            //获取上一个点
            UIView *lastDot = dots[i - 1];
            [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(16);
                make.top.mas_equalTo(lastDot.mas_bottom).offset(16);
                make.width.height.offset(ZOOM_SCALE(8));
            }];
        }
        [productLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dot.mas_right).offset(Interval(8));
            make.centerY.mas_equalTo(dot);
        }];
        [productNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productLab.mas_right).offset(10);
            make.centerY.mas_equalTo(productLab);
        }];
    }
}
//计算cell内容的总高度
- (CGFloat)caculateProductCellRowHeight{
    [self layoutIfNeeded];
    UILabel *lastLab = _productLabs.lastObject;
    CGFloat heigth = CGRectGetMaxY(lastLab.frame) + 18;
    return heigth ;
}

@end
