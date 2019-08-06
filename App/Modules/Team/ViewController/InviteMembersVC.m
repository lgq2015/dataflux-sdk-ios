//
//  InviteMembersVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InviteMembersVC.h"
#import "InviteCardView.h"
#import "InviteByPhoneOrEmail.h"
#import "QrCodeInviteVC.h"
#import "ZhugeIOTeamHelper.h"

#define SccanTag 21
#define EmailTag 22
#define PhoneTag 23
@interface InviteMembersVC ()

@end

@implementation InviteMembersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.TeamInviteMembers", @"");
    [self createUI];
}
- (void)createUI{
    NSArray *cardAry = @[@{@"icon":@"team_scan",@"title":@"二维码邀请"},@{@"icon":@"team_email",@"title":@"邮箱邀请"},@{@"icon":@"team_mobile",@"title":@"手机号邀请"}];
    UIView *temp;
    for (NSInteger i=0; i<cardAry.count; i++) {
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardClick:)];
        if (temp==nil) {
             UIView *card = [[InviteCardView alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), ZOOM_SCALE(60)) dict:cardAry[i]];
            [self.view addSubview:card];
            card.userInteractionEnabled = YES;
            [card addGestureRecognizer:tap];
            temp = card;
            card.tag = 21;
        }else{
            UIView *card = [[InviteCardView alloc]initWithFrame:CGRectMake(Interval(16),CGRectGetMaxY(temp.frame)+Interval(12), kWidth-Interval(32), ZOOM_SCALE(60)) dict:cardAry[i]];
            card.userInteractionEnabled = YES;
            [card addGestureRecognizer:tap];
            [self.view addSubview:card];
            temp =card;
            card.tag = 21+i;
        }
        
    }
}
- (void)cardClick:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == SccanTag) {
        QrCodeInviteVC *qrCode = [[QrCodeInviteVC alloc]init];
        [self.navigationController pushViewController:qrCode animated:YES];
        [[[ZhugeIOTeamHelper new] eventJoinScan] track];

    }else if(tap.view.tag == PhoneTag){
        InviteByPhoneOrEmail *invite = [[InviteByPhoneOrEmail alloc]init];
        invite.isPhone = YES;
        [self.navigationController pushViewController:invite animated:YES];
        [[[ZhugeIOTeamHelper new] eventInviteEmail] track];

    }else{
        InviteByPhoneOrEmail *invite = [[InviteByPhoneOrEmail alloc]init];
        invite.isPhone = NO;
        [self.navigationController pushViewController:invite animated:YES];
        [[[ZhugeIOTeamHelper new] eventInvitePhone] track];

    }
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
