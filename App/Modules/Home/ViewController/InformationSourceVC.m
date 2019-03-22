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
#import "IssueSourceManger.h"
#define TagNoDataImageView  150
@interface InformationSourceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger  currentPage;

@property (nonatomic, strong) UIView *nodataView;
@end

@implementation InformationSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报源";
    [self createUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRereshing)
                                                 name:KNotificationIssueSourceChange
                                               object:nil];
}
- (void)createUI{
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    NSMutableArray *newMarr = [NSMutableArray arrayWithArray:marr];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[SourceVC class]] || [vc isKindOfClass:[AddSourceVC class]]) {
            [newMarr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = newMarr;
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
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            NSDictionary *basic_source = content[0];
            BOOL isdefault = [basic_source boolValueForKey:@"isDefault" default:NO];
            completion(isdefault);
        }else{
        completion(NO);
        }
    } failBlock:^(NSError *error) {
        completion(NO);
        [SVProgressHUD dismiss];
    }];
}
- (void)loadData{
    NSArray *array =  [[IssueSourceManger sharedIssueSourceManger] getIssueSourceList];
    self.dataSource = [NSMutableArray new];
    [self.dataSource addObjectsFromArray:array];
    if (self.dataSource.count>0) {
        [self.tableView reloadData];
        self.tableView.tableFooterView = self.footView;
    }else{
        [self showNoDataImageView];
    }
    [[IssueSourceManger sharedIssueSourceManger] updateAllIssueSourceList:^(NSArray * _Nonnull ary) {
        if (ary.count>0) {
            [self hideNoDataImageView];
            self.dataSource = [NSMutableArray new];
            [self.dataSource addObjectsFromArray:ary];
            self.tableView.tableFooterView = self.footView;
            [self.tableView reloadData];
        }else{
            [self showNoDataImageView];
        }
    }];
     [self.header endRefreshing];
}
-(void)hideNoDataImageView{
    NSArray *title = @[@"添加"];
    if([getTeamState isEqualToString:PW_isTeam]){
        BOOL isadmain = userManager.teamModel.isAdmin;
        if (isadmain) {
            [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
        }
    }else{
        [self addNavigationItemWithTitles:title isLeft:NO target:self action:@selector(addInfoSource) tags:@[@100]];
    }
    self.nodataView.hidden = YES;
    self.tableView.hidden = NO;
}
-(void)showNoDataImageView{
    self.navigationItem.rightBarButtonItem = nil;
    if (self.tableView) {
        self.tableView.hidden = YES;
    }
    self.nodataView.hidden = NO;
    
}
-(UIView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
        _nodataView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_nodataView];
        
        UIImageView *bgImgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blank_page"]];
        [_nodataView addSubview:bgImgview];
        [bgImgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataView).offset(Interval(47));
            make.width.offset(ZOOM_SCALE(222));
            make.height.offset(ZOOM_SCALE(190));
            make.centerX.mas_equalTo(_nodataView);
        }];
        UILabel *tip = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTitleColor text:@"您还没有添加情报源"];
        tip.textAlignment = NSTextAlignmentCenter;
        [_nodataView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgImgview.mas_bottom).offset(Interval(31));
            make.left.right.mas_equalTo(self.view);
            make.height.offset(ZOOM_SCALE(22));
        }];
        if ([getTeamState isEqualToString:PW_isTeam]) {
            if(userManager.teamModel.isAdmin){
                UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"添加"];
                [_nodataView addSubview:commitBtn];
                [commitBtn addTarget:self action:@selector(addInfoSource) forControlEvents:UIControlEventTouchUpInside];
                [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_nodataView).offset(Interval(16));
                    make.right.mas_equalTo(_nodataView).offset(-Interval(16));
                    make.top.mas_equalTo(tip.mas_bottom).offset(Interval(74));
                    make.height.offset(ZOOM_SCALE(47));
                }];
            }
        }else{
            UIButton *commitBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"添加"];
            [_nodataView addSubview:commitBtn];
            [commitBtn addTarget:self action:@selector(addInfoSource) forControlEvents:UIControlEventTouchUpInside];
            [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_nodataView).offset(Interval(16));
                make.right.mas_equalTo(_nodataView).offset(-Interval(16));
                make.top.mas_equalTo(tip.mas_bottom).offset(Interval(74));
                make.height.offset(ZOOM_SCALE(47));
            }];
        }
            
    }
    return _nodataView;
}
-(void)headerRereshing{
    self.currentPage = 1;
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
