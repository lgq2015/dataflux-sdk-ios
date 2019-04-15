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
    count.font = RegularFONT(13);
    count.textColor = [UIColor colorWithHexString:@"8E8E93"];
    count.textAlignment = NSTextAlignmentRight;
    [self.describeView addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.describeView).offset(-Interval(5));
        make.height.offset(ZOOM_SCALE(20));
        make.bottom.mas_equalTo(self.describeView).offset(-Interval(10));
    }];
    [[self.describeTextView rac_textSignal] subscribeNext:^(NSString *text) {
       
        NSInteger len = [text charactorNumber];
        if (len>2000) {
            [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
            text=[text subStringWithLength:2000];
            self.describeTextView.text = text;
            len = [text charactorNumber];
        }
        count.text = [NSString stringWithFormat:@"%ld/1000",len/2];
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeView.mas_bottom).offset(Interval(35));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    RACSignal *text = [[self.describeTextView rac_textSignal]map:^id(NSString *value) {
        return @(value.length>0);
    }];
    RAC(self.commitBtn,enabled) = text;
}
-(UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"提交"];
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
        _describeTextView = [PWCommonCtrl textViewWithFrame:CGRectZero placeHolder:@"我们很重视您的宝贵建议，请在此输入。" font:RegularFONT(14)];
//        _describeTextView.font =RegularFONT(14);
        [self.describeView addSubview:_describeTextView];
    }
    return _describeTextView;
}
- (void)commitBtnClick{
  
        [SVProgressHUD show];
        NSDictionary *param = @{@"data":@{@"content":self.describeTextView.text}};
        [PWNetworking requsetHasTokenWithUrl:PW_addFeedback withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"提交失败"];
        }];
    
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
