//
//  MainViewCell.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/25.
//  Copyright © 2018 hll. All rights reserved.
//

#import "MineViewCell.h"
#import "MineCellModel.h"
#import "PrivacySecurityControls.h"

@interface MineViewCell()
@property (nonatomic, assign) MineVCCellType type;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UILabel *describeLab;
@property (nonatomic, strong) UIImageView *rightImg;
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
            [self createUIDescribe];
            break;
        case MineVCCellTypeOnlyTitle:
            [self createUIOnlyTitle];
            break;
        case MineVCCellTypeDot:
            [self createUIDot];
            break;
        case MineVCCellTypeImage:
            [self createUIImage];
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
-(void)createUIOnlyTitle{
    _arrowImgView.hidden = YES;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(Interval(16));
        make.height.offset(22);
        make.centerY.mas_equalTo(self.contentView);
    }];
    self.titleLab.text = _data.title;
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
- (void)createUIDescribe{
    self.describeLab.hidden = NO;
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
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab.mas_right).offset(10);
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
        make.centerY.mas_equalTo(self.titleLab);
        make.height.offset(20);
    }];
    self.describeLab.text = _data.describeText;
    //设置优先级(titleLab、describeLab 都没有设置width，为了防止一方长度过长，影响另一方的显示)
    [self.titleLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.describeLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

}
- (void)createUIDot{
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
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
        make.centerY.mas_equalTo(self.titleLab);
        make.height.offset(20);
        make.width.offset(20);
    }];
    self.describeLab.textColor = PWWhiteColor;
    self.describeLab.backgroundColor = [UIColor colorWithHexString:@"#FE563E"];
    self.describeLab.layer.cornerRadius = 10;
    self.describeLab.layer.masksToBounds = YES;
    self.describeLab.textAlignment = NSTextAlignmentCenter;
}
- (void)createUIImage{
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
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
        make.centerY.mas_equalTo(self.arrowImgView);
        make.width.height.offset(24);
    }];
    self.rightImg.layer.cornerRadius = 12.0f;
    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:_data.rightIcon] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
}
-(void)setTeamTradesSelect{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-Interval(16));
        make.width.height.offset(19);
    }];
    self.iconImgView.image = [UIImage imageNamed:@"team_success"];
}
#pragma mark ========== UI 懒加载 ==========
-(UIImageView *)iconImgView{
    if(!_iconImgView){
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, 30, 30)];
        CGPoint center = _iconImgView.center;
        _iconImgView.contentMode =  UIViewContentModeScaleAspectFit;
        center.y = self.center.y;
        _iconImgView.center = center;
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)describeLab{
    if (!_describeLab) {
        _describeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"8E8E93"] text:@""];
        _describeLab.textAlignment = NSTextAlignmentRight;
        _describeLab.hidden = YES;
        [self addSubview:_describeLab];
    }
    return _describeLab;
}
-(UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLab.font = RegularFONT(16);
        _titleLab.textColor = PWTextBlackColor;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]init];
        _rightImg.contentMode = UIViewContentModeScaleAspectFit;
        _rightImg.layer.cornerRadius  = 12;
        _rightImg.layer.masksToBounds = YES;
        [self addSubview:_rightImg];
    }
    return _rightImg;
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
-(void)setDescribeLabText:(NSString *)text{
    if (_describeLab) {
        if (self.type == MineVCCellTypeDot) {
            if ([text integerValue] > 0){
                self.describeLab.hidden = NO;
            }else{
                self.describeLab.hidden = YES;
            }
            if ([text integerValue] == 0) {
            }else if ([text integerValue]<9) {
                [self.describeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
                    make.centerY.mas_equalTo(self.titleLab);
                    make.height.offset(20);
                    make.width.offset(20);
                }];
                self.describeLab.text = text;
            }else if([text integerValue]<100){
                [self.describeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
                    make.centerY.mas_equalTo(self.titleLab);
                    make.height.offset(20);
                    make.width.offset(25);
                }];
                self.describeLab.text = text;
            }else{
                [self.describeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-Interval(8));
                    make.centerY.mas_equalTo(self.titleLab);
                    make.height.offset(20);
                    make.width.offset(28);
                }];
                self.describeLab.text = @"···";
            }
        }else{
            self.describeLab.hidden = NO;
        self.describeLab.text = text;
        self.describeLab.textColor = [UIColor colorWithHexString:@"8E8E93"];
        }
    }
    
}
-(void)setAlermDescribeLabText:(NSString *)text{
    if (_describeLab) {
        self.describeLab.hidden = NO;
        self.describeLab.textColor = PWBlueColor;
        self.describeLab.text = text;
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
