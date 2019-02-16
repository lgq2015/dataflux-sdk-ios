//
//  MainViewCell.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/25.
//  Copyright © 2018 hll. All rights reserved.
//

#import "MineViewCell.h"
#import "MineCellModel.h"
@interface MineViewCell()
@property (nonatomic, assign) MineVCCellType type;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *arrowImgView;
@end
@implementation MineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initWithData:(MineCellModel *)data type:(MineVCCellType)type{
        self.data = data;
        self.type = type;
        [self createUI];
    
}
-(void)createUI{
    switch (self.type) {
        case MineVCCellTypeBase:
            [self createUIBase];
            break;
       case MineVCCellTypeTitle:
            [self createUITitle];
            break;
       case MineVCCellTypeButton:
            [self createUIButton];
            break;
       case MineVCCellTypeSwitch:
            [self createUISwitch];
            break;
        case MineVCCellTypedDescribe:
            
            break;
    }
}
#pragma mark ========== 有icon、title ==========
- (void)createUIBase{

    self.iconImgView.image = [UIImage imageNamed:_data.icon];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.height.offset(22);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
    self.titleLab.text = _data.title;
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.width.offset(16);
        make.height.offset(16);
        make.centerY.mas_equalTo(self.iconImgView);
    }];
}
#pragma mark ========== 只有title ==========
- (void)createUITitle{
    _arrowImgView.hidden = NO;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Interval(16));
        make.height.offset(22);
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.titleLab.text = _data.title;
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-15);
        make.width.offset(16);
        make.height.offset(16);
        make.centerY.mas_equalTo(self.titleLab);
    }];
}
#pragma mark ========== 退出按钮 ==========
- (void)createUIButton{
    _arrowImgView.hidden = YES;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.text = @"退出";
    self.titleLab.textColor = PWOrangeTextColor;
    
}
#pragma mark ========== title 、 switch ==========
- (void)createUISwitch{
    _arrowImgView.hidden = NO;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(18);
        make.height.offset(22);
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.titleLab.text = _data.title;
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-18);
        make.centerY.mas_equalTo(self.titleLab);
    }];
    [self.switchBtn setOn:self.data.isOn];
    [self.switchBtn addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
}
#pragma mark ========== UI 懒加载 ==========
-(UIImageView *)iconImgView{
    if(!_iconImgView){
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, 30, 30)];
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
        _titleLab.font = MediumFONT(16);
        _titleLab.textColor = PWTextBlackColor;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_arrowImgView];
    }
    return _arrowImgView;
}
-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc]initWithFrame:CGRectZero];
        [self addSubview:_switchBtn];
    }
    return _switchBtn;
}
- (void)valueChanged:(UISwitch *)sender{
    DLog(@"%d",sender.isOn);
    if (self.switchChange) {
        self.switchChange(sender.isOn);
    }
}
-(void)setSwitchBtnisOn:(BOOL)ison{
    [self.switchBtn setOn:ison];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
