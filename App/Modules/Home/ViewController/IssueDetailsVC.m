//
//  IssueDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueDetailsVC.h"
#import "IssueListViewModel.h"
#import "IssueEngineHeaderView.h"
#import "IssueUserDetailView.h"
#import "IssueSourceManger.h"
@interface IssueDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IssueEngineHeaderView *engineHeader;  //来自情报源
@property (nonatomic, strong) IssueUserDetailView *userHeader;      //来自自建问题
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation IssueDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"情报详情";
    [self createUI];
    [self loadIssueLog];
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-SafeAreaBottom_Height-ZOOM_SCALE(67));
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    if(self.model.isFromUser){
        self.tableView.tableHeaderView = self.userHeader;
        [self.userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.right.left.mas_equalTo(self.tableView);
        }];
        [self loadIssueDetailExtra];
    }else{
        self.tableView.tableHeaderView = self.engineHeader;
        [self.engineHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.right.left.mas_equalTo(self.tableView);
        }];
        [self loadInfoDeatil];
    }
}
- (void)loadIssueLog{

}
-(IssueEngineHeaderView *)engineHeader{
    if (!_engineHeader) {
        _engineHeader = [[IssueEngineHeaderView alloc]initHeaderWithIssueModel:self.model];
        _engineHeader.backgroundColor = PWBackgroundColor;
    }
    return _engineHeader;
}
-(IssueUserDetailView *)userHeader{
    if (!_userHeader) {
        _userHeader = [[IssueUserDetailView alloc]initHeaderWithIssueModel:self.model];
        _userHeader.backgroundColor = PWBackgroundColor;
    }
    return _userHeader;
}
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            [self loadIssueSourceDetail:content];
            [self.engineHeader createUIWithDetailDict:content];
            [self.engineHeader layoutIfNeeded];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView = self.engineHeader;
            });
           
        }else{
            [SVProgressHUD dismiss];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)loadIssueSourceDetail:(NSDictionary *)dict{
    NSString *issueSourceID = [dict stringValueForKey:@"issueSourceId" default:@""];
    NSString *type = [dict stringValueForKey:@"itAssetProvider_cache" default:@""];
    
    if (self.model.isInvalidIssue) {
        [userManager getissueSourceNameByKey:type name:^(NSString *name1) {
          [self.engineHeader setContentLabText:[NSString stringWithFormat:@"您的 %@云服务 %@ 最近一次检测失效，请检查该云服务是否存在问题。",name1,self.model.sourceName]];
        }];
    }
    if ([type isEqualToString:@"carrier.corsairmaster"]){
        
        if([self.model.sourceName isEqualToString:@""] || self.model.sourceName == nil){
            [self loadIssueSuperSourceDetail:issueSourceID issueProvider:type];
        }else{
            [SVProgressHUD dismiss];
        }
        return;
    }
    
    [SVProgressHUD dismiss];
}
#pragma mark ========== 请求一级云服务详情 获取云服务名称 ==========
- (void)loadIssueSuperSourceDetail:(NSString *)issueSourceId issueProvider:(NSString *)provider{
    NSDictionary *param = @{@"id":issueSourceId};
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSArray *data = PWSafeArrayVal(content, @"data");
            if (data.count>0) {
                if ([data[0] isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dict = data[0];
                    NSDictionary *source  = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameAndProviderWithID:[dict stringValueForKey:@"parentId" default:@""]];
                    [self.engineHeader setIssueNameLabText:[source stringValueForKey:@"name" default:@""]];
                    if (self.model.isInvalidIssue) {
                        [userManager getissueSourceNameByKey:provider name:^(NSString *name1) {
                            [self.engineHeader setContentLabText:[NSString stringWithFormat:@"您的 %@云服务 %@ 最近一次检测失效，请检查该云服务是否存在问题。",name1,[source stringValueForKey:@"name" default:@""]]];
                        }];
                    }
                }
            }
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)loadIssueDetailExtra{
    DLog(@"self.model.issueId = %@",self.model.issueId);
    NSDictionary *param = @{@"pageSize": @100,
                            @"type":@"attachment",
                            @"subType":@"issueDetailExtra",
                            @"_withAttachmentExternalDownloadURL":@YES,
                            @"_attachmentExternalDownloadURLOSSExpires":@(3600),
                            @"issueId":self.model.issueId
                            };
    [PWNetworking requsetHasTokenWithUrl:PW_issueLog withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            [self.userHeader createAttachmentUIWithAry:data];
            [self.userHeader layoutIfNeeded];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView = self.userHeader;
            });
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    view.backgroundColor = PWWhiteColor;
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"讨论"];
    [view addSubview:title];
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(16);
        make.height.centerY.mas_equalTo(view);
    }];
    return view;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
