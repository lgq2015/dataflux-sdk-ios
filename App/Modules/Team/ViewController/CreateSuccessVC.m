//
//  CreateSuccessVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "CreateSuccessVC.h"
#import "ZYSocialManager.h"
#import "TeamInfoModel.h"
#define WeChatBtnTag  100
#define QQBtnTag      200
#define DingBtnTag    300

@interface CreateSuccessVC ()
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong)NSString *shareUrl;
@end

@implementation CreateSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestShareUrl];
    [self createUI];
}
- (void)createUI{
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.view).offset(Interval(kStatusBarHeight+16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    
    UIImageView *successIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_success"]];
    [self.view addSubview:successIcon];
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.skipBtn.mas_bottom).offset(Interval(8));
        make.centerX.mas_equalTo(self.view);
        make.width.height.offset(ZOOM_SCALE(80));
    }];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(24) textColor:PWTextBlackColor text:@"恭喜您创建团队成功！"];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(successIcon.mas_bottom).offset(Interval(21));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(33));
    }];
    UILabel *inviteLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWSubTitleColor text:@"现在就去邀请小伙伴加入团队吧"];
    [self.view addSubview:inviteLab];
    [inviteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(54));
        make.height.offset(ZOOM_SCALE(20));
    }];
    NSArray *icon = @[@{@"name":@"team_weChat"},@{@"name":@"team_qq"},@{@"name":@"team_ding"}];
    NSArray *btnTag = @[@WeChatBtnTag,@QQBtnTag,@DingBtnTag];
    NSArray *iconName = @[@"微信好友",@"QQ 好友",@"钉钉"];
    for (NSInteger i=0; i<icon.count; i++) {
        UIImageView *imgView = [self inviteBtnWithDict:icon[i]];
        [self.view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(ZOOM_SCALE(70));
            make.top.mas_equalTo(inviteLab.mas_bottom).offset(Interval(42));
            if (i==0) {
                make.left.mas_equalTo(self.view).offset(Interval(40));
            }else if(i==1){
                make.centerX.mas_equalTo(self.view);
            }else{
                make.right.mas_equalTo(self.view).offset(-Interval(42));
            }
        }];
        imgView.tag = [btnTag[i] integerValue];
        UILabel *name = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTitleColor text:iconName[i]];
        name.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(Interval(7));
            make.centerX.mas_equalTo(imgView);
            make.width.offset(ZOOM_SCALE(51));
            make.height.offset(ZOOM_SCALE(17));
        }];
    }
    
}
-(UIImageView *)inviteBtnWithDict:(NSDictionary *)dict{
    UIImageView *item = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"name"]]];
    item.userInteractionEnabled = YES;
    item.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteBtnClick:)];
    [item addGestureRecognizer:tap];
    return item;
}
-(void)inviteBtnClick:(UITapGestureRecognizer *)tap{
    [self popShareUI:tap.view.tag];
}
-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.titleLabel.font = RegularFONT(16);
        [_skipBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [self.view addSubview:_skipBtn];
    }
    return _skipBtn;
}
- (void)skipBtnClick{
    if (self.btnClick) {
        self.btnClick();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ---请求分享链接---
- (void)requestShareUrl{
    [SVProgressHUD show];
    NSDictionary *param = @{@"data":@{@"invite_type":@"qrcode"}};
    WeakSelf
    [PWNetworking requsetHasTokenWithUrl:PW_teamInvite withRequestType:NetworkPostType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSString *rv = [content stringValueForKey:@"rv" default:@""];
            weakSelf.shareUrl = rv;
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)popShareUI:(NSInteger)btnTag{
    __weak typeof(self) weakself = self;
    NSString *titleDesc = @"团队邀请您加入，加入团队后您可以共享团队数据和信息，并与团队成员进行协作";
    NSString *title = [NSString stringWithFormat:@"%@ %@",userManager.teamModel.name,titleDesc];
    ZYSocialManager *manager = [[ZYSocialManager alloc]initWithTitle:title descr:@"" thumImage:[UIImage imageNamed:@"144-144"]];
    manager.webpageUrl = weakself.shareUrl;
    manager.showVC = weakself;
    switch (btnTag) {
        case WeChatBtnTag:
            [manager shareToPlatform:WechatSession_PlatformType];
            break;
        case QQBtnTag:
            [manager shareToPlatform:QQ_PlatformType];
            break;
        case DingBtnTag:
            [manager shareToPlatform:Dingding_PlatformType];
            break;
        default:
            break;
    }
}

@end
