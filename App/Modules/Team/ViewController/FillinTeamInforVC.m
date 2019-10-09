//
//  FillinTeamInforVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FillinTeamInforVC.h"
#import "ChooseAddressVC.h"
#import "ChooseTradesVC.h"
#import "CreateSuccessVC.h"
#import "TeamInfoModel.h"
#import "TeamVC.h"
#import "ChooseAdminVC.h"
#import "ChangeUserInfoVC.h"
#import "UITextField+HLLHelper.h"
#import "ZhugeIOTeamHelper.h"
#import "NSString+ErrorCode.h"

#define AddressTag 15
#define TradesTag  20

@interface FillinTeamInforVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray<UITextField *> *tfAry;
@property (nonatomic, assign) FillinTeamType type;
@property (nonatomic, strong) TeamFillConfige *mConfige;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, strong) UILabel *countLab;
@end

@implementation FillinTeamInforVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;

        [[[ZhugeIOTeamHelper new] eventCreateTeamStay] startTrack];
    }}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tfAry = [NSMutableArray new];
    [self judgeVcType];
}
- (void)judgeVcType{
    self.mConfige = [[TeamFillConfige alloc]init];
    self.title = self.mConfige.title;
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
   
        UILabel *titel = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(8), ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTitleColor text:NSLocalizedString(@"local.TeamIntroduction", @"")];
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
    switch (self.mConfige.type) {
        case FillinTeamTypeAdd:
            [self createBtnViewAdd];
            break;
        case FillinTeamTypeIsAdmin:
            [self createBtnViewAdmin];
            break;
        case FillinTeamTypeIsMember:
            [self createBtnViewMember];
            break;
        case FillinTeamTypeIsManger:
            self.tfAry[0].hll_limitTextLength = 30;
            [self createBtnViewMember];
            self.textView.editable = YES;
            break;
    }
    
}
#pragma mark ========== 团队/个人 ==========
- (void)createBtnViewMember{
    self.textView.editable = NO;
    UIButton *commitTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:NSLocalizedString(@"local.ExitTheTeam", @"")];
    [commitTeam addTarget:self action:@selector(exictTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitTeam];
    [commitTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        if (!self.mConfige.showDescribe) {
            make.top.mas_equalTo(self.textView.mas_bottom).offset(Interval(78)-ZOOM_SCALE(130));
        }else{
        make.top.mas_equalTo(self.textView.mas_bottom).offset(Interval(78));
        }
        make.height.offset(ZOOM_SCALE(47));
    }];
}

-(void)exictTeamClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"local.tip.ExitTheTeamTip", @"") preferredStyle:UIAlertControllerStyleActionSheet];
     UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:alert.view];
     if (messageParentView && [messageParentView isKindOfClass:UILabel.class]) {
        UILabel *lable = (UILabel *)messageParentView;
         lable.textAlignment = NSTextAlignmentLeft;
     }
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmExit", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [SVProgressHUD show];
        NSString *uid =userManager.curUserInfo.userID;
        [PWNetworking requsetHasTokenWithUrl:PW_AccountRemove(uid) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            [SVProgressHUD dismiss];
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"local.ExitSuccessfully", @"")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [userManager logout:nil];
                });

                [[[[ZhugeIOTeamHelper new] eventSignOutTeam] attrResultSuccess] track];

            }else{
                
            }
        } failBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
            [[[[ZhugeIOTeamHelper new] eventSignOutTeam] attrResultCancel] track];
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ========== 创建团队 ==========
- (void)createBtnViewAdd{
    UIButton *commitTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:NSLocalizedString(@"local.submit", @"")];
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
    //创建团队：区分个人团队升级，还是在已有团队的基础上创建新的团队
    if([getTeamState isEqualToString:PW_isTeam]){
        [params setValue:@"create" forKey:@"operationType"];
        [params setValue:@{@"isDefault":@YES,@"isAdmin":@YES} forKey:@"relationship"];
    }
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_AddTeam withRequestType:NetworkPostType refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:^(id response) {
        if ([response[ERROR_CODE] isEqualToString:@""]) {
                CreateSuccessVC *create = [[CreateSuccessVC alloc]init];
                create.groupName = self.tfAry[0].text;
                create.btnClick =^(){
                    KPostNotification(KNotificationTeamStatusChange, @YES);
                    setTeamState(PW_isTeam);
                    [self.navigationController popViewControllerAnimated:NO];
                };
            [self presentViewController:create animated:YES completion:nil];  
        }else{
            if ([response[ERROR_CODE] isEqualToString:@"home.account.alreadyInTeam"]) {
                [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
                KPostNotification(KNotificationTeamStatusChange, @YES);
                setTeamState(PW_isTeam);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:NO];
                });
            }else{
                [iToast alertWithTitleCenter:[response[ERROR_CODE] toErrString]];
            }
        }
        [SVProgressHUD dismiss];
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
    
}
#pragma mark ========== 团队/管理员 ==========
- (void)createBtnViewAdmin{

    UIButton *transferTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:NSLocalizedString(@"local.TransferManager", @"")];
    [transferTeam addTarget:self action:@selector(transferClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transferTeam];
    [transferTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(Interval(78));
        make.height.offset(ZOOM_SCALE(47));
    }];
    if(self.count<2){
        transferTeam.enabled = NO;
    }
    UIButton *logoutTeam = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeSummarize text:NSLocalizedString(@"local.DissolutionTeam", @"")];
    [logoutTeam addTarget:self action:@selector(logoutTeamClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutTeam];
    [logoutTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.top.mas_equalTo(transferTeam.mas_bottom).offset(Interval(20));
        make.height.offset(ZOOM_SCALE(47));
    }];
    self.tfAry[0].hll_limitTextLength = 30;

}
- (void)logoutTeamClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"local.tip.DissolutionTeamTip", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.ConfirmDissolution", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self logoutTeamRequest];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:NSLocalizedString(@"local.cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logoutTeamRequest{
    ChangeUserInfoVC *verify = [[ChangeUserInfoVC alloc]init];
    verify.isShowCustomNaviBar = YES;
    verify.type = ChangeUITTeamDissolve;
    [self.navigationController pushViewController:verify animated:YES];
    
}
- (void)backBtnClicked{
    if (self.mConfige.type == FillinTeamTypeIsAdmin || self.mConfige.type == FillinTeamTypeIsManger) {
        TeamInfoModel *model = userManager.teamModel;
        if ([self.tfAry[0].text isEqualToString:model.name] &&[self.currentProvince isEqualToString:model.province] && [self.currentCity isEqualToString:model.city]&& [self.tfAry[2].text isEqualToString: model.industry] && [self.textView.text isEqualToString:[model.tags stringValueForKey:@"introduction" default:@""]] ) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
             NSString *name = [self.tfAry[0].text stringByTrimmingCharactersInSet:set];
            if ([name isEqualToString:@""]) {
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.TeamNameCannotBeEmpty", @"")];
            }else{
                [SVProgressHUD show];
                NSDictionary *param ;
                NSString *province =self.currentProvince;
                NSString *city = self.currentCity;
                //安全判断
                city = city == nil ? @"" : city;
                province = province == nil ? @"" : province;
                self.tfAry[2].text = [self.tfAry[2].text isEqualToString:@""] ? @"" :  self.tfAry[2].text;
                
                if ([self.tfAry[0].text isEqualToString:model.name]) {
                    param= @{@"data":@{@"city":city,@"industry":self.tfAry[2].text,@"province":province,@"tags":@{@"introduction":[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]}}};
                }else{
                    param= @{@"data":@{@"name":name,@"city":city,@"industry":self.tfAry[2].text,@"province":province,@"tags":@{@"introduction":self.textView.text}}};
                }
                [[PWHttpEngine sharedInstance] teamModifyWithParam:param callBack:^(id response) {
                    [SVProgressHUD dismiss];
                    BaseReturnModel *model = response;
                    if (model.isSuccess) {
                        if (self.changeSuccess) {
                            self.changeSuccess();
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [iToast alertWithTitleCenter:model.errorMsg];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }];
            }
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void)transferClick{
    ChooseAdminVC *choose = [[ChooseAdminVC alloc]init];
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark ========== UI ==========
-(UITextView *)textView{
    if (!_textView) {

        _textView = [PWCommonCtrl textViewWithFrame:CGRectMake(kWidth-ZOOM_SCALE(110), ZOOM_SCALE(110), ZOOM_SCALE(100), ZOOM_SCALE(20)) placeHolder:NSLocalizedString(@"local.placeholder.teamIntroduction", @"") font:RegularFONT(16)];
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
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            return subView;
        }else{
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}

- (void)dealloc {
    [[[[ZhugeIOTeamHelper new] eventCreateTeamStay] attrStayTime] endTrack];

}


@end
