//
//  ZYChangeTeamUIManager.m
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZYChangeTeamUIManager.h"
#import "ZYChangeTeamCell.h"
#import "UITableViewCell+ZTCategory.h"
#import "ZTCreateTeamVC.h"
@interface ZYChangeTeamUIManager()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIView *backgroundGrayView;//!<透明背景View
@property (nonatomic, assign) CGFloat offsetY;//从哪个位置弹出来
@property (nonatomic, strong) UITableView *tab;
@property (nonatomic, strong) NSArray *teamlists;
@end
@implementation ZYChangeTeamUIManager

+ (instancetype)shareInstance{
    static ZYChangeTeamUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYChangeTeamUIManager alloc] init];
    });
    return instance;
}

#pragma mark --添加主控件--
-(void)s_UI{
    [self.window addSubview:self.backgroundGrayView];
    [self.backgroundGrayView addSubview:self.tab];
    [self p_hideFrame];
}

//隐藏
-(void)p_hideFrame{
    CGFloat teamViewH = [self getHeight];
    _tab.frame =CGRectMake(0,- teamViewH, kWidth, teamViewH);
}

//展示
-(void)p_disFrame{
    CGFloat teamViewH = [self getHeight];
    _tab.frame =CGRectMake(0,0, kWidth, teamViewH);
}

- (void)showWithOffsetY:(CGFloat)offset{
    _offsetY = offset + 1.0;
    _teamlists = [userManager getAuthTeamList];
    //如果缓存为空，转圈请求
    if (_teamlists == nil || _teamlists.count == 0){
        [userManager requestMemberList:YES complete:^(BOOL isFinished) {
            _teamlists = [userManager getAuthTeamList];
            [self show];
        }];
        [userManager requestTeamIssueCount];
    }else{//有数据也要请求，为了和web端同步数据
        [userManager requestMemberList:NO complete:nil];
        [userManager requestTeamIssueCount];
        [self show];
    }
}
- (void)show{
    //将红点数设置到团队列表中
    [self addIssueCount];
    //避免弹出多次
    if (_isShowTeamView) return;
    //保存外界传入的值(+1.0 为了让导航栏顶部那条线显示出来)
    [self s_UI];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_disFrame];
        self.tab.alpha = 1;
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        if (finished) {
            _isShowTeamView = YES;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

-(void)dismiss{
    if (_dismissedBlock){
        _dismissedBlock(YES);
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        [self p_hideFrame];
        self.tab.alpha = 0;
        self.backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tab removeFromSuperview];
            self.tab = nil;
            [self.backgroundGrayView removeFromSuperview];
            _isShowTeamView = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }];
    [UIView commitAnimations];
}

#pragma mark --lazy--
-(UIWindow *)window{
    if (!_window) {
        _window = [[[UIApplication sharedApplication]delegate]window];
        _window.clipsToBounds = YES;
    }
    return _window;
}

-(UIView *)backgroundGrayView{
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc]init];
        _backgroundGrayView.frame = CGRectMake(0,_offsetY, kWidth, kHeight);
        _backgroundGrayView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _backgroundGrayView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [_backgroundGrayView addGestureRecognizer:tap];
    }
    return _backgroundGrayView;
}
- (UITableView *)tab{
    if (!_tab){
        _tab = [[UITableView alloc] init];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.backgroundColor = [UIColor whiteColor];
        [_tab setSeparatorInset:UIEdgeInsetsZero];
        [_tab registerNib:[ZYChangeTeamCell cellWithNib] forCellReuseIdentifier:[ZYChangeTeamCell cellReuseIdentifier]];
        [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tab;
}
#pragma mark ---列表UI更新---
//修改团队消息数
- (void)changeTeamMessageNum:(NSString *)num withGroupId:(NSString *)groupID{
    //遍历model数组，找到后修改其显示的消息数目
    
}
//有人@我
- (void)somebodyCallMe:(NSString *)groupID{
    //遍历model数组，找到要修改的model，修改其@显示bool属性值
}


#pragma mark --UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teamlists.count +  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.teamlists.count > 0 && indexPath.row < self.teamlists.count){
        TeamInfoModel *model = self.teamlists[indexPath.row];
        ZYChangeTeamCell *cell = (ZYChangeTeamCell *)[tableView dequeueReusableCellWithIdentifier:[ZYChangeTeamCell cellReuseIdentifier]];
        cell.model = model;
        return  cell;
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"创建新团队";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#C7C7CC"];
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.teamlists.count > 0 && indexPath.row < self.teamlists.count){
        return ZOOM_SCALE(44);
    }else{
        return ZOOM_SCALE(60);
    }
}
#pragma mark --UITableViewDelegate--
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismiss];
    if (self.teamlists.count > 0 && indexPath.row < self.teamlists.count){
        TeamInfoModel *model = self.teamlists[indexPath.row];
        TeamInfoModel *currentTeam = [self getCurrentTeamModel];
        //如果点击当前团队不做处理
        if ([model.teamID isEqualToString:currentTeam.teamID]){
            return;
        }
        [self changeTeamWithGroupModel:model];
    }else{
        if (self.fromVC){
            [self.fromVC.navigationController pushViewController:[ZTCreateTeamVC new] animated:YES];
        }
    }
}

#pragma mark ---UIGestureRecognizerDelegate---
//解决didSelectRowAtIndexPath 和 手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark --获取表的高度---
- (CGFloat)getHeight{
    CGFloat height = self.teamlists.count * ZOOM_SCALE(44) + ZOOM_SCALE(60);
    if (height > kHeight * 0.5){
        height = kHeight * 0.5;
    }
    return height;
}
#pragma mark --获取当前teammodel----
- (TeamInfoModel *)getCurrentTeamModel{
    if (userManager.teamModel){
        return userManager.teamModel;
    }else{
        YYCache *cache = [[YYCache alloc] initWithName:KTeamCacheName];
        NSDictionary * teamDic = (NSDictionary *)[cache objectForKey:KTeamModelCache];
        TeamInfoModel *model = [TeamInfoModel modelWithJSON:teamDic];
        return model;
    }
}
#pragma mark --添加红点数----
- (void)addIssueCount{
    NSDictionary *issueCountDic = [userManager getAuthTeamIssueCount];
    [self.teamlists enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TeamInfoModel *model = (TeamInfoModel *)obj;
        [issueCountDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *count = [NSString stringWithFormat:@"%@",obj];;
            NSString *teamID = (NSString *)key;
            if ([teamID isEqualToString:model.teamID]) {//这里就不在替换，因为前面已经替换过了
                model.issueCount = count;
                *stop = YES;
            }
        }];
    }];
}
#pragma mark ---发送切换团队请求----
- (void)changeTeamWithGroupModel:(TeamInfoModel *)model{
    //获取切换前teamModel
    TeamInfoModel *lastTeamModel = userManager.teamModel;
    //存储默认团队ID
    setPWDefaultTeamID(model.teamID);
    //判断是否有要切换teamID，对应的成员缓存
    __block BOOL isHaveMemberCache = NO;
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess){
            isHaveMemberCache = YES;
        }else{
            isHaveMemberCache = NO;
        }
    }];
    //有缓存，切换本地数据并通知外界
    if (isHaveMemberCache){
        //更新teamModel
        userManager.teamModel = model;
        //更新团队列表中的默认团队
        [userManager updateTeamModelWithGroupID:model.teamID];
        KPostNotification(KNotificationHasMemCacheSwitchTeam, nil);
    }
    if (isHaveMemberCache == NO){
        //恢复存储默认团队ID
        setPWDefaultTeamID(lastTeamModel.teamID);
        [SVProgressHUD show];
    }
    NSDictionary *params = @{@"data":@{@"teamId":model.teamID}};
    [PWNetworking requsetHasTokenWithUrl:PW_AuthSwitchTeam withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSString *token = response[@"content"][@"authAccessToken"];
            //存储最新token
            setXAuthToken(token);
            if (isHaveMemberCache == NO){
                userManager.teamModel = model;
                [userManager updateTeamModelWithGroupID:model.teamID];
                setPWDefaultTeamID(model.teamID);
            }
            //发送团队切换通知
            KPostNotification(KNotificationSwitchTeam, nil);
            //重新发送loadlist请求
            [userManager requestMemberList:NO complete:nil];
            //重新发送团队列表红点请求
            [userManager requestTeamIssueCount];
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
        if (isHaveMemberCache == NO){
            [SVProgressHUD dismiss];
        }
    } failBlock:^(NSError *error) {
        if (isHaveMemberCache == NO){
            [SVProgressHUD dismiss];
            [iToast alertWithTitleCenter:@"切换团队失败"];
        }
    }];
    
}
@end
