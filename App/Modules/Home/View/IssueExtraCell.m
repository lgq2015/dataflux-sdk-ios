//
//  IssueExtraCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueExtraCell.h"
#import "IssueExtraModel.h"

@interface IssueExtraCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *sizeLab;

@end
@implementation IssueExtraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(IssueExtraModel *)model{
    _model = model;
    self.iconView.image = [UIImage imageNamed:_model.fileIcon];
    self.titleLab.text = _model.fileName;
    if (self.titleLab.text.length>0) {
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(ZOOM_SCALE(5));
            make.left.mas_equalTo(self.iconView.mas_right).offset(Interval(13));
            make.height.offset(ZOOM_SCALE(20));
        }];
        [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(7));
            make.left.mas_equalTo(self.iconView.mas_right).offset(Interval(13));
            make.height.offset(ZOOM_SCALE(17));
        }];
    }else{
        [self.sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView);
            make.left.mas_equalTo(self.iconView.mas_right).offset(Interval(13));
            make.height.offset(ZOOM_SCALE(17));
        }];
    }
    self.sizeLab.text = _model.fileSize;
}

-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(5), ZOOM_SCALE(60), ZOOM_SCALE(60))];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTextBlackColor text:@""];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)sizeLab{
    if (!_sizeLab) {
        _sizeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWSubTitleColor text:@""];
        [self.contentView addSubview:_sizeLab];
    }
    return _sizeLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
