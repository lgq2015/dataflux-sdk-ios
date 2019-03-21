//
//  ChooseAdminVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseAdminVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"
#import "MemberInfoVC.h"
@interface ChooseAdminVC ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation ChooseAdminVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择管理员";
    [self loadTeamMemberInfo];
    [self createUI];
    
    // Do any additional setup after loading the view.
}
- (void)createUI{
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    search.hidesNavigationBarDuringPresentation = NO;
    search.searchBar.layer.cornerRadius = 4.0f;
    search.searchBar.layer.masksToBounds = YES;
    search.searchBar.placeholder = @"搜索暗提示";
    [search.searchBar setBackgroundImage:[UIImage imageWithColor:PWWhiteColor]];
    //设置背景色
    [search.searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
   [search.searchBar setSearchFieldBackgroundImage:[self GetImageWithColor:[UIColor colorWithHexString:@"F1F2F5"] andHeight:36] forState:UIControlStateNormal];

    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
  
    self.tableView.tableHeaderView = search.searchBar;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(58);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
}
- (void)loadTeamMemberInfo{
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
           [self dealWithDatas:member];
        }
    }];
  
    [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            [self dealWithDatas:content];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
- (void)dealWithDatas:(NSArray *)content{
    self.teamMemberArray = [NSMutableArray new];
    [content enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:dict error:&error];
        NSString *memberID= [model.memberID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if (![memberID  isEqualToString:getPWUserID]) {
         [self.teamMemberArray addObject:model];
        }
    }];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}
- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    return self.teamMemberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    if (self.searchController.active ) {
        cell.model = self.results[indexPath.row];
    } else {
       cell.model = self.teamMemberArray[indexPath.row];
    }
    
    cell.phoneBtn.hidden = YES;
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       self.searchController.active = NO;
        MemberInfoVC *member = [[MemberInfoVC alloc]init];
        member.isHidenNaviBar = YES;
        member.isInfo = NO;
        member.teamMemberRefresh =^(){
            [self loadTeamMemberInfo];
        };
        member.model = self.teamMemberArray[indexPath.row];
        [self.navigationController pushViewController:member animated:YES];
    
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    [self.teamMemberArray enumerateObjectsUsingBlock:^(MemberInfoModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *mobile = obj.mobile;
        NSString *name = obj.name;
        NSString *email = obj.email;
        if (mobile != nil &&[mobile rangeOfString:inputStr].location != NSNotFound) {
            [self.results addObject:obj];
        }else if(name !=nil &&[name rangeOfString:inputStr].location != NSNotFound){
             [self.results addObject:obj];
        }else if(email !=nil &&[email rangeOfString:inputStr].location !=NSNotFound){
            [self.results addObject:obj];
        }
    }];
    DLog(@"%lu",(unsigned long)self.results.count);
     [self.tableView reloadData];
}
- (UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
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
