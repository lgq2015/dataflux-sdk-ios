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
#import "IssueChatDatas.h"
#import "IssueChatBaseCell.h"
#import "MemberInfoVC.h"
#import "MemberInfoModel.h"
#import "IssueLogAttachmentUrl.h"
#import "IssueLogModel.h"
#import "IssueChatDataManager.h"
#import "IssueDtealsBV.h"
#import "ZTPopCommentView.h"
@interface IssueDetailsVC ()<UITableViewDelegate, UITableViewDataSource,PWChatBaseCellDelegate,IssueDtealsBVDelegate>
@property (nonatomic, strong) IssueEngineHeaderView *engineHeader;  //来自情报源
@property (nonatomic, strong) IssueUserDetailView *userHeader;      //来自自建问题
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) IssueDtealsBV *bottomBtnView; //底部伪输入框
@property (nonatomic, strong) ZTPopCommentView *popCommentView; //弹出输入框
@property (nonatomic, assign) IssueDealState state;
@property (nonatomic, copy) NSString *oldStr;     //输入内容
@end
@implementation IssueDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"情报详情";
    [self createUI];
    [self loadIssueLog];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentNotif:) name:@"zt_add_comment" object:nil];
}
- (void)addCommentNotif:(NSNotification *)notif{
    NSLog(@"neirong---%@",notif.userInfo[@"content"]);
    NSString *comment = notif.userInfo[@"content"];
    // 待处理： 空格
    self.bottomBtnView.oldStr = comment;
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-SafeAreaBottom_Height-ZOOM_SCALE(67));
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    [self.tableView registerClass:NSClassFromString(@"IssueChatTextCell") forCellReuseIdentifier:PWChatTextCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatImageCell") forCellReuseIdentifier:PWChatImageCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatFileCell") forCellReuseIdentifier:PWChatFileCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatSystermCell") forCellReuseIdentifier:PWChatSystermCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatKeyPointCell") forCellReuseIdentifier:PWChatKeyPointCellId];
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
    self.bottomBtnView  = [[IssueDtealsBV alloc] initWithFrame:CGRectMake(0, kHeight -kTopHeight-SafeAreaBottom_Height-ZOOM_SCALE(67), kWidth, ZOOM_SCALE(67))];
    self.bottomBtnView.delegate = self;
    self.state = IssueDealStateChat;
    [self.view addSubview:self.bottomBtnView];
    [self.view bringSubviewToFront:self.bottomBtnView];
}
#pragma mark ========== init ==========
-(ZTPopCommentView *)popCommentView{
    if (!_popCommentView) {
        _popCommentView =[[ZTPopCommentView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 200)];
    }
    return _popCommentView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)loadIssueLog{
    [IssueChatDatas LoadingMessagesStartWithChat:self.model.issueId callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
        });
    }];
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
#pragma mark ========== networking ==========
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
//请求一级云服务详情 获取云服务名称
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
#pragma mark ========== bottomBtnClick ==========
- (void)issueDtealsBVClick{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popCommentView.state = self.state;
        self.popCommentView.oldData = self.oldStr;
        
    });
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueChatMessagelLayout *layout = _dataSource[indexPath.row];
    IssueChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(IssueChatMessagelLayout *)self.dataSource[indexPath.row]cellHeight];
}

#pragma mark ========== PWChatBaseCellDelegate ==========
- (void)PWChatFileCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    
}

- (void)PWChatHeaderImgCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    MemberInfoVC *iconVC = [[MemberInfoVC alloc]init];
    
    if(layout.message.messageFrom == PWChatMessageFromMe ){
        iconVC.type = PWMemberViewTypeMe;
        [self getMemberAndTransModelInfo:layout vc:iconVC];
        if (iconVC.model == nil) return;
    }else if(layout.message.messageFrom == PWChatMessageFromOther){
        iconVC.type = PWMemberViewTypeTeamMember;
        [self getMemberAndTransModelInfo:layout vc:iconVC];
        if (iconVC.model == nil) return;
    }else if (layout.message.messageFrom == PWChatMessageFromStaff){
        iconVC.type = PWMemberViewTypeExpert;
        NSString *name = layout.message.nameStr?[layout.message.nameStr componentsSeparatedByString:@" "][0]:@"";
        if (layout.message.headerImgurl) {
            iconVC.expertDict = @{@"name":name,@"url":layout.message.headerImgurl};
        }else{
            iconVC.expertDict = @{@"name":name,@"url":@""};
        }
    }
    iconVC.isShowCustomNaviBar = YES;
    [self.navigationController pushViewController:iconVC animated:YES];

}
- (void)getMemberAndTransModelInfo:(IssueChatMessagelLayout *)layout vc:(MemberInfoVC *)iconVC{
    [userManager getTeamMenberWithId:layout.message.memberId memberBlock:^(NSDictionary *member) {
        if (member) {
            NSError *error;
            MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:member error:&error];
            iconVC.model = model;
        }
    }];
}
- (void)PWChatImageCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    
}

- (void)PWChatImageReload:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    IssueLogModel *logModel = layout.message.model;
    NSString *issueId = logModel.id;
    [[PWHttpEngine sharedInstance] issueLogAttachmentUrlWithIssueLogid:issueId callBack:^(id o) {
        IssueLogAttachmentUrl *model = (IssueLogAttachmentUrl *)o;
        if(model.isSuccess){
            if (model.externalDownloadURL) {
                logModel.externalDownloadURLStr = [model.externalDownloadURL jsonStringEncoded];
                logModel.localTempUniqueId = logModel.id;
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:layout.message.model.issueId data:logModel deleteCache:NO];
                
                layout.message.imageString = [model.externalDownloadURL stringValueForKey:@"url" default:@""];
                [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}


- (void)PWChatRetryClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    
}

- (void)PWChatTextCellClick:(NSIndexPath *)indexPath index:(NSInteger)index layout:(IssueChatMessagelLayout *)layout {
    
}


-(void)dealloc{
   
}

@end
