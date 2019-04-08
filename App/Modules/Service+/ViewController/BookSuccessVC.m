//
//  BookSuccessVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BookSuccessVC.h"
#import <TTTAttributedLabel.h>

@interface BookSuccessVC ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) TTTAttributedLabel *tipsLab;
@end

@implementation BookSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.view.backgroundColor = PWBackgroundColor;
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    navView.backgroundColor = PWWhiteColor;
    [self.view addSubview:navView];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:@"预约成功"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLab];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [navView addSubview:line];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(navView).offset(kTopHeight-42);
        make.height.offset(42);
        make.left.right.mas_equalTo(navView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(navView);
        make.bottom.mas_equalTo(navView).offset(-1);
        make.height.offset(1);
    }];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
    contentView.backgroundColor = PWWhiteColor;
    [self.view addSubview:contentView];
    UIImageView *successIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_success"]];
    [contentView addSubview:successIcon];
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(Interval(55));
        make.height.with.offset(ZOOM_SCALE(80));
        make.centerX.mas_equalTo(contentView);
    }];
    UILabel *tip1 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@"预约成功"];
    tip1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tip1];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successIcon.mas_bottom).offset(Interval(32));
        make.left.right.mas_equalTo(contentView);
        make.height.offset(ZOOM_SCALE(25));
    }];
    [contentView addSubview:self.tipsLab];
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip1.mas_bottom).offset(Interval(16));
        make.left.right.mas_equalTo(contentView);
        make.centerX.mas_equalTo(contentView);
    }];
    
    UIButton *confirm = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"我知道了"];
    [contentView addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLab.mas_bottom).offset(Interval(54));
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    [confirm addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)confirmBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(TTTAttributedLabel *)tipsLab{
    if (!_tipsLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"400-882-3320";
        NSString *promptText = [NSString stringWithFormat:@"您的购买预约已经提交成功\n我们会尽快安排客服人员与您联系\n您也可以直接拨打%@咨询",linkText];
        NSRange linkRange = [promptText rangeOfString:linkText];
        _tipsLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _tipsLab.font = RegularFONT(14);
        _tipsLab.textColor = [UIColor colorWithHexString:@"#8E8E93"];
        _tipsLab.numberOfLines = 0;
        _tipsLab.delegate = self;
        _tipsLab.lineBreakMode = NSLineBreakByCharWrapping;
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        _tipsLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(NO)
                                        };
        _tipsLab.linkAttributes = attributesDic;
        _tipsLab.activeLinkAttributes = attributesDic;
        [_tipsLab addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",linkText]] withRange:linkRange];
    }
    return _tipsLab;
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
   
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callWebview];
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
