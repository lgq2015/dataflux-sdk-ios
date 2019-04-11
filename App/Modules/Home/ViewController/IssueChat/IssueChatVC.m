//
//  IssueChatVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatVC.h"
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

//#import "PWImageGroupView.h"
@interface IssueChatVC ()<PWChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PWChatBaseCellDelegate>
//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;
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

    NSArray *array= [IssueChatDatas receiveMessages:self.issueID];
    [self.datas addObjectsFromArray:array];
    [self.mTableView reloadData];
    [self scrollToBottom];

    [IssueChatDatas LoadingMessagesStartWithChat:_issueID callBack:^(NSMutableArray<IssueChatMessagelLayout *> * array) {
        if (array.count>0) {
            [self.datas addObjectsFromArray:array];
            [self.mTableView reloadData];
            [self scrollToBottom];
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
    [self addNavigationItemWithImageNames:@[@"expert_icon"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@10]];
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


#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
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





//多功能视图点击回调  图片10
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
        IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:logModel];
        IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
        [self.datas addObject:layout];
        [self.mTableView reloadData];
        [self scrollToBottom];
         [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:logModel deleteCache:NO];
        [IssueChatDatas sendMessage:logModel sessionId:self.issueID messageType:PWChatMessageTypeImage messageBlock:^(IssueLogModel *model, UploadType type, float progress) {
            if (type == UploadTypeSuccess) {
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:YES];
            }else if(type == UploadTypeError){
                logModel.sendError = YES;
                [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
                [self updateTableView];
            }

        }];
    }];

}
-(void)PWChatRetryClickWithModel:(IssueLogModel *)model{
    model.sendError = NO;
    PWChatMessageType type = model.text?PWChatMessageTypeText:PWChatMessageTypeImage;
     [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
    [self updateTableView];
//    NSData *data =model.imageData? (NSData*)model.imageData:nil;
//    model.imageData =data;
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

//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(PWChatMessageType)messageType{
    IssueLogModel *logModel = [[IssueLogModel alloc]initSendIssueLogDefaultLogModel];

    logModel.text = dic[@"text"];
    logModel.issueId = self.issueID;
    logModel.id = [NSDate getNowTimeTimestamp];
    IssueChatMessage *chatModel = [[IssueChatMessage alloc]initWithIssueLogModel:logModel];
    IssueChatMessagelLayout *layout = [[IssueChatMessagelLayout alloc]initWithMessage:chatModel];
    [self.datas addObject:layout];
    [self.mTableView reloadData];
    [self scrollToBottom];
     [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:logModel deleteCache:NO];
    [IssueChatDatas sendMessage:logModel sessionId:self.issueID messageType:PWChatMessageTypeText messageBlock:^(IssueLogModel *model, UploadType type, float progress) {
        if (type == UploadTypeSuccess) {
          [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:YES];
        }else if(type == UploadTypeError){
            logModel.sendError = YES;
            [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];
            [self updateTableView];
        }
//        NSIndexPath *index = [NSIndexPath indexPathForRow:self.datas.count inSection:0];
//        [self.datas addObject:layout]; [self.mTableView reloadData];
      //  [self scrollToBottom];

    }];
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

- (void)PWChatHeaderImgCellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
   
}
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
                expert.issueid = self.issueID;
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
