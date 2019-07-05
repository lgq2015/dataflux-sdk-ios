//
//  ZTTeamVCTopCell.m
//  App
//
//  Created by tao on 2019/5/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTTeamVCTopCell.h"
#define leftMargin 30.0
@interface ZTTeamVCTopCell()
@property (nonatomic, strong)NSMutableArray *labs;
@property (nonatomic, assign)TeamTopType type;
@end
@implementation ZTTeamVCTopCell


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self s_UI];
}

//- (void)s_UI{
//    NSArray *iconAry = @[@"team_invite",@"team_infos",@"team_management",@"team_record"];
//    NSArray *btnName = @[@"邀请成员",@"云服务",@"团队管理",@"服务"];
//    NSMutableArray *imageViews = [NSMutableArray array];
//    _labs = [NSMutableArray array];
//    for (NSInteger i = 0;i<iconAry.count;i++){
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.image = [UIImage imageNamed:iconAry[i]];
//        imgView.tag = 10 + i;
//        imgView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
//        [imgView addGestureRecognizer:tap];
//        [self.contentView addSubview:imgView];
//        UILabel *lab = [[UILabel alloc] init];
//        lab.text = btnName[i];
//        lab.font = RegularFONT(13);
//        lab.textColor = PWTitleColor;
//        lab.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:lab];
//        [imageViews addObject:imgView];
//        [_labs addObject:lab];
//    }
//    //布局
//    CGFloat imgViewW = ZOOM_SCALE(34);
//    CGFloat imgViewMargin = (kWidth-ZOOM_SCALE(34)*4-30*2)/3.0;
//    for (NSInteger i = 0; i< imageViews.count; i++){
//        //布局图片
//        UIImageView *imgV = imageViews[i];
//        if (i == 0){
//            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView).offset(30);
//                make.top.mas_equalTo(self.contentView).offset(25);
//                make.width.height.offset(imgViewW);
//            }];
//        }else{
//            UIImageView *lastImgV = imageViews[i - 1];
//            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(lastImgV.mas_right).offset(imgViewMargin);
//                make.centerY.mas_equalTo(lastImgV);
//                make.width.height.offset(imgViewW);
//            }];
//        }
//        //布局文字
//        UILabel *lab = _labs[i];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(imgV.mas_bottom).offset(Interval(8));
//            make.centerX.mas_equalTo(imgV);
//            make.width.offset(ZOOM_SCALE(55));
//            make.height.offset(ZOOM_SCALE(18));
//        }];
//    }
//}
//
////计算cell内容的总高度
//- (CGFloat)caculateRowHeight{
//    [self layoutIfNeeded];
//    UILabel *firstLab = _labs[0];
//    CGFloat heigth = CGRectGetMaxY(firstLab.frame) + 26;
//    return heigth ;
//}
////点击了图片
//- (void)tapImg:(UITapGestureRecognizer *)ges{
//    UIImageView *imgV = (UIImageView *)ges.view;
//
//    switch (imgV.tag) {
//        case 10:
//            _type = inviteMemberType;
//            break;
//        case 11:
//            _type = cloudServerType;
//            break;
//        case 12:
//            _type = teamManagerType;
//            break;
//        case 13:
//            _type = server;
//            break;
//        default:
//            break;
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTeamTopCell:withType:)]){
//        [self.delegate didClickTeamTopCell:self withType:_type];
//    }
//}
- (void)s_UI{
    NSArray *iconAry = @[@"team_invite",@"team_infos",@"team_management",@"team_management"];
    NSArray *btnName = @[@"邀请成员",@"云服务",@"团队管理",@"通知规则"];
    NSMutableArray *imageViews = [NSMutableArray array];
    _labs = [NSMutableArray array];
    for (NSInteger i = 0;i<iconAry.count;i++){
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:iconAry[i]];
        imgView.tag = 10 + i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        [imgView addGestureRecognizer:tap];
        [self.contentView addSubview:imgView];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = btnName[i];
        lab.font = RegularFONT(13);
        lab.textColor = PWTitleColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:lab];
        [imageViews addObject:imgView];
        [_labs addObject:lab];
    }
    //布局
    CGFloat imgViewW = ZOOM_SCALE(34);
    CGFloat imgViewMargin = (kWidth-ZOOM_SCALE(34)*4-leftMargin*2)/3.0;
    for (NSInteger i = 0; i< imageViews.count; i++){
        //布局图片
        UIImageView *imgV = imageViews[i];
        if (i == 0){
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(leftMargin);
                make.top.mas_equalTo(self.contentView).offset(25);
                make.width.height.offset(imgViewW);
            }];
        }else{
            UIImageView *lastImgV = imageViews[i - 1];
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastImgV.mas_right).offset(imgViewMargin);
                make.centerY.mas_equalTo(lastImgV);
                make.width.height.offset(imgViewW);
            }];
        }
        //布局文字
        UILabel *lab = _labs[i];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgV.mas_bottom).offset(Interval(8));
            make.centerX.mas_equalTo(imgV);
            make.width.offset(ZOOM_SCALE(55));
            make.height.offset(ZOOM_SCALE(18));
        }];
    }
}

//计算cell内容的总高度
- (CGFloat)caculateRowHeight{
    [self layoutIfNeeded];
    UILabel *firstLab = _labs[0];
    CGFloat heigth = CGRectGetMaxY(firstLab.frame) + 26;
    return heigth ;
}
//点击了图片
- (void)tapImg:(UITapGestureRecognizer *)ges{
    UIImageView *imgV = (UIImageView *)ges.view;
    
    switch (imgV.tag) {
        case 10:
            _type = inviteMemberType;
            break;
        case 11:
            _type = cloudServerType;
            break;
        case 12:
            _type = teamManagerType;
            break;
        case 13:
            _type = server;
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTeamTopCell:withType:)]){
        [self.delegate didClickTeamTopCell:self withType:_type];
    }
}


@end
