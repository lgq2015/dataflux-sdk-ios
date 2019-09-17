//
//  MemberInfoVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MemberInfoVC.h"
#import "MemberInfoModel.h"
#import "TeamVC.h"
#import "ChangeUserInfoVC.h"
#import "TeamInfoModel.h"
#import "EditBeizhuVC.h"
#import "NSString+Regex.h"
#import "CopyLable.h"
#import "ZhugeIOIssueHelper.h"
#import "ZhugeIOTeamHelper.h"
#import "NSString+ErrorCode.h"

#define phoneViewTag 35
@interface MemberInfoVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *memberName;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIButton *beizhuBtn;
@property (nonatomic, strong) UIButton *noteNameBtn;
@property (nonatomic, strong) CopyLable *phoneLab;
@property (nonatomic, strong) CopyLable *emailLab;
@property (nonatomic, strong) UIButton *callBtn;

@property (nonatomic, strong) UIView *temp;
@end

@implementation MemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(169)+kTopHeight-64)];
    self.headerView.backgroundColor = PWWhiteColor;
    [self.view addSubview:self.headerView];
    [self.view sendSubviewToBack:self.headerView];
    self.topNavBar.backgroundColor = PWWhiteColor;
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerView).offset(-ZOOM_SCALE(21));
        make.width.height.offset(ZOOM_SCALE(70));
        make.left.mas_equalTo(self.view).offset(Interval(16));
    }];
    //对成员名称的位置做处理
    
    
    [self.memberName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_top).offset(Interval(6));
        make.height.offset(ZOOM_SCALE(25));
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(16);
    }];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.memberName.mas_right).offset(16);
        make.centerY.equalTo(self.memberName.mas_centerY);
        make.width.equalTo(@(ZOOM_SCALE(46)));
        make.height.equalTo(@(ZOOM_SCALE(18)));
    }];
    [self.beizhuBtn sizeToFit];
    CGFloat width = self.beizhuBtn.frame.size.width+20+ZOOM_SCALE(14);
    [self.beizhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberName.mas_bottom).offset(8);
        make.left.mas_equalTo(self.memberName);
        make.width.offset(width);
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.temp =self.headerView;
    if(self.model.email.length>0){
    UIView *email = [self createEmailView];
    [email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.temp.mas_bottom).offset(12);
        make.height.offset(ZOOM_SCALE(42)+23);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self.view);
        make.height.offset(SINGLE_LINE_WIDTH);
        make.top.mas_equalTo(email.mas_bottom);
    }];
        self.emailLab.text = self.model.email;
        self.temp = line;
    }
    if (self.model.mobile.length>0 || self.type == PWMemberViewTypeSpecialist||self.type ==PWMemberViewTypeExpert) {
        UIView *phone = [self createPhoneView];
        phone.tag = phoneViewTag;
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.width.mas_equalTo(self.view);
            if([self.temp isEqual:self.headerView]){
                make.top.mas_equalTo(self.temp.mas_bottom).offset(12);
            }else{
            make.top.mas_equalTo(self.temp.mas_bottom);
            }
            make.height.offset(ZOOM_SCALE(42)+23);
        }];
        self.phoneLab.text  =[self phoneChange:self.model.mobile];
        self.temp = self.phoneLab;
    }
    
    switch (self.type) {
        case PWMemberViewTypeTeamMember:{
            NSString *url = [self.model.tags stringValueForKey:@"pwAvatar" default:@""];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            self.memberName.text = self.model.name;
            if (self.model.isAdmin) {
                self.subTitleLab.hidden = NO;
                self.subTitleLab.text = NSLocalizedString(@"local.TeamAdministrator", @"");
                self.subTitleLab.backgroundColor = [UIColor colorWithHexString:@"#FFD3A2"];
            }
             [self createBtnPhone];
        }
            break;
        case PWMemberViewTypeExpert:{
            NSString *name = self.expertDict[@"name"];
            self.memberName.text = name;
            NSString *iconUrl = self.expertDict[@"url"];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            [self createBtnExpert];
        }
            break;
        case PWMemberViewTypeSpecialist:{
            self.memberName.text = self.model.name;
            [self.iconImgView setImage:[UIImage imageNamed:@"professor_wang_header"]];
            self.subTitleLab.hidden = NO;
            self.subTitleLab.text = NSLocalizedString(@"local.experts", @"");
            self.subTitleLab.backgroundColor = [UIColor colorWithHexString:@"#89B7FF"];
            [self createBtnExpert];
        }
            break;
        case PWMemberViewTypeTrans:{
            NSString *url = [self.model.tags stringValueForKey:@"pwAvatar" default:@""];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            self.memberName.text = self.model.name;
            [self createBtnTrans];
        }
            break;
        case PWMemberViewTypeMe:{
            NSString *url = [userManager.curUserInfo.tags stringValueForKey:@"pwAvatar" default:@""];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            self.memberName.text = self.model.name;
            self.callBtn.hidden = YES;
            if (self.model.isAdmin) {
                self.subTitleLab.hidden = NO;
                self.subTitleLab.text = NSLocalizedString(@"local.TeamAdministrator", @"");
                self.subTitleLab.backgroundColor = [UIColor colorWithHexString:@"#FFD3A2"];
            }
        }
            break;
    }
    
}
-(void)createBtnExpert{
    self.phoneLab.text = @"400 882 3320";
}
- (void)createBtnPhone{
   
    if (userManager.teamModel.isAdmin) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-ZOOM_SCALE(42)-SafeAreaBottom_Height, kWidth, ZOOM_SCALE(42)+SafeAreaBottom_Height)];
        bgView.backgroundColor = PWWhiteColor;
        [self.view addSubview:bgView];
        UIButton *delectTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:[NSString stringWithFormat:NSLocalizedString(@"local.RemoveMember", @"")]];
        [delectTeam setTitleColor:[UIColor colorWithHexString:@"#F6584C"] forState:UIControlStateNormal];
        delectTeam.backgroundColor = PWWhiteColor;
        [delectTeam setTitleColor:[UIColor colorWithHexString:@"#F6584C"] forState:UIControlStateHighlighted];
        [delectTeam addTarget:self action:@selector(delectTeamClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:delectTeam];
        [delectTeam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(bgView);
            make.height.offset(ZOOM_SCALE(42));
        }];
    }

}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.cornerRadius = ZOOM_SCALE(35);
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode =  UIViewContentModeScaleAspectFill;
        [self.headerView addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)memberName{
    if (!_memberName) {
        _memberName = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(18) textColor:PWTextBlackColor text:@""];
        _memberName.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:_memberName];
    }
    return _memberName;
}
-(UIButton *)callBtn{
    if (!_callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
        [_callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

-(UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWWhiteColor text:@""];
        _subTitleLab.numberOfLines = 0;
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
        _subTitleLab.layer.cornerRadius = 2;
        _subTitleLab.layer.masksToBounds = YES;
        _subTitleLab.hidden = YES;
        [self.headerView addSubview:_subTitleLab];
    }
    return _subTitleLab;
}
- (UIButton *)beizhuBtn{
    if (!_beizhuBtn){
        _beizhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beizhuBtn.backgroundColor = [UIColor colorWithHexString:@"#EEF5FF"];
        _beizhuBtn.layer.cornerRadius = 11.f;
        CGFloat spacing = 8.0;
        if (self.model.inTeamNote.length > 0){
            [_beizhuBtn setTitle:self.model.inTeamNote forState:UIControlStateNormal];
            _beizhuBtn.selected = YES;
        }else{
            [_beizhuBtn setTitle:NSLocalizedString(@"local.SetTheNote", @"") forState:UIControlStateNormal];
        }
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            [_beizhuBtn setImage:[UIImage imageNamed:@"edit_beizhu"] forState:UIControlStateNormal];
            [_beizhuBtn setImage:[UIImage imageNamed:@"edit_beizhub"] forState:UIControlStateSelected];
        }
        [_beizhuBtn setTitleColor:[UIColor colorWithHexString:@"#595860"] forState:UIControlStateNormal];
         [_beizhuBtn setTitleColor:PWBlueColor forState:UIControlStateSelected];
        _beizhuBtn.titleLabel.font = RegularFONT(13);
        [_beizhuBtn sizeToFit];
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            CGSize imageSize = _beizhuBtn.imageView.frame.size;
            _beizhuBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
            CGSize titleSize = _beizhuBtn.titleLabel.frame.size;
            _beizhuBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
        }
        [self.headerView addSubview:_beizhuBtn];
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            if ([getTeamState isEqualToString:PW_isPersonal] || self.model.isSpecialist){
                _beizhuBtn.hidden = YES;
            }else{
                _beizhuBtn.hidden = NO;
                _beizhuBtn.enabled = YES;
            }
            [_beizhuBtn addTarget:self action:@selector(beizhuclick) forControlEvents:UIControlEventTouchUpInside];

        }else{
            if (self.model.inTeamNote.length > 0){
                _beizhuBtn.hidden = NO;
                _beizhuBtn.selected = YES;
                [_beizhuBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
            }else{
                _beizhuBtn.hidden = YES;
            }
        }
        
    }
    return _beizhuBtn;
}
- (UIView *)createEmailView{
    UIView *emailView = [[UIView alloc]init];
    emailView.backgroundColor = PWWhiteColor;
    [self.view addSubview:emailView];
    UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectMake(16, 8, ZOOM_SCALE(35), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:NSLocalizedString(@"local.mailbox", @"")];
    [emailView addSubview:tip];
    self.emailLab = [[CopyLable alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip.frame)+6, kWidth-32, ZOOM_SCALE(22))];
    self.emailLab.font = RegularFONT(16);
    self.emailLab.textColor = PWTextBlackColor;
    [emailView addSubview:self.emailLab];
    return emailView;
}
- (UIView *)createPhoneView{
    UIView *phoneView = [[UIView alloc]init];
    phoneView.backgroundColor = PWWhiteColor;
    [self.view addSubview:phoneView];
    UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectMake(16, 8, ZOOM_SCALE(35), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#595860"] text:NSLocalizedString(@"local.phone", @"")];
    [phoneView addSubview:tip];
    self.phoneLab = [[CopyLable alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(tip.frame)+6, ZOOM_SCALE(200), ZOOM_SCALE(22))];
    self.phoneLab.font = RegularFONT(16);
    self.phoneLab.textColor = PWTextBlackColor;
    [phoneView addSubview:self.phoneLab];
    [phoneView addSubview:self.callBtn];
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(ZOOM_SCALE(26));
        make.right.mas_equalTo(phoneView.mas_right).offset(-24);
        make.centerY.mas_equalTo(phoneView);
    }];
    return phoneView;
}
- (void)callPhone{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.4];
}
- (void)btnClickedOperations{
    NSString *mobile = self.type==PWMemberViewTypeExpert? @"400 882 3320":self.model.mobile;
    if (mobile == nil ||[mobile isEqualToString:@""]) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];


    if(self.type==PWMemberViewTypeExpert){
        [[[[ZhugeIOIssueHelper new] eventCallExpert] attrCallPhone:YES] track];
    } else{
        [[[ZhugeIOTeamHelper new] eventCallMember] track];
    }

}
- (void)createBtnTrans{
    UIView *phone = [self.view viewWithTag:phoneViewTag];
    UIButton *transBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:NSLocalizedString(@"local.TransferManager", @"")];
    [transBtn addTarget:self action:@selector(transBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transBtn];
    [transBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(phone.mas_bottom).offset(Interval(112));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
- (void)delectTeamClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"local.TeamDeleteMemberTip", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmRemoval", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *uid =self.model.memberID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.SuccessfullyRemoved", @"")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(self.teamMemberRefresh){
                        self.teamMemberRefresh();
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
               
            }else{
                NSString *errorCode = response[@"errorCode"];
                if ([errorCode isEqualToString:@"home.auth.noSuchAccount"]){
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.SuccessfullyRemoved", @"")];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(self.teamMemberRefresh){
                            self.teamMemberRefresh();
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }else{
                    [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
                }
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"local.RemovalFailed", @"")];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)transBtnClick{
    NSString *message = NSLocalizedString(@"local.tip.TransferManagerTip", @"");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alert.view];
    if (messageParentView && [messageParentView isKindOfClass:UILabel.class]) {
        UILabel *lable = (UILabel *)messageParentView;
        lable.textAlignment = NSTextAlignmentLeft;
    }
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmTransfer", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        ChangeUserInfoVC *verify = [[ChangeUserInfoVC alloc]init];
        verify.isShowCustomNaviBar = YES;
        verify.type = ChangeUITTeamTransfer;
        verify.memberID =self.model.memberID;
        [self.navigationController pushViewController:verify animated:YES];
    }];
    UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
   

}
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return subView;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}
#pragma mark ======按钮交互======
- (void)beizhuclick{
    EditBeizhuVC *vc = [[EditBeizhuVC alloc] init];
    vc.memeberID = self.model.memberID;
    vc.noteName = self.model.inTeamNote;
    __weak typeof(self) weakSelf = self;
    vc.editTeamMemberNote = ^(NSString *noteName) {
        if (noteName.length == 0){
            [weakSelf.beizhuBtn setTitle:NSLocalizedString(@"local.SetTheNote", @"") forState:UIControlStateNormal];
            weakSelf.beizhuBtn.selected = NO;
        }else{
            [weakSelf.beizhuBtn setTitle:noteName forState:UIControlStateNormal];
            weakSelf.beizhuBtn.selected = YES;
        }
        [self.beizhuBtn sizeToFit];
        CGFloat width = self.beizhuBtn.frame.size.width+20+ZOOM_SCALE(14);
        [weakSelf.beizhuBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
        }];
        weakSelf.model.inTeamNote = noteName;
        CGFloat spacing = 8.0;
        // 图片右移
        CGSize imageSize = weakSelf.beizhuBtn.imageView.frame.size;
        weakSelf.beizhuBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        // 文字左移
        CGSize titleSize = weakSelf.beizhuBtn.titleLabel.frame.size;
        weakSelf.beizhuBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
        // 修改chooseAdminVC中显示的备注
        if (weakSelf.memberBeizhuChangeBlock){
            weakSelf.memberBeizhuChangeBlock(noteName);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ===计算文本宽度=====
- (CGFloat)getMemberNameWidth:(NSString *)str withFont:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

//格式化电话号码 344
- (NSString *)phoneChange:(NSString *)phoneNum{
    NSString *tenDigitNumber = phoneNum;
    tenDigitNumber = [tenDigitNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                               withString:@"$1 $2 $3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [tenDigitNumber length])];
    return tenDigitNumber;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
@end
