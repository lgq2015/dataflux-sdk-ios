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
@property (nonatomic, assign) NSInteger selectCityInd; //已选城市的索引
@property (nonatomic, assign) NSInteger selectProvInd; //已选省份的索引
@property (nonatomic, copy) NSString *province;
@end
@implementation ChooseAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.ChooseTheLocation", @"");
    self.cityAry = [NSMutableArray new];
    [self createUI];
    [self grtAdressData];
    // Do any additional setup after loading the view.
}
- (void)grtAdressData{
    [SVProgressHUD show];
    NSDictionary *param = @{@"keys":@"district"};
    [PWNetworking requsetWithUrl:PW_utilsConst withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if (![response[ERROR_CODE] isKindOfClass:[NSNull class]] &&[response[ERROR_CODE] isEqualToString:@""] ) {
            NSDictionary *content  =response[@"content"];
            NSArray *district = content[@"district"];
            if (district.count>0) {
                self.districtAry = [NSMutableArray arrayWithArray:district];
                //再次进入，定位所选城市
                _selectProvInd = [self selectedProvinceIndex];
                [self setFistSelect:_selectProvInd];
                _selectCityInd = [self selectedCityIndex];
                [self.tableView reloadData];
                [self.cityCollectionView reloadData];
            }
            [SVProgressHUD dismiss];
            
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
- (void)setFistSelect:(NSInteger)selectedIndex{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    self.province = self.districtAry[indexPath.row][@"name"];
    NSDictionary *dict = self.districtAry[indexPath.row];
    if (self.cityAry.count) {
        [self.cityAry removeAllObjects];
    }
    [self.cityAry addObjectsFromArray:dict[@"children"]];
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
        self.currentDisLab.text = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"local.CurrentCitySelection", @""),city];
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
        _currentDisLab = [PWCommonCtrl lableWithFrame:CGRectMake(-1, -1, kWidth+2, ZOOM_SCALE(44)) font:RegularFONT(16) textColor:PWTextBlackColor text:@""];
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
    DistrictCell *cell = (DistrictCell *)[tableView dequeueReusableCellWithIdentifier:@"DistrictCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *name =self.districtAry[indexPath.row][@"name"];
    cell.title = name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectProvInd = indexPath.row;
    NSDictionary *dict = self.districtAry[indexPath.row];
    if (self.cityAry.count) {
        [self.cityAry removeAllObjects];
        [self.cityCollectionView reloadData];
    }
    [self.cityAry addObjectsFromArray:dict[@"children"]];
    self.province = self.districtAry[indexPath.row][@"name"];
    [self.cityCollectionView reloadData];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView){
        if(indexPath.row == _selectProvInd){
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    }
    
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
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _selectCityInd && [self.province isEqualToString:self.currentProvince]){
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     CityCell *cell = (CityCell *)[collectionView cellForItemAtIndexPath:indexPath];
     NSString *text = [NSString stringWithFormat:@"%@ %@",self.province,cell.titleLab.text];
    if (self.itemClick) {
        self.itemClick(text);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//获取已选省份的索引
- (NSInteger)selectedProvinceIndex{
    __block NSInteger provinceIndex = 0;
    if (self.currentProvince.length > 0){
        [self.districtAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *name = [dic stringValueForKey:@"name" default:@""];
            if ([name isEqualToString:self.currentProvince]){
                provinceIndex = idx;
                *stop = NO;
            }
        }];
    }
    return provinceIndex;
}
//获取已选城市的索引
- (NSInteger)selectedCityIndex{
    __block NSInteger cityIndex = 0;
    if (self.currentCity.length > 0){
        [self.cityAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *name = [dic stringValueForKey:@"name" default:@""];
            if ([name isEqualToString:self.currentCity]){
                cityIndex = idx;
                *stop = NO;
            }
        }];
    }
    return cityIndex;
}
@end
