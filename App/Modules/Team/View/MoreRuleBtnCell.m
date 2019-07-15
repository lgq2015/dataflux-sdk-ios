//
//  MoreRuleBtnCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MoreRuleBtnCell.h"
@interface MoreRuleBtnCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation MoreRuleBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = _titleStr;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
}
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"link_add"]];
        [self addSubview:_icon];
    }
    return _icon;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(26+ZOOM_SCALE(16), ZOOM_SCALE(11), ZOOM_SCALE(160), ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWBlueColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
