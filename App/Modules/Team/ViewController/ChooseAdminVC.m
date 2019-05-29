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
#import "ZTSearchBar.h"
@interface ChooseAdminVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) ZTSearchBar *ztsearchbar;
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
    _ztsearchbar = [[ZTSearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _ztsearchbar.backgroundColor = PWWhiteColor;
    self.tableView.tableHeaderView = _ztsearchbar;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(58);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TeamMemberCell class] forCellReuseIdentifier:@"TeamMemberCell"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    //对搜索框中输入的内容进行监听
    __weak typeof(self) zt_weakSelf = self;
    [[_ztsearchbar.tf rac_textSignal] subscribeNext:^(id x) {
        [zt_weakSelf updateSearchResultsForSearchBar:zt_weakSelf.ztsearchbar];
    }];
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
    if ([self.ztsearchbar.tf isFirstResponder]) {
        
        return self.results.count ;
    }
    return self.teamMemberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    if ([self.ztsearchbar.tf isFirstResponder]) {
        cell.model = self.results[indexPath.row];
    } else {
       cell.model = self.teamMemberArray[indexPath.row];
    }
    
    cell.phoneBtn.hidden = YES;
    cell.line.hidden = indexPath.row == self.teamMemberArray.count-1?YES:NO;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        MemberInfoModel *model = self.teamMemberArray[indexPath.row];
        MemberInfoVC *member = [[MemberInfoVC alloc]init];
        member.isHidenNaviBar = YES;
        member.type = PWMemberViewTypeTrans;
        member.teamMemberRefresh =^(){
            [self loadTeamMemberInfo];
        };
        member.memberBeizhuChangeBlock = ^(NSString * _Nonnull name) {
            model.inTeamNote = name;
            [self.tableView reloadData];
        };
        member.model = model;
        [self.navigationController pushViewController:member animated:YES];
    
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchBar:(ZTSearchBar *)searchBar{
    NSString *inputStr = searchBar.tf.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //排除直接点击searchbar显示问题
    if (inputStr == nil || inputStr.length == 0){
        [self.results addObjectsFromArray:self.teamMemberArray];
        [self.tableView reloadData];
        return;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.ztsearchbar.tf.text.length > 0){
        [self.ztsearchbar.tf becomeFirstResponder];
    }
}
- (void)dealloc{
    DLog(@"%s",__func__);
    [self.ztsearchbar.tf resignFirstResponder];
}
@end
