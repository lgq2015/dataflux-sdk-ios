//
//  IssueChatVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatVC.h"
#import "IssueListViewModel.h"
#import "IssueChatKeyBoardInputView.h"
#import "IssueChatBaseCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "IssueChatDatas.h"
#import "IssueChatDataManager.h"
#import "IssueModel.h"
#import "IssueLogModel.h"
#import "PWSocketManager.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "HLSafeMutableArray.h"
#import "TeamInfoModel.h"
#import "PWImageGroupView.h"
#import "MemberInfoVC.h"
#import "MemberInfoModel.h"
#import "PWBaseWebVC.h"
#import "IssueListManger.h"
#import "IssueLogListModel.h"
#import "IssueLogAttachmentUrl.h"
#import "IssueLastReadInfoModel.h"
#import "IssueLogAtReadInfo.h"
#import "AtReadSeqAndAccountID.h"

//#import "PWImageGroupView.h"
@interface IssueChatVC ()<PWChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PWChatBaseCellDelegate>
//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;
@property (nonatomic, copy) NSString *issueID;
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;

//表单
@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)HLSafeMutableArray *datas;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) BOOL loadingMoreMessage;
@property (nonatomic, assign) BOOL isInit;

@property (nonatomic, strong) UIActivityIndicatorView *progressView;


//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong)IssueChatKeyBoardInputView *mInputView;
@end

@implementation IssueChatVC
//不采用系统的旋转
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.discussion", @"");
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

    [self createUI];


    //获取历史数据
    self.issueID = self.model.issueId;

    [IssueChatDatas LoadingMessagesStartWithChat:_issueID callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        if (array.count>0) {

            _hasMoreData = array.count == ISSUE_CHAT_PAGE_SIZE;

            [self.datas addObjectsFromArray:array];
            [self.mTableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollToBottom:NO];
            });
            [self loadReadInfo];
        //    [self postLastReadSeq];
        }else{
            if (self.datas.count == 0) {
                IssueChatMessage *message = [IssueChatMessage new];
                message.messageType = PWChatMessageTypeSysterm;
                message.cellString = PWChatSystermCellId;
                message.systermStr = NSLocalizedString(@"local.ThisInformationDiscussedHere", @"");
                IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:message];
                [self.datas addObject:layout];
                [self.mTableView reloadData];
            }
        }
    }];

    //为了识别，在重连的时候是否需要,重新获取新的数据
    [[IssueListManger sharedIssueListManger] readIssueLog:self.issueID];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNewIssueChatData:)
                                                 name:KNotificationNewIssueLog
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReConnect)
                                                 name:KNotificationSocketConnecting
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFetchComplete)
                                                 name:KNotificationFetchComplete
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRecordLastReadSeq:)
                                                 name:KNotificationRecordLastReadSeq
                                               object:nil];
}
- (void)loadReadInfo{
    [[PWHttpEngine sharedInstance] getIssueLogReadsInfoWithIssueID:self.issueID callBack:^(id o) {
        IssueLogAtReadInfo *data = (IssueLogAtReadInfo *) o;
        if (data.isSuccess) {
            [data.lastReadSeqInfo  enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                AtReadSeqAndAccountID *readInfo = [AtReadSeqAndAccountID new];
                readInfo.seq = [obj longLongValue];
                readInfo.accountId = key;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self dealWithAtDatas:readInfo];
                });
            }];
        }
    }];
    
}
- (void)scrollToBottom:(BOOL)animation {
    if (self.datas.count > 0) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animation];
    }
}

-(BOOL)checkIsEnd{
    //10 是容错偏移量
    return self.mTableView.contentOffset.y+10  >= self.mTableView.contentSize.height - self.mTableView.frame.size.height;
}


-(void)onReConnect{
    //TODO 后期可能需要做链接提示

}
#pragma mark ========== 刷新界面上的已读未读 ==========
- (void)onRecordLastReadSeq:(NSNotification *)notification{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSDictionary * pass = [notification userInfo];
       NSError *error;
       IssueLastReadInfoModel *readModel = [[IssueLastReadInfoModel alloc]initWithDictionary:pass error:&error];
        AtReadSeqAndAccountID *read  = [AtReadSeqAndAccountID new];
        read.seq = readModel.issueLogInfo.seq;
        read.accountId = readModel.data.accountId;
        DLog(@"%@",readModel.data.accountId);
        if ([readModel.issueLogInfo.issueId isEqualToString:_issueID]) {
            [self dealWithAtDatas:read];
        }
        
    });
}
- (void)dealWithAtDatas:(AtReadSeqAndAccountID *)readModel{
    __block NSMutableArray *indexAry = [NSMutableArray new];
    [[self.datas copy] enumerateObjectsUsingBlock:^(IssueChatMessagelLayout *cache, NSUInteger idx, BOOL * _Nonnull stop) {
        if (cache.message.messageFrom == PWChatMessageFromMe) {
        IssueLogModel *model = cache.message.model;
        if(model.seq<=readModel.seq && model.atStatusStr.length>0){
            NSDictionary *atStatus = [model.atStatusStr jsonValueDecoded];
            NSMutableArray *unreadAccounts = PWSafeArrayVal(atStatus, @"unreadAccounts")?
            [NSMutableArray arrayWithArray:PWSafeArrayVal(atStatus, @"unreadAccounts")]:[NSMutableArray new];
            NSMutableArray *readAccounts = PWSafeArrayVal(atStatus, @"readAccounts")?
            [NSMutableArray arrayWithArray:PWSafeArrayVal(atStatus, @"readAccounts")]:[NSMutableArray new];
            if(unreadAccounts.count>0){
                [[unreadAccounts copy] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
                    if ([[obj stringValueForKey:@"accountId" default:@""] isEqualToString:readModel.accountId]) {
                        NSDictionary *readDict= unreadAccounts[idx1];
                        [unreadAccounts removeObjectAtIndex:idx1];
                        [readAccounts addObject:readDict];
                        if (unreadAccounts.count == 0) {
                            
                        }
                        NSDictionary *newAtStatus = @{@"readAccounts":readAccounts,@"unreadAccounts":unreadAccounts};
                        model.atStatusStr = [newAtStatus jsonStringEncoded];
                        cache.message.model = model;
                        [self.datas replaceObjectAtIndex:idx withObject:cache];
                        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
                        [indexAry addObject:index];
                        [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:self.issueID data:model deleteCache:NO];
                        *stop = YES;
                    }
                }];
            }
        }
            }
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DLog(@"indexAry == %@",indexAry);
        [self.mTableView reloadRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationNone];
    });
    
}
- (void)postLastReadSeq{
    IssueChatMessagelLayout *layout = [self.datas lastObject];
    [[PWHttpEngine sharedInstance] postIssueLogReadsLastReadSeqRecord:layout.message.model.id callBack:^(id o) {
        
    }];
}
- (void)onNewIssueChatData:(NSNotification *)notification {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary * pass = [notification userInfo];
        IssueLogModel *model = [[IssueLogModel new] initWithDictionary:pass];
        if ([model.issueId isEqualToString:_issueID]) {
            IssueChatMessage *chatModel = [[IssueChatMessage alloc] initWithIssueLogModel:model];
            IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc] initWithMessage:chatModel];

            BOOL hasSame = NO;

            for(IssueChatMessagelLayout *cache in self.datas){
                if([cache.message.model.id isEqualToString:model.id]){
                    cache.message.model.updateTime = model.updateTime;
                    cache.message.model.type = model.type;
                    cache.message.model.subType = model.subType;
                    cache.message.model.accountInfoStr = model.accountInfoStr;
                    hasSame =YES;
                    break;
                }
            }

            if(!hasSame){
               
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.datas addObject:layout];
                    [self onNewIssueChatDataRemoveSame:notification];
                    if(layout.message.model.atStatusStr.length>0){
              //          [self postLastReadSeq];
                    }
                    [NSObject cancelPreviousPerformRequestsWithTarget: self
                                                             selector:@selector(onNewIssueChatDataRemoveSame:)
                                                               object: notification];

                    [self performSelector:@selector(onNewIssueChatDataRemoveSame:)
                               withObject: notification afterDelay: 0.5];
                });
               
            }

        }

    });



}


- (void)onNewIssueChatDataRemoveSame:(NSNotification *)notification{
    BOOL isEnd= [self checkIsEnd];
    [self.mTableView reloadData];

    if(isEnd){
        [self scrollToBottom:NO];
    }
}



-(void)onFetchComplete{
    if (_issueID.length > 0) {

        BOOL read = [[IssueListManger sharedIssueListManger] getIssueLogReadStatus:_issueID];
        if (!read) {
            long long seq = 0;
            //不会有空数据的情况
            if (self.datas.count > 0) {
                seq = ((IssueChatMessagelLayout *)self.datas.lastObject).message.model.seq;

                NSArray *array = [[IssueChatDataManager sharedInstance]
                        getChatIssueLogDatas:_issueID
                                    startSeq:-1
                                      endSeq:seq];

                NSMutableArray *newChatArray = [NSMutableArray new];

                [array enumerateObjectsUsingBlock:^(IssueLogModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    IssueChatMessage *chatModel = [[IssueChatMessage alloc] initWithIssueLogModel:obj];
                    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc] initWithMessage:chatModel];
                    [newChatArray addObject:layout];
                }];

                [self.datas addObjectsFromArray:newChatArray];
                BOOL isEnd= [self checkIsEnd];
                [self.mTableView reloadData];

                if(isEnd){
                    [self scrollToBottom:NO];
                }
                [self postLastReadSeq];
            }
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if(!_isInit){ //第一次加载的时候，不调用
        _isInit =YES;
        return;
    }

    if (!_hasMoreData) {
        return;
    }

    //isTop
    if (scrollView.contentOffset.y == 0) {

        if (!_loadingMoreMessage) {
            [_progressView startAnimating];

            [self performSelector:@selector(getMoreHistory) afterDelay:0.5];
        }
    }
}



- (void)getMoreHistory {

    if (self.datas.count > 0) {
        _loadingMoreMessage =YES;

        long long seq = ((IssueChatMessagelLayout *) self.datas.firstObject).message.model.seq;
        long long lastDataCheckSeq = [[IssueChatDataManager sharedInstance]
                getLastDataCheckSeqInOnPage:_issueID pageMarker:seq];


        void(^bindHistory)(void)= ^{

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *topDatas = [[IssueChatDataManager sharedInstance] getChatIssueLogDatas:_issueID
                                                                                       startSeq:seq endSeq:0];
                dispatch_async_on_main_queue(^{
                    if (topDatas.count > 0) {
                        NSArray *newChatDatas= [IssueChatDatas bindArray:topDatas];
                        [self.datas insertObjects:newChatDatas atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[topDatas count])]];
                        [self.mTableView reloadData];
                        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:newChatDatas.count inSection:0];
                        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

                    }
                    _hasMoreData = topDatas.count == ISSUE_CHAT_PAGE_SIZE;
                    [_progressView stopAnimating];
                });
            });

        };

        if (lastDataCheckSeq > 0) {
            [[IssueChatDataManager sharedInstance] fetchHistory:_issueID pageMarker:lastDataCheckSeq callBack:^(IssueLogListModel *model) {
                if(model.isSuccess){
                    bindHistory();
                } else{
                    [iToast alertWithTitleCenter:model.errorMsg];
                }
                _loadingMoreMessage = NO;

            }];

        } else {
            bindHistory();
            _loadingMoreMessage = NO;
        }

    }

}



- (void)createUI{
//    self.tableVie
//    if(self.model.state != Recommend){
//        [self addNavigationItemWithImageNames:@[@"expert_icon"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@10]];
//
//    }
    self.datas = [HLSafeMutableArray new];
    _mInputView = [[IssueChatKeyBoardInputView alloc]init];
    _mInputView.delegate = self;
    [self.view addSubview:_mInputView];
    _backViewH = kHeight-PWChatKeyBoardInputViewH-kTopHeight-SafeAreaBottom_Height;
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, 0, kWidth, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];

    _mTableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = PWBackgroundColor;
    _mTableView.backgroundView.backgroundColor = PWChatCellColor;
    [_mBackView addSubview:self.mTableView];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _mTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    if (@available(iOS 11.0, *)){
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }

    [_mTableView registerClass:NSClassFromString(@"IssueChatTextCell") forCellReuseIdentifier:PWChatTextCellId];
    [_mTableView registerClass:NSClassFromString(@"IssueChatImageCell") forCellReuseIdentifier:PWChatImageCellId];
    [_mTableView registerClass:NSClassFromString(@"IssueChatFileCell") forCellReuseIdentifier:PWChatFileCellId];
     [_mTableView registerClass:NSClassFromString(@"IssueChatSystermCell") forCellReuseIdentifier:PWChatSystermCellId];
    [_mTableView reloadData];


    _progressView = [UIActivityIndicatorView new];

    _progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _progressView.hidesWhenStopped = YES;


    [self.view addSubview:_progressView];

    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count==0?0:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(IssueChatMessagelLayout *)_datas[indexPath.row]cellHeight ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueChatMessagelLayout *layout = _datas[indexPath.row];
    IssueChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
}


//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mInputView SetPWChatKeyBoardInputViewEndEditing];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mInputView SetPWChatKeyBoardInputViewEndEditing];
}


#pragma PWChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)PWChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{

    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, 0, kWidth, height);
        self.mTableView.frame = self.mBackView.bounds;
        [self scrollToBottom:YES];

    } completion:^(BOOL finished) {

    }];

}


//发送文本 列表滚动至底部
-(void)PWChatKeyBoardInputViewBtnClick:(NSString *)string{

    NSDictionary *dic = @{@"text":string};

    [self sendMessage:dic messageType:PWChatMessageTypeText];
}





#pragma mark ========== 发送图片 ==========
-(void)PWChatKeyBoardInputViewBtnClickFunction:(NSInteger)index{

    self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
    [self.myPicker getPhotoAlbumTakeAPhotoAndNameWithController:self photoBlock:^(UIImage *image, NSString *name) {
        IssueLogModel *logModel = [[IssueLogModel alloc]initSendIssueLogDefaultLogModel];
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        logModel.imageData = data;
        if (!name) {
            name = [NSDate getCurrentTimestamp];
        }
        logModel.imageName = [NSString stringWithFormat:@"%@.jpg",name];
        logModel.issueId = self.issueID;
        logModel.id = [NSDate getCurrentTimestamp];
        logModel.sendError = NO;
        if(![[PWSocketManager sharedPWSocketManager] isConnect]){
            [self dealSocketNotConnectWithModel:logModel];
        }else{
            [self sendMessageWithModel:logModel messageType:PWChatMessageTypeImage];
        }
    }];

}
#pragma mark ========== Socket未连接 保存失败消息 ==========
- (void)dealSocketNotConnectWithModel:(IssueLogModel *)model{
    [[PWSocketManager sharedPWSocketManager] forceRestart];
    model.sendError = YES;
    IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:model];
    chatModel.sendStates = ChatSentStatesSendError;
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
    model.localTempUniqueId = model.id;
    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom:YES];
}
#pragma mark ========== Socket已连接 正常发送消息 ==========
- (void)sendMessageWithModel:(IssueLogModel *)logModel messageType:(PWChatMessageType)type{
    IssueChatMessage *chatModel = [[IssueChatMessage alloc] initWithIssueLogModel:logModel];
    chatModel.sendStates = ChatSentStatesIsSending;
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc] initWithMessage:chatModel];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom:YES];

    layout.message.model.localTempUniqueId = layout.message.model.id;

    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:logModel deleteCache:NO];

    [IssueChatDatas sendMessage:logModel sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *model, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
            chatModel.model.id = model.id;
            chatModel.sendStates = ChatSentStatesSendSuccess;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:YES];
        } else if (type == UploadTypeError) {
            chatModel.model.sendError = YES;
            chatModel.sendStates = ChatSentStatesSendError;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
        }
        [self.mTableView reloadData];
    }];
}

#pragma mark ========== fileCellClick ==========
-(void)PWChatFileCellClick:(NSIndexPath*)indexPath layout:(IssueChatMessagelLayout *)layout{
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
#pragma mark ========== 重发 ==========
-(void)PWChatRetryClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{
    if(![[PWSocketManager sharedPWSocketManager] isConnect]){
        [[PWSocketManager sharedPWSocketManager] forceRestart];
        return;
    }
    
    layout.message.model.sendError = NO;
    layout.message.sendStates = ChatSentStatesIsSending;
    [self.mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    PWChatMessageType type = layout.message.model.text ? PWChatMessageTypeText : PWChatMessageTypeImage;
    
    if (layout.message.model.imageData) {
        UIImage *image = [UIImage imageWithData:layout.message.model.imageData];
        NSData *newData = UIImageJPEGRepresentation(image, 0.5);
        layout.message.model.imageData = newData;
    }
    if(layout.message.model.atInfoJSONStr.length>0){
        type = PWChatMessageTypeAtText;
    }
    layout.message.model.localTempUniqueId = layout.message.model.id;
    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:layout.message.model deleteCache:NO];
    layout.message.sendStates = ChatSentStatesSendSuccess;
    [self.mTableView reloadData];
    [IssueChatDatas sendMessage:layout.message.model sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *newModel, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
            layout.message.model.id = newModel.id;
            layout.message.sendStates = ChatSentStatesSendSuccess;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:newModel deleteCache:YES];
        } else if (type == UploadTypeError) {
            layout.message.model.id = newModel.id;
            layout.message.model.sendError = YES;
            layout.message.sendStates = ChatSentStatesSendError;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:newModel deleteCache:NO];
        }
        [self.mTableView reloadData];
    }];

}
#pragma mark ========== 用户名片图片查看 ==========
-(void)PWChatHeaderImgCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{
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
    [userManager getTeamMenberWithId:layout.message.memberId memberBlock:^(MemberInfoModel *member) {
        if (member) {
            iconVC.model = member;
        }
    }];
}
#pragma mark ========== 发送消息 ==========
-(void)sendMessage:(NSDictionary *)dic messageType:(PWChatMessageType)messageType{
    IssueLogModel *logModel = [[IssueLogModel alloc]initSendIssueLogDefaultLogModel];
    logModel.text = dic[@"text"];
    logModel.issueId = self.issueID;
    logModel.id = [NSDate getCurrentTimestamp];
    logModel.sendError = NO;
    if(![[PWSocketManager sharedPWSocketManager] isConnect]){
        [self dealSocketNotConnectWithModel:logModel];
    }else{
        [self sendMessageWithModel:logModel messageType:PWChatMessageTypeText];
    }
}


#pragma mark ========== 点击图片 查看图片 ==========
-(void)PWChatImageCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{

    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];

    for(int i=0;i<self.datas.count;++i){

        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        IssueChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
        IssueChatMessagelLayout *mLayout = self.datas[i];

        PWImageGroupItem *item = [PWImageGroupItem new];
        if(mLayout.message.messageType == PWChatMessageTypeImage){
            item.imageType = PWImageGroupImage;
            item.fromImgView = cell.mImgView;
            if(mLayout.message.image){
                item.fromImage = mLayout.message.image;
            }else{
               item.fromImageStr = mLayout.message.imageString;
            }
           ;
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
    [self.mInputView SetPWChatKeyBoardInputViewEndEditing];
}

#pragma mark ========== 图片链接异常 ==========
-(void)PWChatImageReload:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{
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
                [self.mTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}
#pragma mark ========== @文本发送 ==========
- (void)PWChatKeyBoardInputViewAtBtnClick:(NSString *)string atInfoJSON:(NSDictionary *)atInfoJSON{
    DLog(@"atstring === %@;\n atInfoJSON === %@",string,atInfoJSON);
    NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");
    __block  NSMutableArray *unreadAccounts = [NSMutableArray new];
    [accountIdMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [unreadAccounts addObject:@{@"accountId":key}];
    }];
    NSDictionary *atStatus;
    if (unreadAccounts.count>0) {
        atStatus = @{@"unreadAccounts":unreadAccounts};
    }
    IssueLogModel *logModel = [[IssueLogModel alloc]initSendIssueLogDefaultLogModel];
    logModel.text = string;
    logModel.issueId = self.issueID;
    logModel.atInfoJSONStr = [atInfoJSON jsonStringEncoded];
    logModel.id = [NSDate getCurrentTimestamp];
    logModel.sendError = NO;
    logModel.atStatusStr = atStatus?[atStatus jsonStringEncoded]:@"";
   
    if(![[PWSocketManager sharedPWSocketManager] isConnect]){
        [self dealSocketNotConnectWithModel:logModel];
    }else{
        [self sendMessageWithModel:logModel messageType:PWChatMessageTypeAtText];
    }
}
- (void)PWChatReadUnreadBtnClickLayout:(IssueChatMessagelLayout *)layout{
    NSDictionary *atStatus = [layout.message.model.atStatusStr jsonValueDecoded];
    NSDictionary *atInfoJSON = [layout.message.model.atInfoJSONStr jsonValueDecoded];
    NSArray *unreadAccounts = PWSafeArrayVal(atStatus, @"unreadAccounts");
    NSArray *readAccounts = PWSafeArrayVal(atStatus, @"readAccounts");
    NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
//    NSDictionary *atInfoJSON = [layout.message.model.atInfoJSONStr jsonValueDecoded];
//    NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
//    NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");

    if ((unreadAccounts.count+readAccounts.count)>1) {
//        AtListVC *atVC = [[AtListVC alloc]init];
//        atVC.atStatus = atStatus;
//        atVC.isHasStuff = serviceMap.allKeys.count>0?YES:NO;
//        [self.navigationController pushViewController:atVC animated:YES];
    }
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)PWChatKeyBordViewBtnClick:(NSInteger)index{

}

- (void)PWChatTextCellClick:(NSIndexPath *)indexPath index:(NSInteger)index layout:(IssueChatMessagelLayout *)layout {

}
#pragma mark ========== 邀请专家 ==========
- (void)navBtnClick{
    [SVProgressHUD show];
    [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
        [SVProgressHUD dismiss];
        if (isSuccess) {
            if ([getTeamState isEqualToString:PW_isTeam]) {
                NSDictionary *tags =userManager.teamModel.tags;
                NSDictionary *product = PWSafeDictionaryVal(tags, @"product");
                if (product ==nil) {
//                    [self.navigationController pushViewController:[ExpertsMoreVC new] animated:YES];
                    return;
                }
//                ExpertsSuggestVC *expert = [[ExpertsSuggestVC alloc]init];
//                expert.model = self.model;
//                [self.navigationController pushViewController:expert animated:YES];
            }
        }
    }];
}

- (void)dealloc {
    [[IssueListManger sharedIssueListManger] readIssueLog:self.issueID];
    [kNotificationCenter postNotificationName:KNotificationUpdateIssueDetail object:nil];
}


@end
