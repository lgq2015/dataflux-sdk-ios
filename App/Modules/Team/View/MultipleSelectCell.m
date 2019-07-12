//
//  MultipleSelectCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MultipleSelectCell.h"
#import "MultipleSelectModel.h"
@interface MultipleSelectCell()
@property (nonatomic, strong) UIImageView *selectIcon;
@property (nonatomic, strong) UILabel *titleLab;
@end
@implementation MultipleSelectCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.width.height.offset(ZOOM_SCALE(19));
        make.centerY.mas_equalTo(self);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectIcon.mas_right).offset(34);
        make.centerY.mas_equalTo(self.selectIcon);
        make.right.mas_equalTo(self).offset(-16);
        make.height.offset(ZOOM_SCALE(22));
    }];
}
-(void)setCellModel:(MultipleSelectModel *)cellModel{
    _cellModel = cellModel;
    if(cellModel.isSelect){
        self.selectIcon.image = [UIImage imageNamed:@"team_success"];
    }else{
        self.selectIcon.image = [UIImage imageNamed:@"icon_noSelect"];
    }
    self.titleLab.text = cellModel.name;
}
-(UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc]init];
        [self addSubview:_selectIcon];
    }
    return _selectIcon;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:[UIColor colorWithHexString:@"#373D41"] text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
