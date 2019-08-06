//
//  NoAssignCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "NoAssignCell.h"

@implementation NoAssignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MemberInfoModel *)model{
    _model = model;
    if (model.name.length==0) {
    UIImageView *selImage = [[UIImageView alloc]init];
    selImage.tag = 55;
    [[self.contentView viewWithTag:55] removeFromSuperview];
    [self.contentView addSubview:selImage];
    [selImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.width.height.offset(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    selImage.userInteractionEnabled = YES;
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:NSLocalizedString(@"local.NotAssigned", @"")];
    titleLab.tag = 34;
    [[self.contentView viewWithTag:34] removeFromSuperview];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(selImage.mas_right).offset(Interval(13));
        make.height.offset(ZOOM_SCALE(22));
        make.centerY.mas_equalTo(selImage);
        make.width.lessThanOrEqualTo([NSNumber numberWithFloat:ZOOM_SCALE(190)]);
    }];
    
    
    if(model.isSelect){
        selImage.image = [UIImage imageNamed:@"team_success"];
    }else{
        selImage.image = [UIImage imageNamed:@"icon_noSelect"];
    }
    }else{
        [[self.contentView viewWithTag:33] removeFromSuperview];
        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(16, 0, 200, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:model.name];
        title.tag = 33;
        title.centerY = self.contentView.centerY;
        [self.contentView addSubview:title];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SINGLE_LINE_WIDTH)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        [self.contentView addSubview:line];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
