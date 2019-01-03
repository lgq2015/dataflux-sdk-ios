//
//  MainViewCell.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/25.
//  Copyright © 2018 hll. All rights reserved.
//

#import "MainViewCell.h"
#import "MineCellModel.h"
@interface MainViewCell()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *arrowImgView;
@end
@implementation MainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setData:(MineCellModel *)data{
    _data = data;
    self.iconImgView.image = [UIImage imageNamed:_data.icon];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView).offset(30);
        make.height.offset(22);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    self.titleLab.text = _data.title;
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.width.offset(20);
        make.height.offset(20);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
}
-(UIImageView *)iconImgView{
    if(!_iconImgView){
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, 20, 20)];
        CGPoint center = _iconImgView.center;
        center.y = self.center.y;
        _iconImgView.center = center;
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = PWTextColor;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nest"]];
        [self addSubview:_arrowImgView];
    }
    return _arrowImgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
