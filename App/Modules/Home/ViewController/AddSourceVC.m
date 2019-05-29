//
//  AddSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceVC.h"
#import "AddSourceCell.h"
#import "IssueSourceDetailVC.h"
#import "AddSourceItemView.h"
#import "HostDiagnosisVC.h"
#import "ClusterDiagnosisVC.h"
#import "IssueSourceHelperVC.h"
#import "AddIssueSourceMoreServicesVC.h"
#import "AddSourceTipView.h"
#import "TeamInfoModel.h"
#import "IssueSourceManger.h"
#import "AddSourceTipVC.h"

@interface AddSourceVC ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, strong) UIView *nodataView;
@end

@implementation AddSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加云服务";
   // [self createUI];
    [self.view addSubview:self.nodataView];
    // Do any additional setup after loading the view.
}
//-(UIView *)nodataView{
//    if (!_nodataView) {
//        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
//        _nodataView.backgroundColor = PWWhiteColor;
//        [self.view addSubview:_nodataView];
//        
//        UIImageView *bgImgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goToWebAdd"]];
//        [_nodataView addSubview:bgImgview];
//        [bgImgview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_nodataView).offset(Interval(47));
//            make.width.offset(ZOOM_SCALE(250));
//            make.height.offset(ZOOM_SCALE(222));
//            make.centerX.mas_equalTo(_nodataView);
//        }];
//        UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:[UIColor colorWithHexString:@"#140F26"] text:@"请去web端添加"];
//        tip.textAlignment = NSTextAlignmentCenter;
//        [_nodataView addSubview:tip];
//        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(bgImgview.mas_bottom).offset(Interval(31));
//            make.left.right.mas_equalTo(self.view);
//            make.height.offset(ZOOM_SCALE(22));
//        }];
//    }
//    return _nodataView;
//}
-(UIView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight)];
        _nodataView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_nodataView];
        UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:[UIColor colorWithHexString:@"#140F26"] text:@"请去web端添加"];
        tip.numberOfLines = 0;
        //设置内容
        [self setContent:tip];
        [_nodataView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataView).offset(Interval(47));
            make.left.equalTo(_nodataView).offset(16);
            make.right.equalTo(_nodataView).offset(-16);
        }];
    }
    return _nodataView;
}
//设置 无数据内容
- (void)setContent:(UILabel *)label{
    NSString *string = @"通过连接云服务，您可以将您的云服务账号与王教授进行连接，从而获得针对云资源的专业诊断，发现可优化的配置，监控您的系统健康状态。\n所有发现的问题都将以情报推送给您，以便您可以及时获知 IT 系统存在的问题，与团队成员共同查看并沟通解决。\n\n连接云服务仅支持在 Web 端操作，请您登录 home.prof.wang，进行连接云服务的配置。";
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:@"home.prof.wang"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor blueColor];
    [attribut addAttributes:dic range:range];
    label.attributedText = attribut;
}
- (void)createUI{
  
    
    [self addNavigationItemWithImageNames:@[@"home_question"] isLeft:NO target:self action:@selector(rightNavClick) tags:@[@10]];
    
    NSArray *array = @[@{@"title":@"云平台诊断",@"type":@1,@"datas":@[@{@"icon":@"icon_alib",@"name":@"阿里云",@"sourceType":@1},@{@"icon":@"icon_aws_big",@"name":@"AWS",@"sourceType":@2},@{@"icon":@"icon_tencent_big",@"name":@"腾讯云",@"sourceType":@3},@{@"icon":@"icon_ucloud_big",@"name":@"UCloud",@"sourceType":@4},@{@"icon":@"icon_domainname_big",@"name":@"域名诊断",@"sourceType":@7}]},@{@"title":@"深度诊断",@"type":@2,@"datas":@[@{@"icon":@"icon_mainframe_big",@"name":@"主机诊断",@"sourceType":@5},@{@"icon":@"icon_foresight_big",@"name":@"先见数据平台",@"sourceType":@6}]}];
    
    AddSourceItemView *viewClould = [[AddSourceItemView alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), ZOOM_SCALE(216))];
    viewClould.data = array[0];
    [self.view addSubview:viewClould];
    viewClould.backgroundColor = PWWhiteColor;
    viewClould.layer.cornerRadius = 4.0f;
   
    viewClould.itemClick = ^(NSInteger index){
        NSDictionary *dict = array[0][@"datas"][index];
        [self loadTeamProductWithClickIndex:[dict[@"sourceType"] intValue]];
    };
    AddSourceItemView *deepView = [[AddSourceItemView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(216)+Interval(24), kWidth-Interval(32), ZOOM_SCALE(137))];
    deepView.data = array[1];
    deepView.backgroundColor = PWWhiteColor;
    deepView.layer.cornerRadius = 4.0f;
    [self.view addSubview:deepView];
    deepView.itemClick = ^(NSInteger index){
        if (index==0) {
            HostDiagnosisVC *host = [[HostDiagnosisVC alloc]init];
            [self.navigationController pushViewController:host animated:YES];
        }else{
            ClusterDiagnosisVC *prophet = [[ClusterDiagnosisVC alloc]init];
            [self.navigationController pushViewController:prophet animated:YES];
        }
    };
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.layer.cornerRadius = 4.0f;
    moreBtn.backgroundColor = PWWhiteColor;
    [moreBtn setTitle:@"更多诊断服务" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = RegularFONT(18);
    [moreBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(deepView.mas_bottom).offset(Interval(25));
        make.height.offset(ZOOM_SCALE(47));
    }];
}
- (void)rightNavClick{
    IssueSourceHelperVC *explain = [[IssueSourceHelperVC alloc]init];
    [self.navigationController pushViewController:explain animated:YES];
}
- (void)moreBtnClick{
    AddIssueSourceMoreServicesVC *moreVC = [[AddIssueSourceMoreServicesVC alloc]init];
    [self.navigationController pushViewController:moreVC animated:YES];
}
#pragma mark ========== 获取常量表 ==========
- (void)loadTeamProductWithClickIndex:(NSInteger )index{
    
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[@"errorCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [self dealWithData:content withType:index];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)dealWithData:(NSArray *)content withType:(NSInteger)type{
   __block NSDictionary *basic_source;
    [content enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([[obj stringValueForKey:@"code" default:@""] isEqualToString:@"basic_source"]) {
        basic_source = obj;
    }
    }];
    
    BOOL isDefault = [basic_source boolValueForKey:@"isDefault" default:NO];
    self.isDefault = isDefault;
    NSInteger value =[basic_source longValueForKey:@"value" default:1];
    DLog(@"%@",getTeamState);
  
    NSInteger count = [[IssueSourceManger sharedIssueSourceManger] getBasicIssueSourceCount];
    if (count>=value) {
        AddSourceTipVC *tipVC = [[AddSourceTipVC alloc]init];
        [self.navigationController pushViewController:tipVC animated:YES];

    }else{
        IssueSourceDetailVC *source = [[IssueSourceDetailVC alloc]init];
        [self.navigationController pushViewController:source animated:YES];
        source.type = type;
        source.isDefault = self.isDefault;
        source.isAdd = YES;
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
