//
//  AddSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddSourceVC.h"
#import "AddSourceCell.h"
#import "SourceVC.h"
#import "AddSourceItemView.h"
#import "HostDiagnosisVC.h"
#import "ProphetMonitorVC.h"
#import "ExplainVC.h"
#import "MoreServicesVC.h"
#import "AddSourceTipView.h"
#import "TeamInfoModel.h"
#import "IssueSourceManger.h"
#import "AddSourceTipVC.h"

@interface AddSourceVC ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isDefault;
@end

@implementation AddSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加情报源";
    [self createUI];
  
    // Do any additional setup after loading the view.
}
- (void)createUI{
  
    
    [self addNavigationItemWithImageNames:@[@"home_question"] isLeft:NO target:self action:@selector(rightNavClick) tags:@[@10]];
    
    NSArray *array = @[@{@"title":@"连接云服务",@"type":@1,@"datas":@[@{@"icon":@"icon_ali",@"name":@"阿里云",@"sourceType":@1},@{@"icon":@"icon_aws",@"name":@"AWS",@"sourceType":@2},@{@"icon":@"icon_tencent",@"name":@"腾讯云",@"sourceType":@3},@{@"icon":@"Ucloud",@"name":@"UCloud",@"sourceType":@4},@{@"icon":@"icon_domainname",@"name":@"域名诊断",@"sourceType":@7}]},@{@"title":@"深度诊断",@"type":@2,@"datas":@[@{@"icon":@"icon_single",@"name":@"主机诊断",@"sourceType":@5},@{@"icon":@"icon_cluster",@"name":@"先见数据平台",@"sourceType":@6}]}];
    
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
            ProphetMonitorVC *prophet = [[ProphetMonitorVC alloc]init];
            [self.navigationController pushViewController:prophet animated:YES];
        }
    };
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.layer.cornerRadius = 4.0f;
    moreBtn.backgroundColor = PWWhiteColor;
    [moreBtn setTitle:@"更多诊断服务" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = MediumFONT(18);
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
    ExplainVC *explain = [[ExplainVC alloc]init];
    [self.navigationController pushViewController:explain animated:YES];
}
- (void)moreBtnClick{
    MoreServicesVC *moreVC = [[MoreServicesVC alloc]init];
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
        SourceVC *source = [[SourceVC alloc]init];
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
