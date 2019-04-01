//
//  HandbookIndexVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HandbookIndexVC.h"
#import "LibraryModel.h"
#import "UITableView+SCIndexView.h"
#import "HandbookModel.h"
#import "ZLChineseToPinyin.h"
#import "NewsWebView.h"
#import "SearchVC.h"
@interface HandbookIndexVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
// 索引标题数组(排序后的出现过的拼音首字母数组)
@property(nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) UIView *searchView;

// 排序好的结果数组
@property(nonatomic, strong) NSMutableArray *resultArr;
@property (nonatomic, strong) NSMutableArray *totalData;
@end

@implementation HandbookIndexVC
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = PWWhiteColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self createUI];
    [self loadData];
}
- (void)createUI{
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_gray"]];
    [self.searchView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchView);
        make.width.height.offset(ZOOM_SCALE(32));
        make.centerX.mas_equalTo(self.view).offset(-ZOOM_SCALE(21));
    }];
    UILabel *searchLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@"搜索"];
    [self.searchView addSubview:searchLab];
    [searchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(ZOOM_SCALE(6));
        make.centerY.mas_equalTo(icon);
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Interval(60), kWidth, kHeight-kTopHeight-Interval(60)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = NO;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), Interval(12), kWidth-Interval(32), ZOOM_SCALE(36))];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F5"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
        [_searchView addGestureRecognizer:tap];
        _searchView.layer.cornerRadius = 4.0f;
        [self.view addSubview:_searchView];
    }
    return _searchView;
}
- (void)searchClick{
    SearchVC *search = [[SearchVC alloc]init];
    search.isHidenNaviBar = YES;
    search.placeHolder = @"搜索发现";
    search.isLocal = YES;
    search.totalData = self.totalData;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)loadData{
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_handbook(self.model.handbookId) withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self dealWithData:content];

            }else{
                [self showNoDataImage];
            }
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)dealWithData:(NSArray *)data{
    self.totalData = [NSMutableArray new];
    [self.totalData addObjectsFromArray:data];
    self.indexArr = [ZLChineseToPinyin indexWithArray:data Key:@"firstChar"];
    self.dataSource = [ZLChineseToPinyin sortObjectArray:data Key:@"firstChar"];
    self.tableView.sc_indexViewDataSource = self.indexArr.copy;
    [self.tableView reloadData];
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        NSArray *sectionItem = self.dataSource[section];
        return sectionItem.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    SectionItem *sectionItem = self.tableViewDataSource[indexPath.section];
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.section][indexPath.row] error:&error];
    cell.textLabel.text = model.title;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.indexArr[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:self.dataSource[indexPath.section][indexPath.row] error:&error];
    DLog(@"%@",PW_handbookUrl(model.articleId));
    NewsWebView *webview = [[NewsWebView alloc]initWithTitle:model.title andURLString:PW_handbookUrl(model.articleId)];
    webview.handbookModel = model;
    [self.navigationController pushViewController:webview animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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
