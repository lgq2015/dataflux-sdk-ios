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
@interface AddSourceVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AddSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加情报源";
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    self.layout.itemSize = CGSizeMake(kWidth-Interval(36), ZOOM_SCALE(134));
    self.layout.minimumLineSpacing = Interval(12);
    self.layout.minimumInteritemSpacing =Interval(12);
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = PWBackgroundColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[AddSourceCell class] forCellWithReuseIdentifier:@"AddSourceCell"];
    NSArray *array = @[@{@"title":@"连接云服务",@"type":@1,@"datas":@[@{@"icon":@"icon_ali",@"name":@"阿里云",@"sourceType":@1},@{@"icon":@"icon_aws",@"name":@"AWS",@"sourceType":@2},@{@"icon":@"icon_tencent",@"name":@"腾讯云",@"sourceType":@3},@{@"icon":@"icon_huawei",@"name":@"华为云",@"sourceType":@4}]},@{@"title":@"深度诊断",@"type":@2,@"datas":@[@{@"icon":@"icon_single",@"name":@"单机诊断",@"sourceType":@5},@{@"icon":@"icon_cluster",@"name":@"集群诊断",@"sourceType":@6}]},@{@"title":@"更多诊断服务",@"type":@3,@"datas":@[@{@"icon":@"icon_domainname",@"name":@"域名诊断",@"sourceType":@7},@{@"icon":@"icon_netscan",@"name":@"网站安全扫描",@"sourceType":@8},@{@"icon":@"icon_url",@"name":@"URL诊断",@"sourceType":@9}]}];
    self.dataSource = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];


}

#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AddSourceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddSourceCell" forIndexPath:indexPath];
    NSDictionary *data =self.dataSource[indexPath.row];
    cell.data = data;
    cell.backgroundColor = PWWhiteColor;
    NSArray *datas = data[@"datas"];
    cell.itemClick = ^(NSInteger index){
        SourceVC *source = [[SourceVC alloc]init];
        [self.navigationController pushViewController:source animated:YES];
        NSDictionary *dict = datas[index];
        source.type = [dict[@"sourceType"] intValue];
        source.isAdd = YES;
    };
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(Interval(12), 0, 0, 0);//分别为上、左、下、右
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
