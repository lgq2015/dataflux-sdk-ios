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
#import "ExpertsSuggestVC.h"
#import "IssueChatDataManager.h"
#import "IssueModel.h"
#import "IssueLogModel.h"
#import "PWSocketManager.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "HLSafeMutableArray.h"
#import "ExpertsMoreVC.h"
#import "TeamInfoModel.h"
#import "PWImageGroupView.h"
#import "MemberInfoVC.h"
#import "MemberInfoModel.h"
#import "PWBaseWebVC.h"
#import "IssueListManger.h"
#import "IssueLogListModel.h"

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
    self.title = @"讨论";
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

    [self createUI];


    //获取历史数据
    self.issueID = self.model.issueId;

    [IssueChatDatas LoadingMessagesStartWithChat:_issueID callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        if (array.count>0) {
            _hasMoreData = array.count == ISSUE_CHAT_PAGE_SIZE;

            [self.datas addObjectsFromArray:array];
            [self.mTableView reloadData];
            [self scrollToBottom];
        }else{
            if (self.datas.count == 0) {
                IssueChatMessage *message = [IssueChatMessage new];
                message.messageType = PWChatMessageTypeSysterm;
                message.cellString = PWChatSystermCellId;
                message.systermStr = @"在这里讨论该情报";
                IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:message];
                [self.datas addObject:layout];
                 [self.mTableView reloadData];
            }
        }
    }];

    // Do any additional setup after loading the view.
}
- (void)scrollToBottom{
    [self scrollToBottom:YES];
}

/**
 *
 * @param force YES 强制到底部，NO 如果已经在底部则滑动到底部，如果不是则不做处理
 */
-(void)scrollToBottom:(BOOL)force{
    if (self.datas.count > 0) {
        //经过测试会有 92 的左右的固定偏移量
        BOOL isBottom = self.mTableView.contentOffset.y + 92 >= self.mTableView.contentSize.height - self.mTableView.frame.size.height;

        if (force || isBottom) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0];
            [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }

}
-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNewIssueChatData:)
                                                 name:KNotificationChatNewDatas
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReConnect)
                                                 name:KNotificationSocketConnecting
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFetchComplete)
                                                 name:KNotificationFetchComplete
                                               object:nil];
}

-(void)onReConnect{
    //TODO 后期可能需要做链接提示

}

- (void)onNewIssueChatData:(NSNotification *)notification {
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
            [self.datas addObject:layout];
            [self.mTableView reloadData];
            [self scrollToBottom:NO];
        }


    }
}

-(void)onFetchComplete{
    if (_issueID.length > 0) {

        BOOL read = [[IssueListManger sharedIssueListManger] getIssueLogReadStatus:_issueID];
        if (!read) {
            long long seq = 0;
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
                [self.mTableView reloadData];
            }

            [self scrollToBottom:NO];
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
            NSArray *topDatas = [[IssueChatDataManager sharedInstance] getChatIssueLogDatas:_issueID
                    startSeq:seq endSeq:0];
            if (topDatas.count > 0) {
                NSArray *newChatDatas= [IssueChatDatas bindArray:topDatas];
                [self.datas insertObjects:newChatDatas atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,[topDatas count])]];
                [self.mTableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:newChatDatas.count inSection:0];
                [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

            }
            _hasMoreData = topDatas.count == ISSUE_CHAT_PAGE_SIZE;
            [_progressView stopAnimating];
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
    if(self.model.state != MonitorListStateRecommend){
        [self addNavigationItemWithImageNames:@[@"expert_icon"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@10]];

    }
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
-(void)dealWithNewDta{

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
        [self scrollToBottom];

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
            name = [NSDate getNowTimeTimestamp];
        }
        logModel.imageName = [NSString stringWithFormat:@"%@.jpg",name];
        logModel.issueId = self.issueID;
        logModel.id = [NSDate getNowTimeTimestamp];
        if(![[PWSocketManager sharedPWSocketManager] isConnect]){
            [self dealSocketNotConnectWithModel:logModel];
        }else{
            [self sendMessageWithModel:logModel messageType:PWChatMessageTypeImage];
        }
    }];

}
#pragma mark ========== Socket未连接 保存失败消息 ==========
- (void)dealSocketNotConnectWithModel:(IssueLogModel *)model{
    model.sendError = YES;
    IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:model];
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom];
}
#pragma mark ========== Socket已连接 正常发送消息 ==========
- (void)sendMessageWithModel:(IssueLogModel *)logModel messageType:(PWChatMessageType)type{
    IssueChatMessage *chatModel = [[IssueChatMessage alloc] initWithIssueLogModel:logModel];
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc] initWithMessage:chatModel];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom];

    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:logModel deleteCache:NO];

    [IssueChatDatas sendMessage:logModel sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *model, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
            logModel.id = model.id;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:YES];
        } else if (type == UploadTypeError) {
            logModel.sendError = YES;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
        }
        chatModel.model = logModel;
        chatModel.isSend = NO;
        [self.mTableView reloadData];
    }];
}

#pragma mark ========== fileCellClick ==========
-(void)PWChatFileCellClick:(NSIndexPath*)indexPath layout:(IssueChatMessagelLayout *)layout{
    NSString *ext = [layout.message.filePath pathExtension];
    if ([ext isEqualToString:@"csv"]
        || [ext isEqualToString:@"zip"]
        || [ext isEqualToString:@"rar"]){
        [iToast alertWithTitleCenter:@"抱歉，该文件暂时无法预览"];
        return;
    }
    PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:layout.message.fileName andURL:[NSURL URLWithString:layout.message.filePath]];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark ========== 重发 ==========
-(void)PWChatRetryClickWithModel:(IssueLogModel *)model{
    if (![[PWSocketManager sharedPWSocketManager] isConnect]) {
        [[PWSocketManager sharedPWSocketManager] checkForRestart];
    } else {
        model.sendError = NO;

        PWChatMessageType type = model.text ? PWChatMessageTypeText : PWChatMessageTypeImage;
        if (model.imageData) {
            UIImage *image = [UIImage imageWithData:model.imageData];
            NSData *newData = UIImageJPEGRepresentation(image, 0.5);
            model.imageData = newData;
        }
        [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];

        [self.mTableView reloadData];
        [IssueChatDatas sendMessage:model sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *newModel, UploadType type, float progress) {
            if (type == UploadTypeSuccess) {
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:newModel deleteCache:YES];
            } else if (type == UploadTypeError) {
                newModel.sendError = YES;
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:newModel deleteCache:NO];
            }
            [self.mTableView reloadData];
        }];
    }

}
#pragma mark ========== 用户名片图片查看 ==========
-(void)PWChatHeaderImgCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout{
    MemberInfoVC *iconVC = [[MemberInfoVC alloc]init];

    if(layout.message.messageFrom == PWChatMessageFromMe ){
        iconVC.type = PWMemberViewTypeMe;
    }else if(layout.message.messageFrom == PWChatMessageFromOther){
        iconVC.type = PWMemberViewTypeTeamMember;
        [userManager getTeamMenberWithId:layout.message.memberId memberBlock:^(NSDictionary *member) {
            if (member) {
                NSError *error;
                MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:member error:&error];
                iconVC.model = model;
            }else{
                return;
            }
        }];
    }else if (layout.message.messageFrom == PWChatMessageFromStaff){
        iconVC.type = PWMemberViewTypeExpert;
        NSString *name = layout.message.nameStr?[layout.message.nameStr componentsSeparatedByString:@" "][0]:@"";
        iconVC.expertDict = @{@"name":name,@"url":layout.message.headerImgurl};
    }
    iconVC.isShowCustomNaviBar = YES;
    [self.navigationController pushViewController:iconVC animated:YES];
}

#pragma mark ========== 发送消息 ==========
-(void)sendMessage:(NSDictionary *)dic messageType:(PWChatMessageType)messageType{
    IssueLogModel *logModel = [[IssueLogModel alloc]initSendIssueLogDefaultLogModel];
    logModel.text = dic[@"text"];
    logModel.issueId = self.issueID;
    logModel.id = [NSDate getNowTimeTimestamp];
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
                    [self.navigationController pushViewController:[ExpertsMoreVC new] animated:YES];
                    return;
                }
                ExpertsSuggestVC *expert = [[ExpertsSuggestVC alloc]init];
                expert.model = self.model;
                [self.navigationController pushViewController:expert animated:YES];
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationChatNewDatas object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationSocketConnecting object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationFetchComplete object:nil];


}



@end
