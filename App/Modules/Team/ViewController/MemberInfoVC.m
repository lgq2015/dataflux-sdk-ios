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
@interface MemberInfoVC ()
@property (nonatomic, strong) UIImageView *headerIcon;
@end

@implementation MemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self.topNavBar clearNavBarBackgroundColor];
}
- (void)createUI{
    self.view.backgroundColor = PWWhiteColor;
    self.headerIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(255)+kStatusBarHeight)];
    self.headerIcon.image = [UIImage imageNamed:@"team_header"];
    
    [self.view addSubview:self.headerIcon];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [self.headerIcon addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(Interval(10)+kTopHeight);
        make.width.height.offset(ZOOM_SCALE(110));
    }];
    icon.layer.cornerRadius =ZOOM_SCALE(110)/2.0;
    NSString *url = [self.model.tags stringValueForKey:@"pwAvatar" default:@""];
    [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    icon.layer.cornerRadius = ZOOM_SCALE(55);
    icon.layer.masksToBounds = YES;
    UILabel *memberName = [PWCommonCtrl lableWithFrame:CGRectZero font:BOLDFONT(16) textColor:PWWhiteColor text:self.model.name];
    memberName.textAlignment = NSTextAlignmentCenter;
    [self.headerIcon addSubview:memberName];
    [memberName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(5));
        make.height.offset(ZOOM_SCALE(22));
        make.left.right.mas_equalTo(self.view);
    }];
    if (self.isInfo) {
        [self createBtnPhone];
    }else{
        [self createBtnTrans];
    }
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
- (void)callPhone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.mobile];
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    ChangeUserInfoVC *verify = [[ChangeUserInfoVC alloc]init];
    verify.isShowCustomNaviBar = YES;
    verify.type = ChangeUITTeamTransfer;
    verify.memberID =self.model.memberID;
    [self.navigationController pushViewController:verify animated:YES];

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
