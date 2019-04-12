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
@interface MemberInfoVC ()
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *memberName;
@property (nonatomic, strong) UIImageView *iconImgView;
@end

@implementation MemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.isShowWhiteBack = YES;
    [self.topNavBar clearNavBarBackgroundColor];
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    self.headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(278)+kStatusBarHeight)];
    self.headerIcon.image = [UIImage imageNamed:@"team_header"];
    
    [self.view addSubview:self.headerIcon];
    
   
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kTopHeight);
        make.width.height.offset(ZOOM_SCALE(110));
    }];
    
    [self.memberName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(Interval(5));
        make.height.offset(ZOOM_SCALE(22));
        make.left.right.mas_equalTo(self.view);
    }];
    switch (self.type) {
        case PWMemberViewTypeTeamMember:{
            NSString *url = [self.model.tags stringValueForKey:@"pwAvatar" default:@""];
            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
            self.memberName.text = self.model.name;
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
            self.memberName.text = userManager.curUserInfo.name;
        }
            break;
    }

    
    [self.view bringSubviewToFront:self.whiteBackBtn];
}
-(void)createBtnExpert{
    UIButton *callPhone = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"400-882-3320"];
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
    UIButton *callPhone = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:[NSString stringWithFormat:@"拨打电话(%@)",self.model.mobile]];
    [callPhone addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callPhone];
    [callPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.headerIcon.mas_bottom).offset(Interval(30));
        make.height.offset(ZOOM_SCALE(47));
    }];
    if (userManager.teamModel.isAdmin) {
        UIButton *delectTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:[NSString stringWithFormat:@"移除成员"]];
        [delectTeam addTarget:self action:@selector(delectTeamClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delectTeam];
        [delectTeam mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(Interval(16));
            make.right.mas_equalTo(self.view).offset(-Interval(16));
            make.top.mas_equalTo(callPhone.mas_bottom).offset(Interval(20));
            make.height.offset(ZOOM_SCALE(47));
        }];
    }
    if (self.model.isAdmin) {
        self.subTitleLab.text = @"管理员";
    }
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
        [self.view addSubview:_subTitleLab];
        [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(Interval(16));
            make.right.mas_equalTo(self.view).offset(-Interval(16));
            make.top.mas_equalTo(self.memberName.mas_bottom).offset(Interval(10));
        }];

    }
    return _subTitleLab;
}
- (void)callPhone{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.4];
}
- (void)btnClickedOperations{
    NSString *mobile = self.type==PWMemberViewTypeExpert? @"400-882-3320":self.model.mobile;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",mobile];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
                [SVProgressHUD showErrorWithStatus:@"移除失败"];
            }
        } failBlock:^(NSError *error) {
//            [SVProgressHUD dismiss];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"*转移管理员后，您将不再对团队具有管理权限，确认要将管理员转移给他吗？\n*操作完成将会强制退出登录" preferredStyle:UIAlertControllerStyleActionSheet];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
