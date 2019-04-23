//
//  ServiceDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/18.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ServiceDetailVC.h"
#import "FillinTeamInforVC.h"
#import "BookSuccessVC.h"
#import "ServiceDetailVC+ChangeNavColor.h"
#import "ZYPayWayUIManager.h"
#import <AlipaySDK/AlipaySDK.h>
@interface ServiceDetailVC ()<UIScrollViewDelegate>

@end

@implementation ServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.isShowWhiteBack = YES;
    [self.whiteBackBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.webView.scrollView.bounces = YES;
   self.webView.scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //监听支付回调结果事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifubaoCallBack:) name:KZhifubaoPayResult object:nil];
}
- (void)createUI{

    [self.view bringSubviewToFront:self.whiteBackBtn];
    if (self.isShowCustomNaviBar){
        [self initTopNavBar];
    }
}
- (void)eventTeamCreate:(NSDictionary *)extra{
    FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
    [self.navigationController pushViewController:createTeam animated:YES];
}
-(void)eventBookSuccess:(NSDictionary *)extra{
    [[ZYPayWayUIManager shareInstance] showWithPayWaySelectionBlock:^(SelectPayWayType selectPayWayType) {
        DLog(@"支付方式----%ld",selectPayWayType);
        switch (selectPayWayType) {
            case Zhifubao_PayWayType:
                [self requestSign];
                break;
            case ContactSale_PayWayType:
                DLog(@"联系销售");
                break;
            default:
                break;
        }
    }];
    //弹出支付方式界面
//    BookSuccessVC *successVC = [[BookSuccessVC alloc]init];
//    [self presentViewController:successVC animated:YES completion:nil];
}
#pragma mark ====获取订单签名======
- (void)requestSign{
    //请求
    NSString *appScheme = @"";
    NSString *orderString = @"";
    #if DEV //开发环境
    appScheme = @"prof-wang-dev";
    #elif PREPROD //预发环境
    appScheme = @"prof-wang-pre";
    #else //正式环境
    appScheme = @"prof-wang";
    #endif
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        DLog(@"ServiceDetailVC支付宝结果 = %@",resultDic);
        int statusCode = [resultDic[@"resultStatus"]  intValue];
        if (statusCode == 9000){
            DLog(@"支付成功");
        }
        else{
            DLog(@"支付失败")
        }
    }];
}
#pragma mark ===通知支付回调处理=====
- (void)zhifubaoCallBack:(NSNotification *)notif{
    NSDictionary *dic = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"收到的回调结果---%@",dic);
}
#pragma mark ====导航栏的显示和隐藏====
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self zt_changeColor:[UIColor whiteColor] scrolllView:scrollView];
}
- (void)initTopNavBar{
    [self.topNavBar setFrame:CGRectMake(0, 0, kWidth, kTopHeight)];
    self.topNavBar.backgroundColor = [UIColor clearColor];
    [self.topNavBar.backBtn setImage:[UIImage imageNamed:@"close_blue"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.topNavBar];
    [self.topNavBar addBottomSepLine];
}
@end
