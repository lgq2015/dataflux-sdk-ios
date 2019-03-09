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
@interface AddSourceVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AddSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加情报源";
    [self loadUtils];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
//    self.layout = [[UICollectionViewFlowLayout alloc]init];
//    self.layout.itemSize = CGSizeMake(kWidth-Interval(36), ZOOM_SCALE(134));
//    self.layout.minimumLineSpacing = Interval(12);
//    self.layout.minimumInteritemSpacing =Interval(12);
//    [self.view addSubview:self.collectionView];
//    self.collectionView.backgroundColor = PWBackgroundColor;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[AddSourceCell class] forCellWithReuseIdentifier:@"AddSourceCell"];
    NSArray *array = @[@{@"title":@"连接云服务",@"type":@1,@"datas":@[@{@"icon":@"icon_ali",@"name":@"阿里云",@"sourceType":@1},@{@"icon":@"icon_aws",@"name":@"AWS",@"sourceType":@2},@{@"icon":@"icon_tencent",@"name":@"腾讯云",@"sourceType":@3},@{@"icon":@"Ucloud",@"name":@"Ucloud",@"sourceType":@4},@{@"icon":@"icon_domainname",@"name":@"域名诊断",@"sourceType":@5}]},@{@"title":@"深度诊断",@"type":@2,@"datas":@[@{@"icon":@"icon_single",@"name":@"主机诊断",@"sourceType":@5},@{@"icon":@"icon_cluster",@"name":@"先知监控",@"sourceType":@6}]}];
    
    AddSourceItemView *viewClould = [[AddSourceItemView alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), ZOOM_SCALE(216))];
    viewClould.data = array[0];
    [self.view addSubview:viewClould];
    viewClould.backgroundColor = PWWhiteColor;
    viewClould.layer.cornerRadius = 4.0f;
   
    viewClould.itemClick = ^(NSInteger index){
        SourceVC *source = [[SourceVC alloc]init];
        [self.navigationController pushViewController:source animated:YES];
        NSDictionary *dict = array[0][@"datas"][index];
        source.type = [dict[@"sourceType"] intValue];
        source.isAdd = YES;
    };
    AddSourceItemView *deepView = [[AddSourceItemView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(216)+Interval(24), kWidth-Interval(32), ZOOM_SCALE(137))];
    deepView.data = array[1];
    deepView.backgroundColor = PWWhiteColor;
    deepView.layer.cornerRadius = 4.0f;
    [self.view addSubview:deepView];
    deepView.itemClick = ^(NSInteger index){
        SourceVC *source = [[SourceVC alloc]init];
        [self.navigationController pushViewController:source animated:YES];
        NSDictionary *dict = array[1][@"datas"][index];
        source.type = [dict[@"sourceType"] intValue];
        source.isAdd = YES;
    };
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.layer.cornerRadius = 4.0f;
    moreBtn.backgroundColor = PWWhiteColor;
    [moreBtn setTitle:@"更多诊断服务" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = MediumFONT(18);
    [moreBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
    [self.view addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(deepView.mas_bottom).offset(Interval(25));
    }];
}
#pragma mark ========== 获取常量表 ==========
- (void)loadUtils{
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:NO cache:NO params:@{@"keys":@"issueSourceProvider"} progressBlock:nil successBlock:^(id response) {
        DLog(@"%@",response);
    } failBlock:^(NSError *error) {
        DLog(@"%@",error);
    }];
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
