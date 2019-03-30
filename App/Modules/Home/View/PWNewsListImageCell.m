//
//  PWNewsListImageCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWNewsListImageCell.h"

@implementation PWNewsListImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(NewsListModel *)model{
    [super setModel:model];
}

-(void)layoutIfNeeded{
    self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(32)-ZOOM_SCALE(90);
    self.titleLab.numberOfLines = 3;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-Interval(20));
        make.top.mas_equalTo(self.contentView).offset(Interval(11));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
    }];
    self.iconImgVie.hidden = NO;
    [self.iconImgVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(90));
    }];
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
    if (self.model.isStarred) {
        self.timeLab.hidden = YES;
        self.topStateLab.hidden =NO;
        [self.topStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.top.mas_equalTo(self.iconImgVie.mas_bottom);
            make.width.offset(ZOOM_SCALE(40));
            make.height.offset(ZOOM_SCALE(22));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }else{
        self.timeLab.hidden = NO;
        self.topStateLab.hidden = YES;
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(Interval(16));
            make.right.mas_equalTo(self.contentView).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(17));
            make.bottom.mas_equalTo(self.contentView).offset(-Interval(8));
        }];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
