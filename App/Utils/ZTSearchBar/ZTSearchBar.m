//
//  ZTSearchBar.m
//  123
//
//  Created by tao on 2019/4/21.
//  Copyright © 2019 shitu. All rights reserved.
//

#import "ZTSearchBar.h"
#import <Masonry.h>
#define kWidth     [UIScreen mainScreen].bounds.size.width
#define tfH    36.0
#define leftMargin 16.0
#define centerBtnWidth 100.0
#define leftSearchBtnW 36.0
#define cancelBtnW 60.0
@interface ZTSearchBar()<UITextFieldDelegate>
@property (nonatomic, strong)UIButton *centerBtn;
@property (nonatomic, strong)UIButton *leftSearchBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@end
@implementation ZTSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self addSubview:self.cancelBtn];
    [self addSubview:self.tf];
    [self.tf addSubview:self.centerBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self);
        make.width.equalTo(@0);
        make.height.equalTo(@tfH);
    }];
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@tfH);
        make.left.equalTo(self).offset(leftMargin);
        make.right.equalTo(self.cancelBtn.mas_left).offset(-leftMargin);
    }];
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.tf);
        make.width.mas_equalTo(@centerBtnWidth);
        make.height.mas_equalTo(self.tf);
    }];
   
    
}
- (UITextField *)tf{
    if (!_tf){
        _tf = [[UITextField alloc] init];
        _tf.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        _tf.delegate = self;
        _tf.layer.cornerRadius = 4.0f;
        _tf.layer.masksToBounds = YES;
        _tf.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return _tf;
}
- (UIButton *)centerBtn{
    if (!_centerBtn){
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        [_centerBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_centerBtn setTitleColor:[UIColor colorWithHexString:@"#8E8E93"] forState:UIControlStateNormal];
        _centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        _centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _centerBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _centerBtn.userInteractionEnabled = NO;
    }
    return _centerBtn;
}
- (UIButton *)leftSearchBtn{
    if (!_leftSearchBtn){
        _leftSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftSearchBtn.frame = CGRectMake(0, 0, leftSearchBtnW, self.tf.bounds.size.height);
        [_leftSearchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    }
    return _leftSearchBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:NSLocalizedString(@"local.cancel", @"") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#027DFB"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.hidden = YES;
    }
    return _cancelBtn;
}
#pragma mark ====内部事件===========
- (void)cancelClick:(UIButton *)sender{
    _tf.text = @"";
    [_tf resignFirstResponder];
    if (self.cancleClick) {
        self.cancleClick();
    }
}

#pragma mark ====UITextFieldDelegate===
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.centerBtn.hidden = YES;
    self.tf.leftView = self.leftSearchBtn;
    self.tf.placeholder = @"搜索";
    self.tf.leftViewMode =  UITextFieldViewModeAlways;
    [UIView animateWithDuration:0.15 animations:^{
        self.cancelBtn.hidden = NO;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@cancelBtnW);
        }];
        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cancelBtn.mas_left);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tf.placeholder = @"";
    self.centerBtn.hidden = NO;
    self.tf.leftView = nil;
    self.tf.leftViewMode =  UITextFieldViewModeNever;
    [UIView animateWithDuration:0.15 animations:^{
        self.cancelBtn.hidden = YES;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@0);
        }];
        [self.tf mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cancelBtn.mas_left).offset(-leftMargin);
            make.left.mas_equalTo(self).offset(leftMargin);
        }];
        [self layoutIfNeeded];
    }];
}

@end
