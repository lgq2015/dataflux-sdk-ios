//
//  AddNotiRuleCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddNotiRuleCell.h"
#import "AddNotiRuleModel.h"
#import "UITextField+HLLHelper.h"

@interface AddNotiRuleCell()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UITextField *subTf;
@end
@implementation AddNotiRuleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initSubView{
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
    arrow.frame = CGRectMake(kWidth-ZOOM_SCALE(10)-Interval(16), (self.height-ZOOM_SCALE(16))/2.0, ZOOM_SCALE(10), ZOOM_SCALE(16));
    arrow.tag = 22;
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-16);
        make.width.offset(ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(16));
    }];
}
-(void)setModel:(AddNotiRuleModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    self.subTitleLab.text = model.subTitle;
    self.subTitleLab.textColor = PWTextBlackColor;
   
    self.subTitleLab.hidden = self.isTF;
    self.subTf.hidden = !self.isTF;
    self.subTf.text = model.subTitle;
    [self viewWithTag:22].hidden = self.isTF;
    if ([model.subTitle isEqualToString:@""]) {
        self.subTitleLab.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
        self.subTitleLab.text = model.placeholderText;
        self.subTf.placeholder = model.placeholderText;
    }
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(10), kWidth-Interval(32), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(10)+ZOOM_SCALE(25), kWidth-Interval(32), ZOOM_SCALE(20)) font:RegularFONT(16) textColor:PWSubTitleColor text:@""];
        [self addSubview:_subTitleLab];
    }
    return _subTitleLab;
}
-(UITextField *)subTf{
    if (!_subTf) {
        _subTf = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), Interval(10)+ZOOM_SCALE(25), kWidth-Interval(32), ZOOM_SCALE(20)) font:RegularFONT(16)];
        _subTf.hll_limitTextLength = 30;
        _subTf.placeholder = NSLocalizedString(@"local.pleaseInputRuleName", @"");
        _subTf.delegate = self;
        [self addSubview:_subTf];
    }
    return _subTf;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
        WeakSelf
        if (self.ruleNameClick) {
            self.ruleNameClick(weakSelf.subTf.text);
        }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.ruleNameClick) {
        self.ruleNameClick(@"");
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
