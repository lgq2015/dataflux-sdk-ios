//
//  PWChatVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatVC.h"
#import "PWChatKeyBoardInputView.h"
#import "PWChatBaseCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PWChatDatas.h"
#import "ExpertsSuggestVC.h"
#import "IssueChatDataManager.h"
#import "IssueModel.h"
#import "IssueLogModel.h"
#import "PWSocketManager.h"

//#import "PWImageGroupView.h"
@interface PWChatVC ()<PWChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PWChatBaseCellDelegate>
//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;

//表单
@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *datas;

//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong)PWChatKeyBoardInputView *mInputView;
@end

@implementation PWChatVC
//不采用系统的旋转
- (BOOL)shouldAutorotate{
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讨论";
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dealWithNewDta)
                                                 name:KNotificationChatNewDatas
                                               object:nil];
    [self createUI];


    //获取历史数据
   
    NSArray * historyArr = [PWChatDatas LoadingMessagesStartWithChat:self.issueID];
    DLog(@"%@",historyArr)

    long long pageMarker = [[IssueChatDataManager sharedInstance] getLastChatIssueLogMarker:_issueID];
    [[IssueChatDataManager sharedInstance]
            fetchAllChatIssueLog:_issueID
                      pageMarker:pageMarker
                        callBack:^(NSMutableArray<IssueLogModel *> *array) {
                            //todo get new data
                            //获取新数据
                            DLog(@"%@",array)
                        }];




    // Do any additional setup after loading the view.
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
    IssueLogModel * model = [[IssueLogModel new] initWithDictionary:pass];
    [[IssueChatDataManager sharedInstance] insertChatIssueLogDataToDB:_issueID data:model deleteCache:NO];

    //todo add to tableView here
}

- (void)createUI{
//    self.tableVie
    [self addNavigationItemWithImageNames:@[@"expert_icon"] isLeft:NO target:self action:@selector(navBtnClick) tags:@[@10]];
    self.datas = [NSMutableArray new];
    _mInputView = [[PWChatKeyBoardInputView alloc]init];
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

    [_mTableView registerClass:NSClassFromString(@"PWChatTextCell") forCellReuseIdentifier:PWChatTextCellId];
    [_mTableView registerClass:NSClassFromString(@"PWChatImageCell") forCellReuseIdentifier:PWChatImageCellId];
    [_mTableView registerClass:NSClassFromString(@"PWChatFileCell") forCellReuseIdentifier:PWChatVoiceCellId];
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
    return [(PWChatMessagelLayout *)_datas[indexPath.row]cellHeight ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PWChatMessagelLayout *layout = _datas[indexPath.row];
    PWChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
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
        if (self.datas.count>0) {
            NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:self.datas.count-1 inSection:0];
            [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
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





//多功能视图点击回调  图片10  视频11  位置12
-(void)PWChatKeyBoardInputViewBtnClickFunction:(NSInteger)index{


//     if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];
//
//        [_mAddImage getImagePickerWithAlertController:self modelType:SSImagePickerModelImage + index-10 pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {
//
//            if(index==10){
//                UIImage *image = (UIImage *)object;
//                NSLog(@"%@",image);
//                NSDictionary *dic = @{@"image":image};
//                [self sendMessage:dic messageType:SSChatMessageTypeImage];
//            }
//
//            else{
//                NSString *localPath = (NSString *)object;
//                NSLog(@"%@",localPath);
//                NSDictionary *dic = @{@"videoLocalPath":localPath};
//                [self sendMessage:dic messageType:SSChatMessageTypeVideo];
//            }
//        }];
//

}


//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(PWChatMessageType)messageType{

    [PWChatDatas sendMessage:dic sessionId:self.issueID messageType:messageType messageBlock:^(PWChatMessagelLayout *layout, NSError *error, NSProgress *progress) {

        [self.datas addObject:layout];
        [self.mTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath  indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    }];
}


#pragma SSChatBaseCellDelegate 点击图片 点击短视频
-(void)PWChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(PWChatMessagelLayout *)layout{

//    NSInteger currentIndex = 0;
//    NSMutableArray *groupItems = [NSMutableArray new];
//
//    for(int i=0;i<self.datas.count;++i){
//
//        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
//        PWChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
//        PWChatMessagelLayout *mLayout = self.datas[i];
//
//        PWImageGroupItem *item = [PWImageGroupItem new];
//        if(mLayout.message.messageType == PWChatMessageTypeImage){
//            item.imageType = PWImageGroupImage;
//            item.fromImgView = cell.mImgView;
//            item.fromImage = mLayout.message.image;
//        }
//        else continue;
//
//        item.contentMode = mLayout.message.contentMode;
//        item.itemTag = groupItems.count + 10;
//        if([mLayout isEqual:layout])currentIndex = groupItems.count;
//        [groupItems addObject:item];
//
//    }
//
//    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
//    [self.navigationController.view addSubview:imageGroupView];
//
//    __block SSImageGroupView *blockView = imageGroupView;
//    blockView.dismissBlock = ^{
//        [blockView removeFromSuperview];
//        blockView = nil;
//    };
//
//    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
//}

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

- (void)PWChatTextCellClick:(NSIndexPath *)indexPath index:(NSInteger)index layout:(PWChatMessagelLayout *)layout {

}
- (void)navBtnClick{
    ExpertsSuggestVC *expert = [[ExpertsSuggestVC alloc]init];
    if ([self.infoDetailDict[@"tags"] isKindOfClass:NSDictionary.class]) {
        NSDictionary *tags = self.infoDetailDict[@"tags"];
        NSArray *expertGroups = tags[@"expertGroups"];
        if (expertGroups.count>0) {
            expert.expertGroups = [NSMutableArray arrayWithArray:expertGroups];
        }
    }
    [self.navigationController pushViewController:expert animated:YES];

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
