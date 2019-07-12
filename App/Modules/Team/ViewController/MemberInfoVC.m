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
#import "ZhugeIOIssueHelper.h"
#import "ZhugeIOTeamHelper.h"

@interface MemberInfoVC ()
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *memberName;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIButton *beizhuBtn;
@property (nonatomic, strong) UIButton *noteNameBtn;
@end

@implementation MemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.isShowWhiteBack = YES;
    [self.topNavBar clearNavBarBackgroundColor];
    self.headerIcon.userInteractionEnabled = YES;
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    self.headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(330))];
    self.headerIcon.image = [UIImage imageNamed:@"team_header"];
    
    [self.view addSubview:self.headerIcon];
    
   
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kTopHeight);
        make.width.height.offset(ZOOM_SCALE(110));
    }];
    //对成员名称的位置做处理
    NSString  *titleName = self.model.name;
    CGFloat memberNameW = [self getMemberNameWidth:titleName withFont:MediumFONT(16)];
    CGFloat memberLabLeft = 0.0;
    //如果点击了管理员或专家
    if (self.model.isAdmin || self.model.isSpecialist){
        memberLabLeft = (self.view.width - memberNameW - 10 - ZOOM_SCALE(46)) * 0.5;
    }else{
        memberLabLeft = (self.view.width - memberNameW) * 0.5;
    }
    
    [self.memberName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(Interval(5));
        make.height.offset(ZOOM_SCALE(22));
        make.left.equalTo(@(memberLabLeft));
    }];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.memberName.mas_right).offset(10);
        make.centerY.equalTo(self.memberName.mas_centerY);
        make.width.equalTo(@(ZOOM_SCALE(46)));
        make.height.equalTo(@(ZOOM_SCALE(18)));
    }];
    [self.beizhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memberName.mas_bottom).offset(17);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    switch (self.type) {
        case PWMemberViewTypeTeamMember:{
            NSString *url = [self.model.tags stringValueForKey:@"pwAvatar" default:@""];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            self.memberName.text = self.model.name;
            if (self.model.isAdmin) {
                self.subTitleLab.hidden = NO;
                self.subTitleLab.text = @"管理员";
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
            self.subTitleLab.text = @"专家";
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
            if (self.model.isAdmin) {
                self.subTitleLab.hidden = NO;
                self.subTitleLab.text = @"管理员";
                self.subTitleLab.backgroundColor = [UIColor colorWithHexString:@"#FFD3A2"];
            }
        }
            break;
    }
    
    [self.view bringSubviewToFront:self.whiteBackBtn];
}
-(void)createBtnExpert{
    UIButton *callPhone = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"400 882 3320"];
    [callPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callPhone];
    [callPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(Interval(30));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
- (void)createBtnPhone{
    UIButton *callPhone = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:[NSString stringWithFormat:@"%@",[self phoneChange:self.model.mobile]]];
    callPhone.titleLabel.font = RegularFONT(18);
    [callPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callPhone];
    [callPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(36));
        make.right.mas_equalTo(self.view).offset(-Interval(36));
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(Interval(30));
        make.height.offset(ZOOM_SCALE(44));
    }];

    if (userManager.teamModel.isAdmin) {
        UIButton *delectTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:[NSString stringWithFormat:@"移除成员"]];
        [delectTeam.layer setBorderColor:[UIColor clearColor].CGColor];
        [delectTeam setBackgroundImage:[UIImage imageWithColor:PWWhiteColor] forState:UIControlStateNormal];
        [delectTeam addTarget:self action:@selector(delectTeamClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delectTeam];
        [delectTeam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(Interval(36));
            make.right.mas_equalTo(self.view).offset(-Interval(36));
            make.top.mas_equalTo(callPhone.mas_bottom).offset(Interval(20));
            make.height.offset(ZOOM_SCALE(44));
        }];
    }

    BOOL visible = self.model.mobile.length>0;
    callPhone.hidden = !visible;
}
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.layer.cornerRadius =ZOOM_SCALE(110)/2.0;
        _iconImgView.layer.cornerRadius = ZOOM_SCALE(55);
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode =  UIViewContentModeScaleAspectFill;
        [self.headerIcon addSubview:_iconImgView];
    }
    return _iconImgView;
}
-(UILabel *)memberName{
    if (!_memberName) {
       _memberName = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWWhiteColor text:@""];
        _memberName.textAlignment = NSTextAlignmentCenter;
        [self.headerIcon addSubview:_memberName];
    }
    return _memberName;
}


-(UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWWhiteColor text:@""];
        _subTitleLab.numberOfLines = 0;
        _subTitleLab.textAlignment = NSTextAlignmentCenter;
        _subTitleLab.layer.cornerRadius = 2;
        _subTitleLab.layer.masksToBounds = YES;
        _subTitleLab.hidden = YES;
        [self.headerIcon addSubview:_subTitleLab];
    }
    return _subTitleLab;
}
- (UIButton *)beizhuBtn{
    if (!_beizhuBtn){
        _beizhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beizhuBtn.userInteractionEnabled = YES;
        CGFloat spacing = 8.0;
        _beizhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.model.inTeamNote.length > 0){
            [_beizhuBtn setTitle:self.model.inTeamNote forState:UIControlStateNormal];
        }else{
            [_beizhuBtn setTitle:@"设置备注" forState:UIControlStateNormal];
        }
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            [_beizhuBtn setImage:[UIImage imageNamed:@"edit_beizhu"] forState:UIControlStateNormal];
            [_beizhuBtn setImage:[UIImage imageNamed:@"edit_beizhu"] forState:UIControlStateHighlighted];
        }
        [_beizhuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _beizhuBtn.titleLabel.font = RegularFONT(14);
        [_beizhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_beizhuBtn sizeToFit];
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            CGSize imageSize = _beizhuBtn.imageView.frame.size;
            _beizhuBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
            CGSize titleSize = _beizhuBtn.titleLabel.frame.size;
            _beizhuBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
        }
        [self.headerIcon addSubview:_beizhuBtn];
        [_beizhuBtn addTarget:self action:@selector(beizhuclick) forControlEvents:UIControlEventTouchUpInside];
        if (userManager.teamModel.isAdmin || self.type == PWMemberViewTypeMe){
            if ([getTeamState isEqualToString:PW_isPersonal] || self.model.isSpecialist){
                _beizhuBtn.hidden = YES;
            }else{
                _beizhuBtn.hidden = NO;
                _beizhuBtn.enabled = YES;
            }
        }else{
            if (self.model.inTeamNote.length > 0){
                _beizhuBtn.hidden = NO;
                _beizhuBtn.enabled = NO;
            }else{
                _beizhuBtn.hidden = YES;
            }
        }
        
    }
    return _beizhuBtn;
}
- (void)callPhone{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.4];
}
- (void)btnClickedOperations{
    NSString *mobile = self.type==PWMemberViewTypeExpert? @"400 882 3320":self.model.mobile;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

    if(self.type==PWMemberViewTypeExpert){
        [[[[ZhugeIOIssueHelper new] eventCallExpert] attrCallPhone:YES] track];
    } else{
        [[[ZhugeIOTeamHelper new] eventCallMember] track];
    }

}
- (void)createBtnTrans{
    UIButton *transBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"转移管理员"];
    [transBtn addTarget:self action:@selector(transBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transBtn];
    [transBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(Interval(112));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
- (void)delectTeamClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"移除成员后，成员将不在团队管理中，并不再接收团队任何消息" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认移除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSString *uid =self.model.memberID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
//            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"移除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(self.teamMemberRefresh){
                        self.teamMemberRefresh();
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
               
            }else{
                NSString *errorCode = response[@"errorCode"];
                if ([errorCode isEqualToString:@"home.auth.noSuchAccount"]){
                    [SVProgressHUD showSuccessWithStatus:@"移除成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(self.teamMemberRefresh){
                            self.teamMemberRefresh();
                        }
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }else{
                    [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
                }
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"移除失败"];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)transBtnClick{
    NSString *message = @"* 转移管理员后，您将不再对团队具有管理权限，确认要将管理员转移给他吗？\n* 操作完成将会强制退出登录";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alert.view];
    if (messageParentView && [messageParentView isKindOfClass:UILabel.class]) {
        UILabel *lable = (UILabel *)messageParentView;
        lable.textAlignment = NSTextAlignmentLeft;
    }
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:@"确认转移" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        ChangeUserInfoVC *verify = [[ChangeUserInfoVC alloc]init];
        verify.isShowCustomNaviBar = YES;
        verify.type = ChangeUITTeamTransfer;
        verify.memberID =self.model.memberID;
        [self.navigationController pushViewController:verify animated:YES];
    }];
    UIAlertAction *cancel = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
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
            [weakSelf.beizhuBtn setTitle:@"设置备注" forState:UIControlStateNormal];
        }else{
            [weakSelf.beizhuBtn setTitle:noteName forState:UIControlStateNormal];
        }
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

@end
