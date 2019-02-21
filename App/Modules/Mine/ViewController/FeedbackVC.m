//
//  FeedbackVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()
@property (nonatomic, strong) UIView *describeView;
@property (nonatomic, strong) UITextView *describeTextView;

@property (nonatomic, strong) UIButton *commitBtn;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见与反馈";
    [self createUI];
}
- (void)createUI{
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(Interval(12));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(250));
    }];
    [self.describeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeView).offset(Interval(5));
        make.left.mas_equalTo(self.describeView).offset(Interval(9));
        make.right.mas_equalTo(self.describeView).offset(-Interval(9));
        make.bottom.mas_equalTo(self.describeView).offset(-Interval(30));
    }];
    
    UILabel *count = [[UILabel alloc]init];
    count.text = @"0/1000";
    count.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    count.textColor = [UIColor colorWithHexString:@"8E8E93"];
    count.textAlignment = NSTextAlignmentRight;
    [self.describeView addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.describeView).offset(-Interval(5));
        make.height.offset(ZOOM_SCALE(20));
        make.bottom.mas_equalTo(self.describeView).offset(-Interval(10));
    }];
    [[self.describeTextView rac_textSignal] subscribeNext:^(NSString *text) {
        if (text.length>1000) {
            text = [text substringToIndex:1000];
            self.describeTextView.text = text;
        }
        count.text = [NSString stringWithFormat:@"%lu/1000",(unsigned long)text.length];
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeView.mas_bottom).offset(Interval(35));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc]init];
        [_commitBtn setBackgroundColor:PWBlueColor];
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 4.0f;
        [_commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_commitBtn];
    }
    return _commitBtn;
}
-(UIView *)describeView{
    if (!_describeView) {
        _describeView = [[UIView alloc]init];
        _describeView.backgroundColor = PWWhiteColor;
        _describeView.layer.cornerRadius = 8.0f;
        [self.view addSubview:_describeView];
    }
    return _describeView;
}
-(UITextView *)describeTextView{
    if (!_describeTextView) {
        _describeTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"我们很重视您的宝贵建议，请在此输入。" font:MediumFONT(14)];
//        _describeTextView.font =MediumFONT(14);
        [self.describeView addSubview:_describeTextView];
    }
    return _describeTextView;
}
- (void)commitBtnClick{
    if (self.describeTextView.text.length == 0) {
        [iToast alertWithTitleCenter:@"请填写您的宝贵意见！"];
    }else{
        NSDictionary *param = @{@"data":@{@"content":self.describeTextView.text}};
        [PWNetworking requsetHasTokenWithUrl:PW_addFeedback withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
