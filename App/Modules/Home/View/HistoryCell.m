//
//  HistoryCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HistoryCell.h"
@interface HistoryCell()
@property (nonatomic, strong) UILabel *titleLab;

@end
@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_history"]];
//    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(Interval(16));
        make.width.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(self.contentView);
    }];
    UIButton *delect = [[UIButton alloc]init];
    [delect setImage:[UIImage imageNamed:@"handbook_x"] forState:UIControlStateNormal];
    [delect addTarget:self action:@selector(delectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:delect];
    [delect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(24));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(20));
        make.right.mas_equalTo(delect.mas_left).offset(-5);
    }];
    
   
}
-(void)delectBtnClick{
    if (self.delectClick) {
        self.delectClick();
    }
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:@""];
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
