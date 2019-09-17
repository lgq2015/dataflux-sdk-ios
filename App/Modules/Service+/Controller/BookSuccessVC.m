//
//  BookSuccessVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "BookSuccessVC.h"
#import <TTTAttributedLabel.h>
#import "PWWeakProxy.h"

@interface BookSuccessVC ()<TTTAttributedLabelDelegate>
@property (nonatomic, strong) TTTAttributedLabel *tipsLab;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong)  UIButton *confirm;
@end

@implementation BookSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.second = 5;
    [self createUI];
//    [self addTimer];
}
- (void)addTimer{
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
    } else {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:[PWWeakProxy proxyWithTarget:self] selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}
- (void)createUI{
    self.view.backgroundColor = PWBackgroundColor;
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    navView.backgroundColor = PWWhiteColor;
    [self.view addSubview:navView];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(18) textColor:PWTextBlackColor text:NSLocalizedString(@"local.SuccessfulAppointment", @"")];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLab];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = PWLineColor;
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
    successIcon.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:successIcon];
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(Interval(55));
        make.height.with.offset(ZOOM_SCALE(80));
        make.centerX.mas_equalTo(contentView);
    }];
    UILabel *tip1 = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:NSLocalizedString(@"local.SuccessfulAppointment", @"")];
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
    NSString *str = NSLocalizedString(@"local.Iknow", @"");
    _confirm = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:str];
    _confirm.titleLabel.font = RegularFONT(18);
    [contentView addSubview:_confirm];
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipsLab.mas_bottom).offset(Interval(54));
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    [_confirm addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)confirmBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(TTTAttributedLabel *)tipsLab{
    if (!_tipsLab) {
        //    Access Key 可在您的阿里云 RAM 账号中找到，详细步骤请点击这里
        NSString *linkText = @"4008823320";
        NSString *promptText = [NSString stringWithFormat:NSLocalizedString(@"local.tip.BookSuccessTip", @""),linkText];
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
   
    WKWebView * callWebview = [[WKWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:callWebview];
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    DLog(@"%s",__func__);
}
#pragma mark ---定时器方法回调----
- (void)timerRun{
    if (self.second>0) {
        self.second--;
        NSString *str = [NSString stringWithFormat:@"%@（%ld）",NSLocalizedString(@"local.Iknow", @""),(long)self.second];
        [_confirm setTitle:str forState:UIControlStateNormal];
    }else if(self.second == 0){
        [self.timer setFireDate:[NSDate distantFuture]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
