//
//  HandbookCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HandbookCell.h"
@interface HandbookCell()
@property (nonatomic, strong) UIImageView *iconImgVie;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *sourceLab;
@property (nonatomic, strong) UILabel *timeLab;
@end
@implementation HandbookCell
-(void)setFrame:(CGRect)frame{
    frame.size.height -= 4;
    [super setFrame:frame];
}
-(void)setModel:(HandbookModel *)model{
    _model = model;
    if ([_model.imageUrl isEqualToString:@""]) {
        [self createTextUI];
    }else{
        [self createSingleImgUI];
    }
    self.timeLab.hidden = YES;
}
- (void)createTextUI{
    self.iconImgVie.hidden = YES;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(20));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.titleLab.text = self.model.title;
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(40));
    }];
    self.subtitleLab.text = self.model.summary;
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLab.mas_bottom).offset(Interval(8));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(17));
    }];
    self.timeLab.text = self.model.updateTime;
    self.timeLab.hidden = YES;
}
- (void)createSingleImgUI{
    self.iconImgVie.hidden = NO;
    [self.iconImgVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ZOOM_SCALE(105));
        make.height.offset(ZOOM_SCALE(91));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.iconImgVie sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageWithColor:PWBackgroundColor]];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(Interval(20));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-Interval(5));
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.titleLab.text = self.model.title;
    [self.subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(6));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.iconImgVie.mas_left).offset(-Interval(5));
        make.height.offset(ZOOM_SCALE(40));
    }];
    self.subtitleLab.text = self.model.summary;
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleLab.mas_bottom).offset(Interval(8));
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(17));
    }];
    self.timeLab.text = self.model.updateTime;
    self.timeLab.hidden = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UIImageView *)iconImgVie{
    if (!_iconImgVie) {
        _iconImgVie = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImgVie.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgVie.backgroundColor = [UIColor whiteColor];
        _iconImgVie.clipsToBounds = YES;
        [self.contentView addSubview:_iconImgVie];
    }
    return _iconImgVie;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        _timeLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)subtitleLab{
    if (!_subtitleLab){
        _subtitleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _subtitleLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        _subtitleLab.font = [UIFont systemFontOfSize:14.0f];
        _subtitleLab.numberOfLines = 2;
        [self.contentView addSubview:_subtitleLab];
    }
    return _subtitleLab;
}
-(UILabel *)sourceLab{
    if (!_sourceLab) {
        _sourceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _sourceLab.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1/1.0];
        _sourceLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_sourceLab];
    }
    return _sourceLab;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
