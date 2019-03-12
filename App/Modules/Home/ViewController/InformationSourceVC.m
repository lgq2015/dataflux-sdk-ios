//
//  InformationSourceVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InformationSourceVC.h"
#import "InformationSourceCell.h"
#import "TeamInfoModel.h"
#import "AddSourceVC.h"
#import "SourceVC.h"
@interface InformationSourceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger  currentPage;

@end

@implementation InformationSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报源";
    [self createUI];
    [SVProgressHUD show];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRereshing)
                                                 name:KNotificationIssueSourceChange
                                               object:nil];
}
- (void)createUI{
    NSArray *title = @[@"添加"];
    self.currentPage = 1;
    DLog(@"%d",userManager.teamModel.isAdmin);
    if(getTeamState){
        BOOL isadmain = userManager.teamModel.isAdmin;
        if (isadmain) {
            [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
        }
    }else{
        [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    }
//    if(!(self.isFromTeam && !userManager.teamModel.isAdmin)){
//    [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
//    }
    self.dataSource = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_footer = self.footer;
    self.tableView.mj_header = self.header;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[InformationSourceCell class] forCellReuseIdentifier:@"InformationSourceCell"];
}
- (void)loadTeamProductcompletion:(void(^)(BOOL isDefault))completion{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_TeamProduct withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            NSDictionary *basic_source = content[0];
            completion(basic_source[@"isDefault"]);
        }else{
        completion(NO);
        }
    } failBlock:^(NSError *error) {
        completion(NO);
        [SVProgressHUD dismiss];
    }];
}
- (void)loadData{

    NSDictionary *param = @{@"pageNumber":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@10};
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            if (data.count>0) {
                if (self.currentPage == 1) {
                    self.dataSource = [NSMutableArray arrayWithArray:data];
                }else{
                    [self.dataSource addObjectsFromArray:data];
                }
                [self.tableView reloadData];
                if ([content[@"pageInfo"][@"pageCount"] integerValue]>self.currentPage) {
                    self.currentPage++;
                    [self.footer endRefreshing];
                }else{
                    self.footer.state = MJRefreshStateNoMoreData;
                }
                 [self removeNoDataImage];
            }else{
                if (self.currentPage == 1) {
                    [self showNoDataImageView];
                }
            }
        }else{
         [iToast alertWithTitleCenter:NSLocalizedString(response[@"errCode"], @"")];
        }
        [SVProgressHUD dismiss];
        [self.header endRefreshing];
    } failBlock:^(NSError *error) {
        if (self.currentPage == 1) {
            [self showNoDataImage];
        }
        [self.header endRefreshing];
    }];
}
-(void)showNoDataImageView{
    self.navigationItem.rightBarButtonItem = nil;
    [self.view removeAllSubviews];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
    contentView.backgroundColor = PWWhiteColor;
    [self.view addSubview:contentView];
    
    UIImageView *bgImgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank_page"]];
    [contentView addSubview:bgImgview];
    [bgImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(Interval(47));
        make.width.offset(ZOOM_SCALE(222));
        make.height.offset(ZOOM_SCALE(190));
        make.centerX.mas_equalTo(contentView);
    }];
    UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTitleColor text:@"您还没有添加情报源"];
    tip.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImgview.mas_bottom).offset(Interval(31));
        make.left.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(22));
    }];
    if (PWisTeam) {
        if(userManager.teamModel.isAdmin){
            UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"添加"];
            [contentView addSubview:commitBtn];
            [commitBtn addTarget:self action:@selector(addInfoSource) forControlEvents:UIControlEventTouchUpInside];
            [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(contentView).offset(Interval(16));
                make.right.mas_equalTo(contentView).offset(-Interval(16));
                make.top.mas_equalTo(tip.mas_bottom).offset(Interval(74));
                make.height.offset(ZOOM_SCALE(47));
            }];
        }
    }
    
}

-(void)headerRereshing{
    self.currentPage = 1;
    [self loadData];
}
-(void)footerRereshing{
    [self loadData];
}
- (void)addInfoSource{
    AddSourceVC *addVC = [[AddSourceVC alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationSourceCell"];
    
    cell.model = [[PWInfoSourceModel alloc]initWithJsonDictionary:self.dataSource[indexPath.row]];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    InformationSourceCell *cell = (InformationSourceCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self loadTeamProductcompletion:^(BOOL isDefault) {
        SourceVC *source = [[SourceVC alloc]init];
        source.model = cell.model;
        source.isAdd = NO;
        source.isDefault = isDefault;
        [self.navigationController pushViewController:source animated:YES];
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
