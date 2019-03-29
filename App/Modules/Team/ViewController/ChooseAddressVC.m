//
//  ChooseAddressVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseAddressVC.h"
#import "DistrictCell.h"
#import "CityCell.h"

@interface ChooseAddressVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *districtAry;
@property (nonatomic, strong) UILabel *currentDisLab;
@property (nonatomic, strong) NSMutableArray *cityAry;
@property (nonatomic, strong) UICollectionView *cityCollectionView;
@property (nonatomic, copy) NSString *province;
@end
@implementation ChooseAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择所在地";
    self.cityAry = [NSMutableArray new];
    [self createUI];
    [self grtAdressData];
    // Do any additional setup after loading the view.
}
- (void)grtAdressData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"keys":@"district"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:NO cache:YES params:param progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content  =response[@"content"];
            NSArray *district = content[@"district"];
            if (district.count>0) {
                self.districtAry = [NSMutableArray arrayWithArray:district];
                [self.tableView reloadData];
                [self setFistSelect];
            }
            [SVProgressHUD dismiss];
            
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
- (void)setFistSelect{
//    [self.districtAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DistrictCell *cell = (DistrictCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
    self.province = self.districtAry[indexPath.row][@"name"];
    [self.cityCollectionView reloadData];

    NSDictionary *dict = self.districtAry[indexPath.row];
    if (self.cityAry.count) {
        [self.cityAry removeAllObjects];
        [self.cityCollectionView reloadData];
    }
    [self.cityAry addObjectsFromArray:dict[@"children"]];
    [self.cityCollectionView reloadData];

}
- (void)createUI{
    self.tableView.rowHeight =ZOOM_SCALE(50);
    self.tableView.backgroundColor = PWWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.tableView registerClass:[DistrictCell class] forCellReuseIdentifier:@"DistrictCell"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.cityCollectionView];
    if (self.currentCity == nil || [self.currentCity isEqualToString:@""] || [self.currentProvince isEqualToString:@""]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
            make.width.offset(ZOOM_SCALE(88));
        }];
        [self.cityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.tableView.mas_right);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
    }else{
        NSString *city = self.currentCity?self.currentCity:self.currentProvince;
        self.currentDisLab.text = [NSString stringWithFormat:@"当前选择城市：%@",city];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentDisLab.mas_bottom);
            make.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
            make.width.offset(ZOOM_SCALE(88));
        }];
        [self.cityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentDisLab.mas_bottom);
            make.left.mas_equalTo(self.tableView.mas_right);
            make.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    
    
}
-(UILabel *)currentDisLab{
    if (!_currentDisLab) {
        _currentDisLab = [PWCommonCtrl lableWithFrame:CGRectMake(-1, -1, kWidth+2, ZOOM_SCALE(44)) font:MediumFONT(16) textColor:PWTextBlackColor text:@""];
        _currentDisLab.backgroundColor = PWWhiteColor;
        _currentDisLab.layer.borderWidth = 1;//边框宽度
        _currentDisLab.layer.borderColor = [UIColor colorWithHexString:@"#C7C7CC"].CGColor;
        _currentDisLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_currentDisLab];
    }
    return _currentDisLab;
}
- (UICollectionView *)cityCollectionView{
    if (!_cityCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsMake(10,10,20,10);
        //该方法也可以设置itemSize
//        layout.itemSize =CGSizeMake(kWidth-2*Interval(16), ZOOM_SCALE(64));
        layout.itemSize = CGSizeMake(ZOOM_SCALE(125), ZOOM_SCALE(40));

        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;

        _cityCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _cityCollectionView.dataSource = self;
        _cityCollectionView.delegate = self;
        _cityCollectionView.scrollEnabled = YES;
        _cityCollectionView.backgroundColor = PWWhiteColor;
        [_cityCollectionView registerClass:[CityCell class] forCellWithReuseIdentifier:@"CityCell"];
        
    }
    return _cityCollectionView;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.districtAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DistrictCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistrictCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *name =self.districtAry[indexPath.row][@"name"];
    cell.title = name;
    
    self.province = self.districtAry[indexPath.row][@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=0) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
        DistrictCell *cell = (DistrictCell *)[self.tableView cellForRowAtIndexPath:indexPath1];
        [cell setSelected:NO];
    }
    NSDictionary *dict = self.districtAry[indexPath.row];
    if (self.cityAry.count) {
        [self.cityAry removeAllObjects];
        [self.cityCollectionView reloadData];
    }
    [self.cityAry addObjectsFromArray:dict[@"children"]];
    self.province = self.districtAry[indexPath.row][@"name"];
    [self.cityCollectionView reloadData];
}
#pragma mark ========== ui ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityAry.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityCell" forIndexPath:indexPath];
    NSString *name =self.cityAry[indexPath.row][@"name"];
    cell.titleLab.text = name;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
     CityCell *cell = (CityCell *)[collectionView cellForItemAtIndexPath:indexPath];
     NSString *text = [NSString stringWithFormat:@"%@ %@",self.province,cell.titleLab.text];
    
    if (self.itemClick) {
        self.itemClick(text);
        [self.navigationController popViewControllerAnimated:YES];
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
