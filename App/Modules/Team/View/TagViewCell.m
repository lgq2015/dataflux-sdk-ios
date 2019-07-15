//
//  TagViewCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TagViewCell.h"
#import "RuleModel.h"
@interface TagViewCell()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *keyTf;
@property (nonatomic, strong) UITextField *valueTf;
@end
@implementation TagViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    self.titleLab.text = NSLocalizedString(@"local.ruleTag", @"");
    

    [self.keyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(6);
        make.right.mas_equalTo(self).offset(-16);
        make.height.offset(ZOOM_SCALE(22));
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.keyTf.mas_bottom).offset(8);
        make.height.offset(SINGLE_LINE_WIDTH);
        make.right.mas_equalTo(self);
    }];
    [self.valueTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-16);
        make.height.mas_equalTo(self.keyTf);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.left.mas_equalTo(self.keyTf);
    }];
}
-(void)setModel:(RuleModel *)model{
    _model = model;
    if ([model.tags allKeys].count>0) {
        self.keyTf.text = [[model.tags allKeys] firstObject];
        self.valueTf.text =  [model.tags stringValueForKey:[[model.tags allKeys] firstObject] default:@""];
    }
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(10), kWidth-Interval(32), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTitleColor text:@""];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
-(UITextField *)keyTf{
    if (!_keyTf) {
        _keyTf = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(16)];
        _keyTf.placeholder = NSLocalizedString(@"local.pleaseInputTagKey", @"");
        _keyTf.delegate = self;
        [self addSubview:_keyTf];
    }
    return _keyTf;
}
-(UITextField *)valueTf{
    if (!_valueTf) {
        _valueTf = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(16)];
        _valueTf.placeholder = NSLocalizedString(@"local.pleaseInputTagValue", @"");
        _valueTf.delegate = self;
        [self addSubview:_valueTf];
    }
    return _valueTf;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    WeakSelf
    if (self.TagBlock) {
        self.TagBlock(weakSelf.keyTf.text, weakSelf.valueTf.text);
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSString *key = self.keyTf.text;
    NSString *value = self.valueTf.text;
    if ([textField isEqual:self.keyTf]) {
        key = @"";
    }else{
        value = @"";
    }
    
    if (self.TagBlock) {
        self.TagBlock(key, value);
    }
    return YES;
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
