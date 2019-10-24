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
#import "PopItemView.h"
#import "AddIssueVC.h"
#import "TouchLargeButton.h"
#import "ZhugeIOIssueHelper.h"
#import "NSString+ErrorCode.h"
#import "UtilsConstManager.h"
#import "iCloudManager.h"
static const int IgnoreBtnTag = 15;

@interface IssueDetailsVC ()<UITableViewDelegate, UITableViewDataSource,PWChatBaseCellDelegate,IssueDtealsBVDelegate,IssueKeyBoardDelegate,PopItemViewDelegate,UIDocumentPickerDelegate>
@property (nonatomic, strong) IssueEngineHeaderView *engineHeader;  //来自情报源
@property (nonatomic, strong) IssueUserDetailView *userHeader;      //来自自建问题
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PWPhotoOrAlbumImagePicker *myPicker;
@property (nonatomic, strong) IssueDtealsBV *bottomBtnView; //底部伪输入框
@property (nonatomic, strong) ZTPopCommentView *popCommentView; //弹出输入框
@property (nonatomic, assign) IssueDealState state;
@property (nonatomic, strong) PopItemView *itemView;
@property (nonatomic, strong) TouchLargeButton *watchBtn;
@property (nonatomic, strong) TouchLargeButton *ignoreBtn;

@property (nonatomic, copy) NSString *oldStr;     //输入内容
@end
@implementation IssueDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = NSLocalizedString(@"local.IssueDetails", @"");
    [self createUI];
    [self loadIssueLog];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentNotif:) name:@"zt_add_comment" object:nil];
    [[[ZhugeIOIssueHelper new] eventIssueLookTime] startTrack];

    [[[ZhugeIOIssueHelper new] eventDiscussAreaTime] startTrack];

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
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.watchBtn];
    UIBarButtonItem * ignoreItem = [[UIBarButtonItem alloc] initWithCustomView:self.ignoreBtn];
    self.navigationItem.rightBarButtonItems = @[ignoreItem,item];
    
    if (self.model.watchInfoJSONStr) {
        self.watchBtn.selected =[self.model.watchInfoJSONStr containsString:userManager.curUserInfo.userID];
    }
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-SafeAreaBottom_Height-ZOOM_SCALE(67));
    [self.view addSubview:self.tableView];
   
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    [self.tableView registerClass:NSClassFromString(@"IssueChatTextCell") forCellReuseIdentifier:PWChatTextCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatImageCell") forCellReuseIdentifier:PWChatImageCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatFileCell") forCellReuseIdentifier:PWChatFileCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatSystermCell") forCellReuseIdentifier:PWChatSystermCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatKeyPointCell") forCellReuseIdentifier:PWChatKeyPointCellId];
    [self.tableView registerClass:NSClassFromString(@"IssueChatChildCell") forCellReuseIdentifier:PWChatChildAddCellId];

    dispatch_async(dispatch_get_main_queue(), ^{
        
    
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
       
    });
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    }];
    [self getNewChatDatasAndScrollTop:NO];
}
-(IssueEngineHeaderView *)engineHeader{
    if (!_engineHeader) {
        _engineHeader = [[IssueEngineHeaderView alloc]initHeaderWithIssueModel:self.model];
        _engineHeader.backgroundColor = PWBackgroundColor;
        WeakSelf
        _engineHeader.recoverClick = ^(BOOL navSel){
            if (navSel) {
                weakSelf.watchBtn.selected = YES;
            }
            [weakSelf getNewChatDatasAndScrollTop:NO];
        };
    }
    return _engineHeader;
}
-(IssueUserDetailView *)userHeader{
    if (!_userHeader) {
        _userHeader = [[IssueUserDetailView alloc]initHeaderWithIssueModel:self.model];
        _userHeader.backgroundColor = PWBackgroundColor;
        WeakSelf
        _userHeader.recoverClick = ^(BOOL navSel){
            if (navSel) {
                weakSelf.watchBtn.selected = YES;
            }
             [weakSelf getNewChatDatasAndScrollTop:NO];
        };
    }
    return _userHeader;
}
-(TouchLargeButton *)watchBtn{
    if (!_watchBtn) {
        _watchBtn = [[TouchLargeButton alloc]init];
        [_watchBtn setImage:[UIImage imageNamed:@"issue_noattention"] forState:UIControlStateNormal];
        [_watchBtn setImage:[UIImage imageNamed:@"issue_attention"] forState:UIControlStateSelected];
        [_watchBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchBtn;
}
-(TouchLargeButton *)ignoreBtn{
    if (!_ignoreBtn) {
        _ignoreBtn = [[TouchLargeButton alloc]init];
        [_ignoreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
        [_ignoreBtn addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ignoreBtn;
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
        [[UtilsConstManager sharedUtilsConstManager] getIssueSourceNameByKey:type name:^(NSString *name1) {
          [self.engineHeader setContentLabText:[NSString stringWithFormat:NSLocalizedString(@"local.InvalidIssueTips", @""),name1,self.model.sourceName]];
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
                        [[UtilsConstManager sharedUtilsConstManager] getIssueSourceNameByKey:provider name:^(NSString *name1) {
                            [self.engineHeader setContentLabText:[NSString stringWithFormat:NSLocalizedString(@"local.InvalidIssueTips", @""),name1,[source stringValueForKey:@"name" default:@""]]];
                        }];
                    }
                }
            }
        }else{
            [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
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
#pragma mark ========== navBtnClick ==========
-(void)navBtnClick:(UIButton *)button{
    if (button.tag == IgnoreBtnTag) {
    
    }else{
    button.enabled = NO;
    [[PWHttpEngine sharedInstance] issueWatchWithIssueId:self.model.issueId isWatch:!button.selected callBack:^(id response) {
        BaseReturnModel *model = response;
        button.enabled = YES;
        if (model.isSuccess) {
            NSString *showTip = button.selected? NSLocalizedString(@"local.AlreadyUnfollowed", @""):NSLocalizedString(@"local.FocusOnSuccess", @"");
            self.watchBtn.selected = !button.selected;
            [SVProgressHUD showSuccessWithStatus:showTip];
            KPostNotification(KNotificationReloadIssueList, nil);
        }else{
            [iToast alertWithTitleCenter:model.errorMsg];
        }
    }];
    }
}
#pragma mark ========== PopItemViewDelegate ==========
- (void)itemClick:(NSInteger)index{
    if (index==0) {
      [self createAssociatedIssue];
    }else{
      [self ignoreIssue];
    }
}
#pragma mark ========== bottomBtnClick ==========
- (void)issueDtealsBVClick{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popCommentView.state = self.state;
        self.popCommentView.oldData = self.oldStr;
        
    });
}
- (void)ignoreClick{
    [self.itemView showInView:[UIApplication sharedApplication].keyWindow];
}
-(PopItemView *)itemView{
    if (!_itemView) {
        _itemView = [[PopItemView alloc]init];
        _itemView.delegate = self;
        if (self.model.allowIgnore) {
            _itemView.itemDatas = @[NSLocalizedString(@"local.CreateAssociatedIssue", @""),NSLocalizedString(@"local.IgnoreIssue", @"")];
        }else{
            _itemView.itemDatas = @[NSLocalizedString(@"local.CreateAssociatedIssue", @"")];
        }
    }
    return _itemView;
}
- (void)ignoreIssue{
    WeakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"local.tip.IgnoreTipTitle", @"") message:NSLocalizedString(@"local.tip.IgnoreTipContent", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.verify", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
        [[PWHttpEngine sharedInstance] issueIgnoreWithIssueId:self.model.issueId callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                weakSelf.updateAllClick();
                [weakSelf backBtnClicked];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nullable action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
   
}
- (void)createAssociatedIssue{
    AddIssueVC *addVC = [[AddIssueVC alloc]init];
    addVC.parentModel = self.model;
    [self.navigationController pushViewController:addVC animated:YES];
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
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:NSLocalizedString(@"local.IssueRecords", @"")];
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
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.NotAvailableForThisFile", @"")];
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
-(void)PWChatChildCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{
  NSDictionary *childIssue = [layout.message.model.childIssueStr jsonValueDecoded];
    NSString *issueId = [childIssue stringValueForKey:@"id" default:@""];
    if (issueId && issueId.length>0) {
        [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSDictionary *content = PWSafeDictionaryVal(response, @"content");
                IssueListViewModel *detailModel = [[IssueListViewModel alloc]initWithDictionary:content];
                IssueDetailsVC *detail = [[IssueDetailsVC alloc]init];
                detail.model = detailModel;
                [self.navigationController pushViewController:detail animated:YES];
            }
        } failBlock:^(NSError *error) {
            [error errorToast];
        }];
    }
}
- (void)PWChatHeaderImgCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout {
    MemberInfoVC *iconVC = [[MemberInfoVC alloc]init];
    
    if([layout.message.memberId isEqualToString:getPWUserID]   ){
        iconVC.type = PWMemberViewTypeMe;
        [self getMemberAndTransModelInfo:layout vc:iconVC];
        if (iconVC.model == nil) return;

    }else if(layout.message.messageFrom == PWChatMessageFromOther){
        iconVC.type = PWMemberViewTypeTeamMember;
        [self getMemberAndTransModelInfo:layout vc:iconVC];
        if (iconVC.model == nil) return;
        [[[[ZhugeIOIssueHelper new] eventClickLookDiscussMember] attrMemberOrdinary] track];

    }else if (layout.message.messageFrom == PWChatMessageFromStaff){
        iconVC.type = PWMemberViewTypeExpert;
        NSString *name = layout.message.nameStr?[layout.message.nameStr componentsSeparatedByString:@" "][0]:@"";
        if (layout.message.headerImgurl) {
            iconVC.expertDict = @{@"name":name,@"url":layout.message.headerImgurl};
        }else{
            iconVC.expertDict = @{@"name":name,@"url":@""};
        }
        [[[[ZhugeIOIssueHelper new] eventClickLookDiscussMember] attrMemberExpert] track];

    }
    iconVC.isShowCustomNaviBar = YES;
    [self.navigationController pushViewController:iconVC animated:YES];

}
- (void)getMemberAndTransModelInfo:(IssueChatMessagelLayout *)layout vc:(MemberInfoVC *)iconVC{
    [userManager getTeamMenberWithId:layout.message.memberId memberBlock:^(MemberInfoModel *member) {
        if (member) {
            iconVC.model = member;
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
    if(self){
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
}




- (void)PWChatTextCellClick:(NSIndexPath *)indexPath index:(NSInteger)index layout:(IssueChatMessagelLayout *)layout {
    
}
#pragma mark ========== IssueKeyBoardDelegate ==========
- (void)IssueKeyBoardInputViewChooeseImageClick{
        self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
        WeakSelf
    [self.myPicker getFileOrPhotoAndNameWithController:self fileOrPhoto:^(UIImage *image, NSString *name, BOOL isFile) {
        if (isFile) {
            [weakSelf chooeseiCloudFileClick];
        }else{
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            if (!name) {
                name = [NSDate getCurrentTimestamp];
                name=  [NSString stringWithFormat:@"%@.jpg",name];
            }
            [SVProgressHUD show];
            NSDictionary *param = @{@"type":@"attachment",@"subType":@"comment"};
            [PWNetworking uploadFileWithUrl:PW_issueUploadAttachment(weakSelf.model.issueId) params:param fileData:data type:@"jpg" name:@"files" fileName:name mimeType:@"image/jpeg" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                
            } successBlock:^(id response) {
                 [SVProgressHUD dismiss];
                if([response[ERROR_CODE] isEqualToString:@""]){
                 //待处理：刷新机制
                    [weakSelf getNewChatDatasAndScrollTop:YES];
                }else{
                }
            } failBlock:^(NSError *error) {
                [SVProgressHUD dismiss];
                [error errorToast];
            }];
        }
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
                      [self getNewChatDatasAndScrollTop:YES];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
            [[[[ZhugeIOIssueHelper new] eventDiscussAreaSay] attrContentWords] track];

        }
            break;
        case IssueDealStateDeal:{
            [[PWHttpEngine sharedInstance] modifyIssueWithIssueid:self.model.issueId markStatus:@"tookOver" text:text atInfoJSON:nil callBack:^(id response) {
                [SVProgressHUD dismiss];
                BaseReturnModel *data = ((BaseReturnModel *) response) ;
                if (data.isSuccess) {
                      [self getNewChatDatasAndScrollTop:YES];
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
                      [self getNewChatDatasAndScrollTop:YES];
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
                      [self getNewChatDatasAndScrollTop:YES];
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
                      [self getNewChatDatasAndScrollTop:YES];
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
                    [self getNewChatDatasAndScrollTop:YES];
                } else {
                    [iToast alertWithTitleCenter:data.errorMsg];
                }
            }];
        }
            break;
    }
 
}
-(void)chooeseiCloudFileClick{
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes
                                                                                                                          inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    if ([iCloudManager iCloudEnable]) {
        WeakSelf
        [iCloudManager downloadWithDocumentURL:url callBack:^(id obj) {
            NSData *data = obj;
            [weakSelf uploadFileData:data fileName:fileName];
        }];
    }
}
- (void)uploadFileData:(NSData *)data fileName:(NSString *)fileName{
    [SVProgressHUD show];
    NSDictionary *param = @{@"type":@"attachment",@"subType":@"comment"};
    WeakSelf
    [PWNetworking uploadFileWithUrl:PW_issueUploadAttachment(self.model.issueId) params:param fileData:data type:@"jpg" name:@"files" fileName:fileName mimeType:@"application/octet-stream" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {

    } successBlock:^(id response) {
         [SVProgressHUD dismiss];
        if([response[ERROR_CODE] isEqualToString:@""]){
         //待处理：刷新机制
            [weakSelf getNewChatDatasAndScrollTop:YES];
        }else{
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];

}
- (void)getNewChatDatasAndScrollTop:(BOOL)scroll{
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
    if (scroll) {
        dispatch_async_on_main_queue(^{
            if(self.dataSource.count>0){
                //         CGRect rect = [self.tableView rectForSection:0];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        });
    }
    
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

    NSString *levelTitle = @"";
    switch (self.model.state) {
        case IssueStateWarning:
            levelTitle = NSLocalizedString(@"local.warning", @"");
            break;
        case IssueStateSeriousness:
            levelTitle = NSLocalizedString(@"local.danger", @"");
            break;
        case IssueStateCommon:
            levelTitle = NSLocalizedString(@"local.info", @"");
            break;
        default:
            break;
    }

    NSString *type = [self.model.type getIssueTypeStr];
    

    [[[[[[ZhugeIOIssueHelper new] eventIssueLookTime] attrIssueLevel:levelTitle]
            attrIssueTitle:self.model.title] attrIssueType:type] endTrack];
    [[[[ZhugeIOIssueHelper new] eventDiscussAreaTime] attrTime] endTrack];

}

@end
