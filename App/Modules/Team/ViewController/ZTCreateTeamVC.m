//
//  ZTCreateTeamVC.m
//  App
//
//  Created by tao on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ZTCreateTeamVC.h"
#import "ChooseAddressVC.h"
#import "ChooseTradesVC.h"
#import "CreateSuccessVC.h"
#import "TeamInfoModel.h"
#import "TeamVC.h"
#import "ChooseAdminVC.h"
#import "ChangeUserInfoVC.h"
#import "UITextField+HLLHelper.h"
#import "IssueListManger.h"
#import "IssueChatDataManager.h"
#import "PWSocketManager.h"
#import "IssueSourceManger.h"

#define AddressTag 15
#define TradesTag  20
@interface ZTCreateTeamVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray<UITextField *> *tfAry;
@property (nonatomic, strong) ZTCreateTeamConfig *mConfige;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, strong) UILabel *countLab;
@end

@implementation ZTCreateTeamVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
    }}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tfAry = [NSMutableArray new];
    [self judgeVcType];
}
- (void)judgeVcType{
    self.mConfige = [[ZTCreateTeamConfig alloc] init];
    [self.mConfige createTeamConfige];
    if(_dowhat == newCreateTeam){
        self.title = self.mConfige.title;
    }else{
        self.title = @"补充团队信息";
    }
    self.currentCity = self.mConfige.currentCity;
    self.currentProvince = self.mConfige.currentProvince;
    [self createUIWithDatas:self.mConfige.teamTfArray];
}

- (void)createUIWithDatas:(NSArray<TeamTF *>*)itemAry{
    UIView *temp = nil;
    CGFloat height = Interval(23)+ZOOM_SCALE(42);
    for (NSInteger i=0;i<itemAry.count ;i++) {
        UIView *item = [self itemWithData:itemAry[i]];
        if (temp == nil) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view).offset(Interval(12));
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.height.offset(height);
            }];
            temp = item;
        }else{
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(2));
                make.left.mas_equalTo(self.view);
                make.right.mas_equalTo(self.view);
                make.height.offset(height);
            }];
            temp = item;
            if (i==1) {
                item.tag = AddressTag;
            }else{
                item.tag = TradesTag;
            }
        }
    }
    
    UIView *textItem = [[UIView alloc]init];
    textItem.backgroundColor = PWWhiteColor;
    [self.view addSubview:textItem];
    [textItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(temp.mas_bottom).offset(Interval(2));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.offset(ZOOM_SCALE(130));
    }];
    
    UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTitleColor text:@"团队介绍"];
    [textItem addSubview:titel];
    
    
    [textItem addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titel.mas_bottom);
        make.right.mas_equalTo(self.view).offset(-Interval(12));
        make.left.mas_equalTo(self.view).offset(Interval(12));
        make.bottom.mas_equalTo(textItem).offset(-Interval(25));
    }];
    if (!_countLab) {
        _countLab = [PWCommonCtrl lableWithFrame:CGRectMake(kWidth-ZOOM_SCALE(110), ZOOM_SCALE(110), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(13) textColor:[UIColor colorWithHexString:@"8E8E93"] text:@"0/250"];
        _countLab.textAlignment = NSTextAlignmentRight;
        [textItem addSubview:_countLab];
    }
    self.textView.text = self.mConfige.describeStr;
    if (!self.mConfige.showDescribe) {
        textItem.hidden = YES;
    }else{
        [[self.textView rac_textSignal] subscribeNext:^(NSString *text) {
            UITextRange *selectedRange = [self.textView markedTextRange];
            //获取高亮部分
            UITextPosition *pos = [self.textView positionFromPosition:selectedRange.start offset:0];
            if (!pos) {
                NSInteger len = [text charactorNumber];
                if (len>500) {
                    [iToast alertWithTitleCenter:NSLocalizedString(@"home.auth.passwordLength.scaleOut", @"")];
                    text=[text subStringWithLength:500];
                    self.textView.text = text;
                    len = [text charactorNumber];
                }
                _countLab.text = [NSString stringWithFormat:@"%ld/250",len/2];
            }
        }];
    }
    self.tfAry[0].delegate = self;
    [self createBtnViewAdd];
}

#pragma mark ========== 创建团队 ==========
- (void)createBtnViewAdd{
    UIButton *commitTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"提交"];
    commitTeam.enabled = NO;
    [commitTeam addTarget:self action:@selector(commitTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitTeam];
    [commitTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(Interval(58));
        make.height.offset(ZOOM_SCALE(47));
    }];
    
    self.tfAry[0].hll_limitTextLength = 30;
    RACSignal *addressSignal = RACObserve(self.tfAry[1], text);
    RACSignal *tradesSignal =  RACObserve(self.tfAry[2], text);
    
    RACSignal *btnSignal = [RACSignal combineLatest:@[[self.tfAry[0] rac_textSignal],addressSignal,tradesSignal] reduce:^id(NSString * name,NSString * address,NSString *trades){
        NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        name = [name stringByTrimmingCharactersInSet:set];
        return @(name.length>0 && self.tfAry[1].text.length>0 &&self.tfAry[2].text.length>0);
    }];
    RAC(commitTeam,enabled) = btnSignal;
}
- (void)commitTeamClick{
    NSDictionary *params ;
    NSString *province =self.currentProvince;
    NSString *city = self.currentCity;
    
    NSString *name = [self.tfAry[0].text removeFrontBackBlank];
    
    if (self.textView.text.length>0) {
        params= @{@"data":@{@"name":name,@"city":city,@"industry":self.tfAry[2].text,@"province":province,@"tags":@{@"introduction":self.textView.text}}};
    }else{
        params= @{@"data":@{@"name":name,@"city":city,@"industry":self.tfAry[2].text,@"province":province}};
        
    }
    //区分个人团队升级，还是在已有团队的基础上创建新的团队
    NSMutableDictionary *createTMDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    if(_dowhat == newCreateTeam){
        [createTMDic setValue:@"create" forKey:@"operationType"];
        [createTMDic setValue:@{@"isDefault":@YES,@"isAdmin":@YES} forKey:@"relationship"];
    }else{
        [createTMDic setValue:@"upgrade" forKey:@"operationType"];
    }
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_AddTeam withRequestType:NetworkPostType refreshRequest:NO cache:NO params:createTMDic progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            setTeamState(PW_isTeam);
            //如果是个人升级
            if (_dowhat == supplementTeamInfo){
                //获取之前的teammodel，修改team名称
                TeamInfoModel *model = userManager.teamModel;
                model.name = name;
                userManager.teamModel = model;
                [self otherDealAfterNetwork];
            }else{//如果是创建新团队,触发切换操作
                NSDictionary *content = response[@"content"];
                NSString *teamID = content[@"id"];
                [self requestChangeTeam:teamID];
            }
            
        }else{
            if ([response[ERROR_CODE] isEqualToString:@"home.account.alreadyInTeam"]) {
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
                setTeamState(PW_isTeam);
                KPostNotification(KNotificationTeamStatusChange, @YES);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:NO];
                });
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
            }
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
    
}

- (void)transferClick{
    ChooseAdminVC *choose = [[ChooseAdminVC alloc]init];
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark ========== UI ==========
-(UITextView *)textView{
    if (!_textView) {
        _textView = [PWCommonCtrl textViewWithFrame:CGRectMake(kWidth-ZOOM_SCALE(110), ZOOM_SCALE(110), ZOOM_SCALE(100), ZOOM_SCALE(20)) placeHolder:@"请简单介绍一下您的团队（可选）" font:RegularFONT(16)];
    }
    return _textView;
}

- (UIView *)itemWithData:(TeamTF *)teamTf{
    UIView *item = [[UIView alloc]init];
    item.backgroundColor = PWWhiteColor;
    [self.view addSubview:item];
    UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTitleColor text:teamTf.title];
    [item addSubview:titel];
    UITextField *itemTF = [PWCommonCtrl textFieldWithFrame:CGRectMake(Interval(16), Interval(14)+ZOOM_SCALE(20), kWidth-Interval(32), ZOOM_SCALE(22))];
    itemTF.placeholder = teamTf.placeholder;
    itemTF.enabled = teamTf.enabled;
    itemTF.text = teamTf.text;
    BOOL showArrow = teamTf.showArrow;
    [item addSubview:itemTF];
    [self.tfAry addObject:itemTF];
    if (showArrow) {
        UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nextgray"]];
        [item addSubview:arrow];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
        [item addGestureRecognizer:tap];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(item).offset(-Interval(15));
            make.height.offset(ZOOM_SCALE(16));
            make.width.offset(ZOOM_SCALE(11));
            make.centerY.mas_equalTo(item);
        }];
    }
    return item;
}
- (void)itemClick:(UITapGestureRecognizer *)sender{
    if (sender.view.tag == AddressTag) {
        ChooseAddressVC *addressVC = [[ChooseAddressVC alloc]init];
        if (self.tfAry[1].text.length>0) {
            addressVC.currentCity = self.tfAry[1].text;
            addressVC.currentProvince = self.currentProvince;
        }
        addressVC.itemClick = ^(NSString *text){
            NSArray *address = [text componentsSeparatedByString:@" "];
            self.currentProvince =address[0];
            self.currentCity = address[1];
            self.tfAry[1].text = self.currentCity;
        };
        [self.navigationController pushViewController:addressVC animated:YES];
    }else{
        ChooseTradesVC *tradesVC = [[ChooseTradesVC alloc]init];
        if (self.tfAry[2].text.length>0) {
            tradesVC.trades = self.tfAry[2].text;
        }
        tradesVC.itemClick=^(NSString * _Nonnull trades){
            self.tfAry[2].text = trades;
        };
        
        [self.navigationController pushViewController:tradesVC animated:YES];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.tfAry[0]) {
        if (![string isEqualToString:@""]) {
            return [string validateSpecialCharacter];
        }
    }
    
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
}
#pragma mark ---切换团队--
- (void)requestChangeTeam:(NSString *)teamID{
    NSDictionary *params = @{@"data":@{@"teamId":teamID}};
    [PWNetworking requsetHasTokenWithUrl:PW_AuthSwitchTeam withRequestType:NetworkPostType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSString *token = response[@"content"][@"authAccessToken"];
            [[IssueChatDataManager sharedInstance] shutDown];
            [[IssueListManger sharedIssueListManger] shutDown];
            [[PWSocketManager sharedPWSocketManager] shutDown];
            [[IssueSourceManger sharedIssueSourceManger] logout];
            setXAuthToken(token);
            [self otherDealAfterNetwork];
        }
    } failBlock:^(NSError *error) {
    }];
}
- (void)otherDealAfterNetwork{
    //发送团队切换通知
    KPostNotification(KNotificationTeamStatusChange, @YES);
    KPostNotification(KNotificationSwitchTeam, nil);
    [userManager requestMemberList:nil];
    [userManager requestTeamIssueCount:nil];
    CreateSuccessVC *create = [[CreateSuccessVC alloc]init];
    create.groupName = self.tfAry[0].text;
    create.isSupplement = _dowhat == newCreateTeam ? NO:YES;
    create.btnClick =^(){
        [self.navigationController popViewControllerAnimated:NO];
    };
    [self presentViewController:create animated:YES completion:nil];
}

@end
