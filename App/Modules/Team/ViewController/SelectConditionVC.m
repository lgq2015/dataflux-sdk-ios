//
//  SelectConditionVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectConditionVC.h"
#import "TagViewCell.h"
#import "AddNotiRuleCell.h"
#import "AddNotiRuleModel.h"
#import "RuleModel.h"
#import "IssueSourceManger.h"
#import "SelectVC.h"

@interface SelectConditionVC ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *keyStr;
@property (nonatomic, strong) NSString *valueStr;
@end

@implementation SelectConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.selectCondition", @"");
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
    }
    [self createUI];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset =  UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:AddNotiRuleCell.class forCellReuseIdentifier:@"AddNotiRuleCell"];
    [self.tableView registerClass:TagViewCell.class forCellReuseIdentifier:@"TagViewCell"];
    NSArray *titleAry = @[@"local.issueSource",@"local.type",@"local.level"];
    NSArray *subtitleAry ;
    if (self.model == nil) {
        self.model =[RuleModel new];
    subtitleAry =   @[NSLocalizedString(@"local.allIssueSource",@"") ,NSLocalizedString(@"local.allIssueType",@""),NSLocalizedString(@"local.allIssueLevel",@"")];
    }else{
        subtitleAry = @[[self sourceStr],[self issueTypeStr],[self issueLevelStr]];
    }
    for (NSInteger i=0; i<titleAry.count; i++) {
        
        AddNotiRuleModel *model = [[AddNotiRuleModel alloc]init];
        model.title = NSLocalizedString(titleAry[i], @"");
        model.subTitle =subtitleAry[i];
        [self.dataSource addObject:model];
    }
}
- (NSString *)sourceStr{
    NSString *source;
    if (self.model.issueSource.count == 0 ) {
        source =NSLocalizedString(@"local.allIssueSource",@"");
    }else{
        NSDictionary *sourceDict = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameAndProviderWithID:[self.model.issueSource firstObject]];
        if (sourceDict) {
            source = [sourceDict stringValueForKey:@"name" default:@""];
        }
    }
    return source;
}
- (NSString *)issueTypeStr{
    NSString *issueType = @"";
    if (self.model.type.count == 0 || self.model.type.count == 5) {
        issueType =NSLocalizedString(@"local.allIssueType",@"");
    }else{
        for (NSInteger i=0; i<self.model.type.count; i++) {
            if ([self.model.type[i] isEqualToString:@"alarm"]) {
                issueType= [issueType stringByAppendingString:@"、监控"];
            }else if ([self.model.type[i]  isEqualToString:@"security"]){
                issueType= [issueType stringByAppendingString:@"、安全"];
            }else if ([self.model.type[i]  isEqualToString:@"expense"]){
                issueType= [issueType stringByAppendingString:@"、费用"];
                
            }else if ([self.model.type[i]  isEqualToString:@"optimization"]){
                issueType= [issueType stringByAppendingString:@"、优化"];
            }else{
                issueType= [issueType stringByAppendingString:@"、提醒"];
            }
        }
        issueType = [issueType substringFromIndex:1];
    }
    return issueType;
}
- (NSString *)issueLevelStr{
    NSString  *issueLevel = @"";
    if (self.model.level.count == 0 || self.model.level.count == 3) {
        issueLevel =NSLocalizedString(@"local.allIssueLevel",@"");
    }else{
        for (NSInteger i=0; i<self.model.level.count; i++) {
            
            if ([self.model.level[i] isEqualToString:@"danger"]) {
              issueLevel = [issueLevel stringByAppendingString:@"、严重"];
            }else if([self.model.level[i] isEqualToString:@"warning"]){
              issueLevel=  [issueLevel stringByAppendingString:@"、警告"];
            }else{
              issueLevel=  [issueLevel stringByAppendingString:@"、提示"];
            }
    }
        issueLevel =   [issueLevel substringFromIndex:1];
    }
    return issueLevel;
}
-(void)backBtnClicked{
    if (self.valueStr.length>0 &&(self.keyStr == nil||self.keyStr.length==0)) {
        [iToast alertWithTitleCenter:@"标签键不能为空"];
        return;
    }
    if (self.keyStr.length>0) {
        NSString *value = self.valueStr.length>0?self.valueStr:@"";
        self.model.tags = @{self.keyStr:value};
    }else{
        self.model.tags =@{};
    }
    WeakSelf
    if (self.SelectConditionBlock) {
        self.SelectConditionBlock(weakSelf.model);
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ========== UITableViewDataSource ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ZOOM_SCALE(107);
    }else{
        return ZOOM_SCALE(67);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.dataSource.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        TagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagViewCell"];
        cell.model = self.model;
        WeakSelf
        cell.TagBlock = ^(NSString * _Nonnull key, NSString * _Nonnull value) {
            weakSelf.keyStr = key;
            weakSelf.valueStr = value;
        };
        return cell;
    }else{
        AddNotiRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddNotiRuleCell"];
        cell.model = self.dataSource[indexPath.row-1];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row !=0) {
    __block  AddNotiRuleModel *model = self.dataSource[indexPath.row-1];
        WeakSelf
    switch (indexPath.row) {
        case 1:{
            SelectVC *select = [[SelectVC alloc]initWithStyle:SelectIssueSource];
            select.model = weakSelf.model;
            select.selectBlock = ^(RuleModel * _Nonnull ruleModel) {
                weakSelf.model = weakSelf.model;
                model.subTitle = [weakSelf sourceStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:select animated:YES];
        }
            break;
        case 2:
        {
            SelectVC *select = [[SelectVC alloc]initWithStyle:SelectIssueType];
            select.model = self.model;
            select.selectBlock = ^(RuleModel * _Nonnull ruleModel) {
                weakSelf.model = ruleModel;
                model.subTitle = [weakSelf issueTypeStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:select animated:YES];
        }
            break;
        case 3:
        {
            SelectVC *select = [[SelectVC alloc]initWithStyle:SelectIssueLevel];
            select.model = self.model;
            select.selectBlock = ^(RuleModel * _Nonnull ruleModel) {
                weakSelf.model = ruleModel;
                model.subTitle = [weakSelf issueLevelStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:select animated:YES];
        }
            break;
        
    }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
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
