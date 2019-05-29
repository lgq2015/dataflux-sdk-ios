//
//  IssueSourceHelperVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSourceHelperVC.h"
#import <TTTAttributedLabel.h>
#import "PWBaseWebVC.h"
@interface IssueSourceHelperVC ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) TTTAttributedLabel *secureProtocolLab;
@end

@implementation IssueSourceHelperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"什么是云服务";
    [self createUI];
}
- (void)createUI{
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
    contentView.backgroundColor = PWWhiteColor;
    [self.view addSubview:contentView];
    UILabel *lable = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"王教授通过连接用户提供的云平台或者主机等来源，获取诊断所需的基础数据，从而基于这些基础数据来运行诊断程序，得出诊断结果，为用户推送诊断情报。"];
    lable.numberOfLines = 0;
    [contentView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(Interval(24));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];

    
    UILabel *lable2 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"这些为王教授提供诊断所需的基础数据的来源，我们统称为云服务。"];
    lable2.numberOfLines = 0;
    [contentView addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable.mas_bottom).offset(Interval(20));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    UILabel *lable3 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:@"王教授采集基础数据都是采用只读的方式，绝不会影响用户云服务上系统及应用的正常运转。"];
    lable3.numberOfLines = 0;
    [contentView addSubview:lable3];
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable2.mas_bottom).offset(Interval(20));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    [contentView addSubview:self.secureProtocolLab];
    [self.secureProtocolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable3.mas_bottom).offset(Interval(20));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
    }];
    
}


-(TTTAttributedLabel *)secureProtocolLab{
    if (!_secureProtocolLab) {
        NSString *linkText = @"《用户数据安全协议》";
        NSString *promptText = [NSString stringWithFormat:@"我们也承诺绝不会泄露这些基础数据，也不会将这些数据用做任何商业用途，详情请查看%@", linkText];
        NSRange linkRange = [promptText rangeOfString:linkText];
        _secureProtocolLab = [[TTTAttributedLabel alloc] initWithFrame: CGRectZero];
        _secureProtocolLab.font = RegularFONT(16);
        _secureProtocolLab.textColor = PWTitleColor;
        _secureProtocolLab.numberOfLines = 0;
        _secureProtocolLab.delegate = self;
        
        _secureProtocolLab.lineBreakMode = NSLineBreakByCharWrapping;
        _secureProtocolLab.text = promptText;
        NSDictionary *attributesDic = @{(NSString *)kCTForegroundColorAttributeName : (__bridge id)PWBlueColor.CGColor,
                                        (NSString *)kCTUnderlineStyleAttributeName : @(NO)
                                        };
        _secureProtocolLab.linkAttributes = attributesDic;
        _secureProtocolLab.activeLinkAttributes = attributesDic;
        [_secureProtocolLab addLinkToURL:[NSURL URLWithString:PW_Safelegal] withRange:linkRange];
    }
    return _secureProtocolLab;
}
#pragma mark ========== TTTAttributedLabelDelegate ==========
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    PWBaseWebVC *webvc = [[PWBaseWebVC alloc]initWithTitle:@"用户数据安全协议" andURL:url];
    [self.navigationController pushViewController:webvc animated:YES];
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
