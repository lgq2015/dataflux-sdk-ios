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
    [kNotificationCenter addObserver:self
                            selector:@selector(dealWithNewDta)
                                name:KNotificationChatNewDatas
                              object:nil];
    [self createUI];


    //获取历史数据
    self.issueID = self.model.issueId;
    NSArray *array= [IssueChatDatas receiveMessages:self.issueID];
    [self.datas addObjectsFromArray:array];
    [self.mTableView reloadData];
    [self scrollToBottom];

    [IssueChatDatas LoadingMessagesStartWithChat:_issueID callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        if (array.count>0) {
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
//    long long pageMarker = [[IssueChatDataManager sharedInstance] getLastChatIssueLogMarker:_issueID];
//    [[IssueChatDataManager sharedInstance]
//            fetchAllChatIssueLog:_issueID
//                      pageMarker:pageMarker
//                        callBack:^(NSMutableArray<IssueLogModel *> *array) {
//                            //todo get new data
//                            //获取新数据
//                            DLog(@"%@",array)
//                        }];




    // Do any additional setup after loading the view.
}
- (void)scrollToBottom{
    if (self.datas.count>0) {
        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNewIssueChatData:)
                                                 name:KNotificationChatNewDatas
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReFetchNewDatas)
                                                 name:KNotificationReFetchIssChatDatas
                                               object:nil];
}

-(void)onReFetchNewDatas{
    // 重新链接获取数据
    long long pageMarker = [[IssueChatDataManager sharedInstance] getLastChatIssueLogMarker:_issueID];
    [[IssueChatDataManager sharedInstance]
            fetchAllChatIssueLog:_issueID
                      pageMarker:pageMarker
                        callBack:^(NSMutableArray<IssueLogModel *> *array) {
                            //todo get new data
                            //获取新数据
                            if(array.count>0){
                               [self updateTableView];
                            }
                        }];
}

- (void)onNewIssueChatData:(NSNotification *)notification {
    NSDictionary * pass = [notification userInfo];
    IssueLogModel *model = [[IssueLogModel new] initWithDictionary:pass];
    if ([model.issueId isEqualToString:_issueID]) {
        [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
    }
        [self updateTableView];
    
    //todo add to tableView here
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

    //todo 如果未链接状态发送标记失败
    if([[PWSocketManager sharedPWSocketManager] isConnect ] ){

    }
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
    IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:logModel];
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom];
   
   
    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:logModel deleteCache:NO];
    [IssueChatDatas sendMessage:logModel sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *model, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:YES];
        }else if(type == UploadTypeError){
            logModel.sendError = YES;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
            [self updateTableView];
        }
        
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
    if(![[PWSocketManager sharedPWSocketManager] isConnect]){
    
    }else{
    model.sendError = NO;
   
    PWChatMessageType type = model.text?PWChatMessageTypeText:PWChatMessageTypeImage;
    if(model.imageData){
        UIImage *image = [UIImage imageWithData:model.imageData];
        NSData *newData =  UIImageJPEGRepresentation(image, 0.5);
        model.imageData = newData;
    }
     [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
    [self updateTableView];
    [IssueChatDatas sendMessage:model sessionId:self.issueID messageType:type messageBlock:^(IssueLogModel *model1, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
          [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model1 deleteCache:YES];
        }else if(type == UploadTypeError){
            model1.sendError = YES;
          [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model1 deleteCache:NO];
            [self updateTableView];
        }
        }];
    }
   
}
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
//发送消息
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

- (void)updateTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datas removeAllObjects];
        NSArray *array= [IssueChatDatas receiveMessages:self.issueID];
        [self.datas addObjectsFromArray:array];
        [self.mTableView reloadData];
        [self scrollToBottom];
    });
}
#pragma SSChatBaseCellDelegate 点击图片 点击短视频
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNewIssueChatData:)
                                                 name:KNotificationChatNewDatas
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReFetchNewDatas)
                                                 name:KNotificationReFetchIssChatDatas
                                               object:nil];
}



@end
