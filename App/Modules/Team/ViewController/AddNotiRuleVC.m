//
//  AddNotiRuleVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AddNotiRuleVC.h"
#import "AddNotiRuleCell.h"
#import "AddNotiRuleModel.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "SelectConditionVC.h"
#import "SelectVC.h"
#import "NotiRuleModel.h"
#import "NoticeTimeVC.h"
#import "IssueSourceManger.h"
#import "MoreRuleLinkVC.h"

@interface AddNotiRuleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, assign) AddNotiRuleStyle style;
@property (nonatomic, strong) NotiRuleModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL subscribe;
@end

@implementation AddNotiRuleVC
-(instancetype)initWithStyle:(AddNotiRuleStyle)style{
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.notificationRule", @"");
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
    self.dataSource = [NSMutableArray new];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(80);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:AddNotiRuleCell.class forCellReuseIdentifier:@"AddNotiRuleCell"];
    [self.tableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    [self dealDatas];
   
    
}
- (void)dealDatas{
    NSArray *array = @[@"local.ruleName",@"local.condition",@"local.notificationWay",@"local.time",@"local.cycle",@"local.more"];
    NSArray *placeholderAry = @[@"local.pleaseInputRuleName",@"local.pleaseInputCondition",@"local.pleaseSelectNotiMethod",@"local.pleaseSelectTime",@"local.pleaseSelectCycle",@"local.addMoreNotiRule"];
    NSArray *subTitleAry;
    if (self.style == AddNotiRuleEdit) {
        self.model = [self.sendModel copy];
       
        NSString *time = [NSString stringWithFormat:@"%@-%@",self.model.startTime,self.model.endTime];
        
        subTitleAry = @[self.model.name,[self conditionStr],[self subNotificationWayStr],time ,[self weekStr],[self moreRuleLinkStr]];
        
    }else{
        self.model = [[NotiRuleModel alloc]init];
        self.model.weekday = @"0,1,2,3,4";
        
        NSString *week = [NSString stringWithFormat:@"%@、%@、%@、%@、%@",NSLocalizedString(@"local.Monday", @""),NSLocalizedString(@"local.Tuesday", @""),NSLocalizedString(@"local.Wednesday", @""),NSLocalizedString(@"local.Thursday", @""),NSLocalizedString(@"local.Friday", @"")];
        subTitleAry  = @[@"",@"",@"",@"00:00-23:59",week,@""];
        MineCellModel *model = [[MineCellModel alloc]init];
        model.title = NSLocalizedString(@"local.SubscribeRuleAtTheSameTime", @"");
        NSArray *array2= @[model];
        [self.dataSource addObject:array2];
    }
    
    NSMutableArray *datas = [NSMutableArray new];
    for(NSInteger i = 0;i<array.count;i++){
        AddNotiRuleModel *model = [[AddNotiRuleModel alloc]init];
        model.title = NSLocalizedString(array[i], @"");
        model.placeholderText =NSLocalizedString(placeholderAry[i], @"");
        model.subTitle = subTitleAry[i];
        [datas addObject:model];
    }
    [self.dataSource insertObject:datas atIndex:0];
    [self.tableView reloadData];
}
- (NSString *)moreRuleLinkStr{
    NSString *text = @"";
    if (self.model.dingtalkAddress.count>0) {
        text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"local.DingDingNotification", @""),NSLocalizedString(@"local.HasBeenOpen", @"")];
    }
    if (self.model.customAddress.count>0) {
        if (text.length>0) {
            text = [text stringByAppendingString:@"、"];
        }
        [text stringByAppendingString:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"local.CustomCallbacks", @""),NSLocalizedString(@"local.HasBeenOpen", @"")]];
    }
    return text;
}
- (NSString *)subNotificationWayStr{
    NSMutableString *notiMethod = [NSMutableString new];
    if (self.model.appNotification) {
        [notiMethod appendString:@"App"];
    }
    if (self.model.emailNotification) {
        if (notiMethod.length>0) {
            [notiMethod appendString:@"、"];
        }
         [notiMethod appendString:NSLocalizedString(@"local.email", @"")];
    }

    return notiMethod;
}
- (NSString *)weekStr{

    if(self.model.weekday.length>0){

        NSArray *week = [self.model.weekday componentsSeparatedByString:@","];

        NSMutableString *weekStr = [NSMutableString new];
        NSString *weeks;
        for (NSInteger i=0; i<week.count; i++) {
            NSInteger day = [week[i] integerValue];
            switch (day) {
                case 0:
                    weeks =NSLocalizedString(@"local.Monday", @"");
                    break;
                case 1:
                    weeks =NSLocalizedString(@"local.Tuesday", @"");
                    break;
                case 2:
                    weeks =NSLocalizedString(@"local.Wednesday", @"");

                    break;
                case 3:
                    weeks =NSLocalizedString(@"local.Thursday", @"");

                    break;
                case 4:
                    weeks =NSLocalizedString(@"local.Friday", @"");

                    break;
                case 5:
                    weeks =NSLocalizedString(@"local.Saturday", @"");

                    break;
                case 6:
                    weeks =NSLocalizedString(@"local.Sunday", @"");
                    break;
            }
            [weekStr appendFormat:@"、%@",weeks];
        }

        [weekStr substringFromIndex:1];
        return [weekStr substringFromIndex:1];
    } else{
        return  @"";
    }
}
- (NSString *)conditionStr{
    NSMutableString *condition = [NSMutableString new];
    if ([self.model.rule.tags allKeys].count>0) {
        NSString *key =[self.model.rule.tags allKeys][0];
        if ([[self.model.rule.tags stringValueForKey:key default:@""] isEqualToString:@""]) {
            [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.ruleTag", @""),key];
        }else{
            [condition appendFormat:@"%@：%@:%@",NSLocalizedString(@"local.ruleTag", @""),key,[self.model.rule.tags stringValueForKey:key default:@""]];
        }
        
    }
        if (self.model.rule.issueSource.count == 0) {
            if (condition.length>0) {
                [condition appendString:@"、"];
            }
            [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.issueSourceAccount", @""),NSLocalizedString(@"local.allIssueSource", @"")];
        }else{
            NSDictionary *source = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameAndProviderWithID:[self.model.rule.issueSource firstObject]];
            NSString *sourceName;
            if (source) {
                sourceName = [source stringValueForKey:@"name" default:@""];
                if (condition.length>0) {
                    [condition appendString:@"、"];
                }
                    [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.issueSourceAccount", @""),sourceName];
            }
        }
           [condition appendString:@"、"];
        if (self.model.rule.type.count == 0 ||self.model.rule.type.count == 5) {
            [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.type", @""),NSLocalizedString(@"local.allIssueType", @"")];
        }else{
            NSString *typeStr = @"";
            for (NSInteger i=0; i<self.model.rule.type.count; i++) {
                [typeStr stringByAppendingString:@"、"];
                typeStr= [typeStr stringByAppendingString:[self.model.rule.type[i] getIssueTypeStr]];
            }
            typeStr = [typeStr substringFromIndex:1];
            [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.type", @""),typeStr];
        }
    [condition appendString:@"、"];
    if(self.model.rule.level.count == 0 || self.model.rule.level.count == 3){
        [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.level", @""),NSLocalizedString(@"local.allIssueLevel", @"")];
    }else{
        NSString *levelStr = @"";
        for (NSInteger i=0; i<self.model.rule.level.count; i++) {
            [levelStr stringByAppendingString:@"、"];
            if ([self.model.rule.level[i] isEqualToString:@"danger"]) {
             levelStr = [levelStr stringByAppendingString:NSLocalizedString(@"local.danger", @"")];
            }else if([self.model.rule.level[i] isEqualToString:@"warning"]){
              levelStr =  [levelStr stringByAppendingString:NSLocalizedString(@"local.warning", @"")];
            }else{
               levelStr = [levelStr stringByAppendingString:NSLocalizedString(@"local.info", @"")];
            }
    }
        levelStr =   [levelStr substringFromIndex:1];
        [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.allIssueLevel", @""),levelStr];

    }
    return condition;
}
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:NSLocalizedString(@"local.save", @"")];
        [_navRightBtn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navRightBtn;
}
- (void)navRightBtnClick{
    [self resignTheFirstResponder];
    if (self.model.name == nil || [self.model.name isEqualToString:@""]) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.RuleNameNotAllowNull", @"")];
        return;
    }
    if (self.model.rule == nil) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.ConditionNotAllowNull", @"")];
        return;
    }
    if (self.model.appNotification== NO && self.model.emailNotification == NO) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseSelectAtLeastOneNotificationMethod", @"")];
        return;
    }

    if(self.model.weekday.length > 0) {

    } else{
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.NotificationPeriodCannotBeEmpty", @"")];
        return;
    }

    
    if (self.model.startTime.length == 0) {
        self.model.startTime = @"00:00";
    }
    if (self.model.endTime.length == 0) {
        self.model.endTime = @"23:59";
    }
    if (self.model.rule.type == nil) {
        self.model.rule.type = @[];
    }
    if (self.model.rule.issueSource == nil) {
        self.model.rule.issueSource = @[];
    }
    if (self.model.rule.level == nil) {
        self.model.rule.level = @[];
    }
    NSMutableDictionary *data  = [
                            @{@"name":self.model.name,
                              @"startTime":self.model.startTime,
                              @"endTime":self.model.endTime,
                              @"weekday":self.model.weekday,
                              @"rule":
                                 @{@"tags":self.model.rule.tags,
                                   @"type":self.model.rule.type,
                                   @"level":self.model.rule.level,
                                   @"issueSource":self.model.rule.issueSource},
                              @"emailNotification":[NSNumber numberWithBool:self.model.emailNotification],
                              @"appNotification":[NSNumber numberWithBool:self.model.appNotification]
                              } mutableCopy];
    if (self.model.dingtalkAddress.count>0) {
        [data addEntriesFromDictionary:@{@"dingtalkAddress":self.model.dingtalkAddress}];
    }
    if (self.model.customAddress.count>0) {
        [data addEntriesFromDictionary:@{@"customAddress":self.model.customAddress}];
    }
    if (self.style == AddNotiRuleAdd) {
        if (self.subscribe) {
            [data addEntriesFromDictionary:@{@"subscribe":[NSNumber numberWithBool:self.subscribe]}];
        }
       
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] addNotificationRuleWithParam:@{@"data":data} callBack:^(id response) {
            [SVProgressHUD dismiss];
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                KPostNotification(KNotificationReloadRuleList, nil);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if([model.errorCode isEqualToString:model.errorMsg]){
                    [iToast alertWithTitleCenter:NSLocalizedString(@"local.err.PleaseTryAgainLater", @"")];
                }else{
                [iToast alertWithTitleCenter:model.errorMsg];
                }
            }
        }];
    }else{
         [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] editNotificationRuleWithParam:@{@"data":data} ruleId:self.model.ruleId callBack:^(id response) {
             [SVProgressHUD dismiss];
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                KPostNotification(KNotificationReloadRuleList, nil);

                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }
    
}
- (void)resignTheFirstResponder {
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry = [self.dataSource objectAtIndex:section];
    if (arry&&arry.count) {
        return arry.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AddNotiRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddNotiRuleCell"];
        if (indexPath.row==0) {
            cell.isTF = YES;
            WeakSelf
           __block AddNotiRuleModel *addmodel = weakSelf.dataSource[indexPath.row][indexPath.section];
            cell.ruleNameClick = ^(NSString * _Nonnull ruleName) {
                weakSelf.model.name = ruleName;
                addmodel.subTitle = ruleName;
            };
        }
        cell.model = self.dataSource[indexPath.section][indexPath.row];
        return cell;
    }else{
        MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
        [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeSwitch];
        [cell setSwitchBtnisOn:YES];
        cell.switchChange = ^(BOOL isOn) {
            self.subscribe = isOn;
        };
        self.subscribe = YES;
        return cell;
    }
}
#pragma mark ========== UITableViewDelegate ==========
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 12)];
    //自定义颜色
    view.backgroundColor = PWBackgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return ZOOM_SCALE(65);
    }
    return ZOOM_SCALE(44);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf
    switch (indexPath.row) {
        case 0:{
            
            break;
        }
        case 1:{
            SelectConditionVC *condition = [[SelectConditionVC alloc]init];
            condition.model = self.model.rule;
            
            __block  AddNotiRuleModel *model =weakSelf.dataSource[0][1];
            condition.SelectConditionBlock = ^(RuleModel * _Nonnull ruleModel) {
                weakSelf.model.rule = ruleModel;
                model.subTitle = [weakSelf conditionStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:condition animated:YES];
            break;
        }
        case 2:{
            __block  AddNotiRuleModel *model =weakSelf.dataSource[0][2];

            SelectVC *selWeek = [[SelectVC alloc]initWithStyle:SelectNotificationWay];
            selWeek.sendModel = self.model;
            selWeek.selectRuleBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
                weakSelf.model = ruleModel;
                model.subTitle = [weakSelf subNotificationWayStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:selWeek animated:YES];
            break;
        }
        case 3:{
            NoticeTimeVC *timeVC = [[NoticeTimeVC alloc]init];
            timeVC.model = self.model.startTime == nil?nil:self.model;
            
            __block  AddNotiRuleModel *model =weakSelf.dataSource[0][3];
  
            timeVC.timeBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
                weakSelf.model.startTime = startTime;
                weakSelf.model.endTime = endTime;
                model.subTitle = [NSString stringWithFormat:@"%@:%@",startTime,endTime];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:timeVC animated:YES];
            break;
        }
        case 4:{
            __block  AddNotiRuleModel *model =weakSelf.dataSource[0][4];
            SelectVC *selWeek = [[SelectVC alloc]initWithStyle:SelectWeek];
            selWeek.sendModel = self.model;
            selWeek.selectRuleBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
                weakSelf.model = ruleModel;
                model.subTitle = [weakSelf weekStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:selWeek animated:YES];
            break;
        }
        case 5:{
            __block  AddNotiRuleModel *model =weakSelf.dataSource[0][5];
            MoreRuleLinkVC *moreVC = [[MoreRuleLinkVC alloc]init];
            moreVC.sendModel = self.model;
            moreVC.addRuleLinkBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
                weakSelf.model = ruleModel;
                model.subTitle =[weakSelf moreRuleLinkStr];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:moreVC animated:YES];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
-(void)dealloc{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
