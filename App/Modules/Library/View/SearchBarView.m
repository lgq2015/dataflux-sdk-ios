//
//  SearchBarView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SearchBarView.h"
@interface SearchBarView()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchTF;
@end
@implementation SearchBarView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = PWLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.left.right.mas_equalTo(self);
        make.height.offset(1);
    }];
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectZero];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
    searchView.layer.cornerRadius = 4.0f;
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.width.offset(ZOOM_SCALE(290));
        make.height.offset(36);
        make.bottom.mas_equalTo(self).offset(-Interval(3));
    }];
    UIButton *cancle = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:NSLocalizedString(@"local.cancel", @"")];
    [cancle addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancle setTitleColor:PWBlueColor forState:UIControlStateNormal];
    [self addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.right.mas_equalTo(self).offset(-Interval(14));
        make.height.offset(ZOOM_SCALE(22));
    }];
    UIButton *iconBtn = [[UIButton alloc]init];
    [iconBtn setImage:[UIImage imageNamed:@"icon_search_gray"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchView).offset(5);
        make.width.height.offset(30);
    }];
    [self addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconBtn.mas_right).offset(3);
        make.centerY.mas_equalTo(iconBtn);
        make.right.mas_equalTo(searchView);
        make.height.mas_equalTo(searchView);
    }];
    [self.searchTF becomeFirstResponder];
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    self.searchTF.placeholder = placeHolder;
}
-(void)setSearchText:(NSString *)searchText{
    self.searchTF.text = searchText;
    [self.searchTF resignFirstResponder];
}
- (void)setIsSynchronous:(BOOL)isSynchronous{
    if (isSynchronous) {
        WeakSelf
        [[self.searchTF rac_textSignal] subscribeNext:^(NSString *x) {
            if (x.length>0) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(synchronousSearchText:)]) {
                    [weakSelf.delegate synchronousSearchText:x];
                }
            }
       }];
    }
}
- (void)setIsClear:(BOOL)isClear{
    if (isClear) {
        WeakSelf
        [[self.searchTF rac_textSignal] subscribeNext:^(NSString *x) {
            if (x.length == 0) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(textFiledClear)]) {
                    [weakSelf.delegate textFiledClear];
                }
            }
        }];
    }
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [PWCommonCtrl textFieldWithFrame:CGRectZero font:RegularFONT(14)];
        _searchTF.delegate = self;
    }
    return  _searchTF;
}
- (void)cancleBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleBtnClick)]) {
        [self.delegate cancleBtnClick];
    }
}
- (void)searchClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchWithText:)]) {
        [self.delegate searchWithText:self.searchTF.text];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField.text.length != 0){
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchWithText:)]) {
            [self.delegate searchWithText:self.searchTF.text];
        }
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
