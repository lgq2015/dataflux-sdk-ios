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
#import "PWPhotoOrAlbumImagePicker.h"
#import "AddIssueLogReturnModel.h"
#import "PWImageGroupView.h"
#import "PWBaseWebVC.h"
#import "IssueListManger.h"
#import "TeamInfoModel.h"
#import "IgnoreItemView.h"

@interface IssueDetailsVC ()<UITableViewDelegate, UITableViewDataSource,PWChatBaseCellDelegate,IssueDtealsBVDelegate,IssueKeyBoardDelegate>
@property (nonatomic, strong) IssueEngineHeaderView *engineHeader;  //来自情报源
@property (nonatomic, strong) IssueUserDetailView *userHeader;      //来自自建问题
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PWPhotoOrAlbumImagePicker *myPicker;
@property (nonatomic, strong) IssueDtealsBV *bottomBtnView; //底部伪输入框
@property (nonatomic, strong) ZTPopCommentView *popCommentView; //弹出输入框
@property (nonatomic, assign) IssueDealState state;
@property (nonatomic, strong) IgnoreItemView *itemView;
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
    self.state = self.popCommentView.state;
    [self.bottomBtnView setImgWithStates:self.popCommentView.state];
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
        if (([self.model.accountId isEqualToString:userManager.curUserInfo.userID] || userManager.teamModel.isAdmin )&& self.model.state != MonitorListStateLoseeEfficacy&&self.model.state != MonitorListStateRecommend) {
            [self addNavigationItemWithImageNames:@[@"web_more"] isLeft:NO target:self action:@selector(ignoreClick) tags:@[@22]];
        }
        [self loadIssueDetailExtra];
//        [self loadInfoDeatil];

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
        _popCommentView =[[ZTPopCommentView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, 200) WithController:self];
        _popCommentView.delegate = self;
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
    [SVProgressHUD show];
    [IssueChatDatas LoadingMessagesStartWithChat:self.model.issueId callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            if(array.count<ISSUE_CHAT_PAGE_SIZE){
                self.tableView.tableFooterView = self.footView;
            }else{
                self.tableView.tableFooterView = self.footer;
            }
        });
    }];
    [self getNewChatDatas];
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
//            if (self.model.isFromUser) {
//                NSDictionary *accountInfo = PWSafeDictionaryVal(content, @"accountInfo");
//                NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
//                [self.userHeader setCreateUserName:[NSString stringWithFormat:@"创建者：%@",name]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.tableView.tableHeaderView = self.userHeader;
//                });
//            }else{
            [self loadIssueSourceDetail:content];
            [self.engineHeader createUIWithDetailDict:content];
            [self.engineHeader layoutIfNeeded];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView = self.engineHeader;
            });
//            }
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
- (void)ignoreClick{
    _itemView = [[IgnoreItemView alloc]init];
    [self.itemView showInView:[UIApplication sharedApplication].keyWindow];
    WeakSelf
    _itemView.itemClick=^(){
        [weakSelf ignoreIssue];
    };
}
- (void)ignoreIssue{
    [PWNetworking requsetHasTokenWithUrl:PW_issueRecover(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
            self.refreshClick?self.refreshClick():nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            if ([response[ERROR_CODE] isEqualToString:@"home.issue.AlreadyIsRecovered"]) {
                self.refreshClick?self.refreshClick():nil;
                IssueModel *model = [[IssueListManger sharedIssueListManger] getIssueDataByData:self.model.issueId];
                self.model =[[IssueListViewModel alloc]initWithJsonDictionary:model];
                [self.userHeader reloadHeaderUI];
            }
        }
    } failBlock:^(NSError *error) {
        [error errorToast];
    }];
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
    NSString *ext = [layout.message.filePath pathExtension];
    if ([ext isEqualToString:@"csv"]
        || [ext isEqualToString:@"zip"]
        || [ext isEqualToString:@"rar"]){
        [iToast alertWithTitleCenter:@"抱歉，该文件暂时不支持预览"];
        return;
    }
    IssueLogModel *logModel = layout.message.model;
    NSString *issueLogId = logModel.id;
    [[PWHttpEngine sharedInstance] issueLogAttachmentUrlWithIssueLogid:issueLogId callBack:^(id o) {
        IssueLogAttachmentUrl *model = (IssueLogAttachmentUrl *)o;
        if(model.isSuccess){
            if (model.externalDownloadURL) {
                PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:layout.message.fileName andURL:[NSURL URLWithString:[model.externalDownloadURL stringValueForKey:@"url" default:@""]]];
                [self.navigationController pushViewController:webView animated:YES];
            }
        }else{
            [iToast alertWithTitleCenter:model.errorCode];
        }
        
    }];
    
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
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.dataSource.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        IssueChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:ip];
        IssueChatMessagelLayout *mLayout = self.dataSource[i];
        
        PWImageGroupItem *item = [PWImageGroupItem new];
        if(mLayout.message.messageType == PWChatMessageTypeImage){
            item.imageType = PWImageGroupImage;
            item.fromImgView = cell.mImgView;
            if(mLayout.message.image){
                item.fromImage = mLayout.message.image;
            }else{
                item.fromImageStr = mLayout.message.imageString;
            }
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    PWImageGroupView *imageGroupView = [[PWImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block PWImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };

}

- (void)PWChatImageReload:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    IssueLogModel *logModel = layout.message.model;
    NSString *issueId = logModel.id;
    WeakSelf
    [[PWHttpEngine sharedInstance] issueLogAttachmentUrlWithIssueLogid:issueId callBack:^(id o) {
        IssueLogAttachmentUrl *model = (IssueLogAttachmentUrl *)o;
        if(model.isSuccess){
            if (model.externalDownloadURL) {
                logModel.externalDownloadURLStr = [model.externalDownloadURL jsonStringEncoded];
                logModel.localTempUniqueId = logModel.id;
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:layout.message.model.issueId data:logModel deleteCache:NO];
                
                layout.message.imageString = [model.externalDownloadURL stringValueForKey:@"url" default:@""];
                if (weakSelf.tableView) {
                  [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }];
}




- (void)PWChatTextCellClick:(NSIndexPath *)indexPath index:(NSInteger)index layout:(IssueChatMessagelLayout *)layout {
    
}
#pragma mark ========== IssueKeyBoardDelegate ==========
- (void)IssueKeyBoardInputViewBtnClickFunction:(NSInteger)index{
        self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
        WeakSelf
        [self.myPicker getPhotoAlbumTakeAPhotoAndNameWithController:weakSelf photoBlock:^(UIImage *image, NSString *name) {
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            if (!name) {
                name = [NSDate getNowTimeTimestamp];
                name=  [NSString stringWithFormat:@"%@.jpg",name];
            }
            [SVProgressHUD show];
            NSDictionary *param = @{@"type":@"attachment",@"subType":@"comment"};
            [PWNetworking uploadFileWithUrl:PW_issueUploadAttachment(weakSelf.model.issueId) params:param fileData:data type:@"jpg" name:@"files" fileName:name mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                
            } successBlock:^(id response) {
                 [SVProgressHUD dismiss];
                if([response[ERROR_CODE] isEqualToString:@""]){
                    NSDictionary *content =PWSafeDictionaryVal(response, @"content");
                    NSDictionary *data = PWSafeDictionaryVal(content, @"data");
                 //待处理：刷新机制
                    [weakSelf getNewChatDatas];
                }else{
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD dismiss];
                [error errorToast];
            }];
        }];
   }

-(void)IssueKeyBoardInputViewSendText:(NSString *)text{
    switch (self.popCommentView.state) {
        
        case IssueDealStateChat:{
            [SVProgressHUD show];
            [[PWHttpEngine sharedInstance] addIssueLogWithIssueid:self.model.issueId text:text atInfoJSON:nil callBack:^(id response) {
                [SVProgressHUD dismiss];
                AddIssueLogReturnModel *data = ((AddIssueLogReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
        case IssueDealStateDeal:{
            [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId markStatus:@"tookOver" text:text atInfoJSON:nil callBack:^(id response) {
                [SVProgressHUD dismiss];
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
        case IssueDealStateSolve:{
            [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId markStatus:@"recovered" text:text atInfoJSON:nil callBack:^(id response) {
                [SVProgressHUD dismiss];
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
    }
  
}
-(void)IssueKeyBoardInputViewSendAtText:(NSString *)text atInfoJSON:(NSDictionary *)atInfoJSON{
    switch (self.popCommentView.state) {
        case IssueDealStateChat:{
            [SVProgressHUD show];
            [[PWHttpEngine sharedInstance] addIssueLogWithIssueid:self.model.issueId text:text atInfoJSON:atInfoJSON callBack:^(id response) {
                [SVProgressHUD dismiss];
                AddIssueLogReturnModel *data = ((AddIssueLogReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
        case IssueDealStateDeal:{
            [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId markStatus:@"tookOver" text:text atInfoJSON:atInfoJSON callBack:^(id response) {
                [SVProgressHUD dismiss];
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
        case IssueDealStateSolve:{
            [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId markStatus:@"recovered" text:text atInfoJSON:atInfoJSON callBack:^(id response) {
                [SVProgressHUD dismiss];
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                    [self getNewChatDatas];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
    }
 
}
- (void)getNewChatDatas{
    [SVProgressHUD show];
    [[IssueChatDataManager sharedInstance] fetchLatestChatIssueLog:self.model.issueId
                                                          callBack:^(BaseReturnModel *issueLogListModel) {
            [IssueChatDatas LoadingMessagesStartWithChat:self.model.issueId callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObjectsFromArray:array];
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
           if(array.count<ISSUE_CHAT_PAGE_SIZE){
                self.tableView.tableFooterView = self.footView;
            }else{
               self.tableView.tableFooterView = self.footer;
            }
            });
                [self postLastReadSeq];
          }];
    }];
   
    self.state = IssueDealStateChat;
    dispatch_async_on_main_queue(^{
        if(self.dataSource.count>0){
         CGRect rect = [self.tableView rectForSection:0];
         [self.tableView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];
        }
       
    });
    [self.bottomBtnView setImgWithStates:IssueDealStateChat];
}
- (void)postLastReadSeq{
    if (self.dataSource.count>0) {
        IssueChatMessagelLayout *layout = _dataSource[0];
        [[PWHttpEngine sharedInstance] postIssueLogReadsLastReadSeqRecord:layout.message.model.id callBack:^(id o) {
            
        }];
    }
   
}
-(void)dealloc{
    [self postLastReadSeq];
    [[IssueListManger sharedIssueListManger] readIssue:self.model.issueId];
    [[IssueChatDataManager sharedInstance] logReadSeqWithissueId:self.model.issueId];
    [kNotificationCenter postNotificationName:KNotificationUpdateIssueList object:nil
                                     userInfo:@{@"updateView":@(YES)}];
}

@end
