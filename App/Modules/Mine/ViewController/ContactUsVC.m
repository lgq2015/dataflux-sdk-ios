//
//  ContactUsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ContactUsVC.h"
#import "PPBadgeView.h"
#define TagPhoneBtn  100  // 右侧图片
#define TagEmailBtn 200
@interface ContactUsVC ()
@property (nonatomic, strong)UIButton *noPicPhoneBtn;
@property (nonatomic, strong)UIButton *phoneBtn;
@property (nonatomic, strong)UIButton *emailBtn;
@property (nonatomic, strong)UIImageView *iconImg;
@property (nonatomic, strong)UILabel *titleLab;
//@property (nonatomic, strong)UILabel *subTip;
@property (nonatomic, strong)UILabel *phoneLab;
@property (nonatomic, strong)UILabel *emailLab;
@property (nonatomic, strong)UIView *downView;
@property (nonatomic, strong)UIImageView *logoIcon;
@property (nonatomic, strong)UILabel *zoonLab;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@end

@implementation ContactUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.ContactUs", @"");
    self.contactUSType = VIP_Type;
    [self createUI];
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    [self.view addSubview:self.iconImg];
    [self.view addSubview:self.titleLab];
    if (self.contactUSType == VIP_Type){
        [self.view addSubview:self.phoneBtn];
        [self.view addSubview:self.emailBtn];
        [self.view addSubview:self.phoneLab];
        [self.view addSubview:self.emailLab];
    }else if (self.contactUSType == Normal_Type){
        [self.view addSubview:self.noPicPhoneBtn];
    }
    [self.view addSubview:self.downView];
    [self.downView addSubview:self.logoIcon];
    [self.downView addSubview:self.zoonLab];
    [self.downView addSubview:self.addressLab];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImg.mas_bottom).offset(Interval(30));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(33));
    }];

    if (self.contactUSType == VIP_Type){
        [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(Interval(100));
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(25));
            make.width.height.offset(ZOOM_SCALE(50));
        }];
        [self.emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-Interval(100));
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(25));
            make.width.height.offset(ZOOM_SCALE(50));
        }];
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.phoneBtn.mas_left);
            make.top.mas_equalTo(self.phoneBtn.mas_bottom).offset(Interval(12));
            make.width.offset(ZOOM_SCALE(50));
            make.height.offset(ZOOM_SCALE(17));
        }];
        [self.emailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.emailBtn.mas_left);
            make.top.mas_equalTo(self.emailBtn.mas_bottom).offset(Interval(12));
            make.width.offset(ZOOM_SCALE(50));
            make.height.offset(ZOOM_SCALE(17));
        }];
    }
    if (self.contactUSType == Normal_Type){
        [self.noPicPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Interval(20));
            make.left.mas_equalTo(self.view).offset(Interval(30));
            make.right.mas_equalTo(self.view).offset(-Interval(30));
            make.height.offset(30);
        }];
    }
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.contactUSType == Normal_Type){
            make.top.mas_equalTo(self.noPicPhoneBtn.mas_bottom).offset(Interval(60));
        }else if(self.contactUSType == VIP_Type){
            make.top.mas_equalTo(self.phoneBtn.mas_bottom).offset(Interval(60));
        }
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
   
    [self.zoonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.logoIcon.mas_bottom).offset(Interval(10));
        make.height.offset(ZOOM_SCALE(17));
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.zoonLab.mas_bottom).offset(Interval(10));
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.width.offset(kWidth - 32);
    }];
}
- (void)btnClick:(UIButton *)button{
    if (button.tag == TagPhoneBtn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
        [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.4];
    }else{
        NSMutableString *mailUrl = [[NSMutableString alloc] init];
        [mailUrl appendFormat:@"mailto:%@", @"support@jiagouyun.com"];
        NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    }
}
- (void)btnClickedOperations{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-882-3320"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
#pragma mark 请求
- (void)requesetContactUserData{
    [SVProgressHUD show];
    NSDictionary *params = @{@"platform":@"IOS"};
    [PWNetworking requsetHasTokenWithUrl:PW_ContactUS withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        NSString *errorCode = [response stringValueForKey:ERROR_CODE default:@""];
        if ([errorCode isEqualToString:@""]) {
            NSDictionary *content =PWSafeDictionaryVal(response, @"content");
            if (content){//已绑定cms
                self.contactUSType = VIP_Type;
                _avatar =[content stringValueForKey:@"avatar" default:@""];
                _realName = [content stringValueForKey:@"realName" default:@""];
                _mobile = [content stringValueForKey:@"mobile" default:@""];
                _email = [content stringValueForKey:@"email" default:@""];
                _city = [content stringValueForKey:@"city" default:@""];
                _address = [content stringValueForKey:@"address" default:@""];
            }else{//没有绑定cms
                self.contactUSType = Normal_Type;
            }
        }else{//没有找到
            self.contactUSType = Normal_Type;
        }
        [self createUI];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)requesetCMSCall{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_CMSCall withRequestType:NetworkPostType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if (![response[ERROR_CODE] isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"local.CallFailed", @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
#pragma mark ---lazy-----
- (UIButton *)noPicPhoneBtn{
    if (!_noPicPhoneBtn){
        _noPicPhoneBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:_mobile == nil ? @"400 882 3320" : _mobile];
        [_noPicPhoneBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        _noPicPhoneBtn.tag = TagPhoneBtn;
        [_noPicPhoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noPicPhoneBtn;
}
- (UIButton *)phoneBtn{
    if (!_phoneBtn){
        _phoneBtn = [[UIButton alloc]init];
        [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"icon_csm"] forState:UIControlStateNormal];
        _phoneBtn.tag = TagPhoneBtn;
        [_phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}
- (UIButton *)emailBtn{
    if (!_emailBtn){
        _emailBtn = [[UIButton alloc]init];
        [_emailBtn setBackgroundImage:[UIImage imageNamed:@"mine_email"] forState:UIControlStateNormal];
        [_emailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _emailBtn.tag = TagEmailBtn;
    }
    return _emailBtn;
}
- (UIImageView *)iconImg{
    if (!_iconImg){
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, Interval(28), ZOOM_SCALE(160), ZOOM_SCALE(160))];
//        [_iconImg sd_setImageWithURL:[NSURL URLWithString:_avatar == nil ? @"" : _avatar] placeholderImage:[UIImage imageNamed:@"mine_contacticon"]];
        [_iconImg setImage:[UIImage imageNamed:@"mine_contacticon"]];
        CGPoint center = _iconImg.center;
        center.x = self.view.centerX;
        _iconImg.center = center;
    }
    return _iconImg;
}
- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(24) textColor:PWTextBlackColor text:NSLocalizedString(@"local.ProWang", @"")];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)phoneLab{
    if (!_phoneLab){
        _phoneLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:NSLocalizedString(@"local.RingUp", @"")];
        _phoneLab.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLab;
}
- (UILabel *)emailLab{
    if (!_emailLab){
        _emailLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:NSLocalizedString(@"local.SendEmail", @"")];
        _emailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _emailLab;
}
- (UIView *)downView{
    if (!_downView){
        _downView = [[UIView alloc]init];
        _downView.backgroundColor = PWBackgroundColor;
    }
    return _downView;
}
- (UIImageView *)logoIcon{
    if (!_logoIcon){
        _logoIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_logo"]];
        _logoIcon.frame = CGRectMake(0, Interval(13), ZOOM_SCALE(32), ZOOM_SCALE(32));
        CGPoint logoCenter = _logoIcon.center;
        logoCenter.x = self.view.centerX;
        _logoIcon.center = logoCenter;
    }
    return _logoIcon;
}
- (UILabel *)zoonLab{
    if (!_zoonLab){
        _zoonLab =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWBlueColor text:_city == nil ? NSLocalizedString(@"local.company.addressCity", @"") : _city];
        _zoonLab.textAlignment = NSTextAlignmentCenter;
    }
    return _zoonLab;
}
- (UILabel *)addressLab{
    if (!_addressLab){
        _addressLab =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTitleColor text:_address == nil ? NSLocalizedString(@"local.company.address", @"") : _address];
        _addressLab.textAlignment = NSTextAlignmentCenter;
        _addressLab.numberOfLines = 0;
    }
    return _addressLab;
}
@end
