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
#import "PWBaseWebVC.h"
#import "MoreRuleLinkCell.h"
#import "MoreRuleBtnCell.h"
#import <FTMobileAgent.h>
@interface AddNotiRuleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *navRightBtn;
@property (nonatomic, assign) AddNotiRuleViewStyle style;
@property (nonatomic, assign) NotiRuleStyle ruleStyle;
@property (nonatomic, strong) NotiRuleModel *model;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL subscribe;
@end

@implementation AddNotiRuleVC
-(instancetype)initWithStyle:(AddNotiRuleViewStyle)style ruleStyle:(NotiRuleStyle)ruleStyle{
    self = [super init];
    if (self) {
        self.style = style;
        self.ruleStyle = ruleStyle;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
  
    self.dataSource = [NSMutableArray new];
   
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(80);
    self.tableView.contentInset =UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:AddNotiRuleCell.class forCellReuseIdentifier:@"AddNotiRuleCell"];
    [self.tableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    [self.tableView registerClass:MoreRuleLinkCell.class forCellReuseIdentifier:@"MoreRuleLinkCell"];
    [self.tableView registerClass:MoreRuleBtnCell.class forCellReuseIdentifier:@"MoreRuleBtnCell"];
    [self dealDatas];
   
    
}
- (void)dealDatas{
    NSMutableArray *datas = [NSMutableArray new];
   
    AddNotiRuleModel *nameModel = [[AddNotiRuleModel alloc]init];
    nameModel.title = NSLocalizedString(@"local.ruleName", @"");
    nameModel.placeholderText =NSLocalizedString(@"local.pleaseInputRuleName", @"");
    nameModel.subTitle = @"";
    nameModel.cellStyle = NotiRuleCellName;
    AddNotiRuleModel *conditionModel = [[AddNotiRuleModel alloc]init];
    conditionModel.title = NSLocalizedString(@"local.condition", @"");
    conditionModel.placeholderText =NSLocalizedString(@"local.pleaseInputCondition", @"");
    conditionModel.subTitle = @"";
    conditionModel.cellStyle = NotiRuleCellCondition;
    AddNotiRuleModel *notiWayModel = [AddNotiRuleModel new];
    notiWayModel.title = NSLocalizedString(@"local.notificationWay", @"");
    notiWayModel.placeholderText = NSLocalizedString(@"local.pleaseSelectNotiMethod", @"");
    notiWayModel.subTitle = @"";
    notiWayModel.cellStyle = NotiRuleCellNotiWay;
    AddNotiRuleModel *timeModel = [AddNotiRuleModel new];
    timeModel.title = NSLocalizedString(@"local.time", @"");
    timeModel.cellStyle = NotiRuleCellTime;
    AddNotiRuleModel *weekModel = [AddNotiRuleModel new];
    weekModel.title = NSLocalizedString(@"local.cycle", @"");
    weekModel.cellStyle = NotiRuleCellWeek;
    switch (self.style) {
        case AddNotiRuleAdd:{
            self.model = [[NotiRuleModel alloc]init];
            self.model.weekday = @"0,1,2,3,4";
            NSString *week = [NSString stringWithFormat:@"%@、%@、%@、%@、%@",NSLocalizedString(@"local.Monday", @""),NSLocalizedString(@"local.Tuesday", @""),NSLocalizedString(@"local.Wednesday", @""),NSLocalizedString(@"local.Thursday", @""),NSLocalizedString(@"local.Friday", @"")];
            timeModel.subTitle = @"00:00-23:59";
            weekModel.subTitle = week;
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
            self.navigationItem.rightBarButtonItem = item;
        }
            break;
        case AddNotiRuleEdit:{
            self.model = [self.sendModel copy];
            
            NSString *time = [NSString stringWithFormat:@"%@-%@",self.model.startTime,self.model.endTime];
            nameModel.subTitle =self.model.name;
            conditionModel.subTitle =[self conditionStr];
            notiWayModel.subTitle =[self subNotificationWayStr];
            timeModel.subTitle = time;
            weekModel.subTitle =[self weekStr];
        
            UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
            self.navigationItem.rightBarButtonItem = item;
        }
            break;
            
            
        case AddNotiRuleLookOver:{
            self.model = [self.sendModel copy];
            
            NSString *time = [NSString stringWithFormat:@"%@-%@",self.model.startTime,self.model.endTime];
            
            nameModel.subTitle =self.model.name;
            conditionModel.subTitle =[self conditionStr];
            notiWayModel.subTitle =[self subNotificationWayStr];
            timeModel.subTitle = time;
            weekModel.subTitle =[self weekStr];
        }
            
            break;
    }
    
    
    switch (self.ruleStyle) {
        case NotiRuleBasic:{
            self.title = NSLocalizedString(@"local.BasicNotificationRule", @"");
            [datas addObjectsFromArray: @[nameModel,conditionModel,notiWayModel,timeModel,weekModel]];
            if (self.style == AddNotiRuleAdd) {
                MineCellModel *model = [[MineCellModel alloc]init];
                model.title = NSLocalizedString(@"local.SubscribeRuleAtTheSameTime", @"");
                NSArray *array2= @[model];
                [self.dataSource addObject:array2];
            }
        }
            break;
        case NotiRuleDing:{
            [datas addObjectsFromArray: @[nameModel,conditionModel,timeModel,weekModel]];
     
            self.title = NSLocalizedString(@"local.DingNotificationRule", @"");
            NSMutableArray *dingAry = [NSMutableArray new];
            if (self.sendModel.dingtalkAddress.count>0) {
                [dingAry addObjectsFromArray:self.sendModel.dingtalkAddress];
            }
            if(self.style != AddNotiRuleLookOver){
            [dingAry addObject:NSLocalizedString(@"local.AddDingDingCallbackAddress", @"")];
            }
             [self.dataSource addObject:dingAry];
        }
            break;
        case NotiRuleCustom:{
            [datas addObjectsFromArray: @[nameModel,conditionModel,timeModel,weekModel]];
            self.title = NSLocalizedString(@"local.CustomNotificationRule", @"");
            NSMutableArray *customAry = [NSMutableArray new];
            if (self.sendModel.customAddress.count>0) {
                [customAry addObjectsFromArray:self.sendModel.customAddress];
            }
            if(self.style != AddNotiRuleLookOver){
            [customAry addObject:NSLocalizedString(@"local.AddCustomCallbackAddress", @"")];
            }
            [self.dataSource addObject:customAry];
        }
            break;
    }

    [self.view addSubview:self.tableView];

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
    if(self.model.smsNotification){
        if (notiMethod.length>0) {
            [notiMethod appendString:@"、"];
        }
        [notiMethod appendString:NSLocalizedString(@"local.SMS", @"")];
    }
    if (self.model.voiceNotification) {
        if (notiMethod.length>0) {
            [notiMethod appendString:@"、"];
        }
        [notiMethod appendString:NSLocalizedString(@"local.voice", @"")];
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
    if (condition.length>0) {
        [condition appendString:@"、"];
    }
    if (self.model.rule.origin.count == 0) {
        [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.Origin", @""),NSLocalizedString(@"local.AllOrigin", @"")];
    }else{
        [condition appendFormat:@"%@：%@",NSLocalizedString(@"local.Origin", @""),[self.model.rule.origin[0] getOriginStr]];
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
   
    if (self.ruleStyle ==NotiRuleBasic && self.model.appNotification== NO && self.model.emailNotification == NO &&self.model.smsNotification == NO) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseSelectAtLeastOneNotificationMethod", @"")];
        return;
    }

    if(self.model.weekday.length==0) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.NotificationPeriodCannotBeEmpty", @"")];
        return;
    }
    NSMutableDictionary *data = [NSMutableDictionary new];
    switch (self.ruleStyle) {
       
        case NotiRuleBasic:
            [data addEntriesFromDictionary:@{ @"emailNotification":[NSNumber numberWithBool:self.model.emailNotification],
                                              @"appNotification":[NSNumber numberWithBool:self.model.appNotification],
                                              @"smsNotification":[NSNumber numberWithBool:self.model.smsNotification],
                                              @"voiceNotification":[NSNumber numberWithBool:self.model.voiceNotification],
                                              }];
            break;
        case NotiRuleDing:{
            [self dealLink];
            if (self.model.dingtalkAddress.count>0) {
                [data addEntriesFromDictionary:@{@"dingtalkAddress":self.model.dingtalkAddress,@"dingtalkNotification":@YES}];
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputDingDingCallbackAddress", @"")];
                return;
            }
        }
            break;
        case NotiRuleCustom:{
            [self dealLink];
            if (self.model.customAddress.count>0) {
                [data addEntriesFromDictionary:@{@"customAddress":self.model.customAddress,@"customNotification":@YES}];
            }else{
                [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputCustomCallbackAddress", @"")];
                return;
            }
        }
            break;
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
    if (self.model.rule.origin == nil) {
        self.model.rule.origin = @[];
    }else{
        if ([[self.model.rule.origin firstObject] containsString:NSLocalizedString(@"local.TheUnknownSources", @"")]) {
            self.model.rule.origin = @[NSLocalizedString(@"local.TheUnknownSources", @"")];
        }
    }
    [data addEntriesFromDictionary:@{@"name":self.model.name,
                                     @"startTime":self.model.startTime,
                                     @"endTime":self.model.endTime,
                                     @"weekday":self.model.weekday,
                                     @"rule":
                                         @{@"tags":self.model.rule.tags,
                                           @"type":self.model.rule.type,
                                           @"level":self.model.rule.level,
                                           @"issueSource":self.model.rule.issueSource,
                                           @"origin":self.model.rule.origin,
                                           },
                                     }];
    
    if (self.style == AddNotiRuleAdd) {
        if (self.ruleStyle == NotiRuleBasic && self.subscribe) {
            [data addEntriesFromDictionary:@{@"subscribe":[NSNumber numberWithBool:self.subscribe]}];
        }
       
        [SVProgressHUD show];
        [[PWHttpEngine sharedInstance] addNotificationRuleWithParam:@{@"data":data} callBack:^(id response) {
            [SVProgressHUD dismiss];
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                if (self.refreshList) {
                    self.refreshList();
                }
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
                if (self.refreshList) {
                    self.refreshList();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }
    
}
- (void)dealLink{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSMutableArray *linkArray = [NSMutableArray new];
    __block BOOL hasNull = NO;
    [[self.dataSource lastObject] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj removeFrontBackBlank].length == 0) {
            *stop = YES;
            hasNull = YES;
        }else{
            [linkArray addObject:[obj removeFrontBackBlank]];
        }
    }];
    if (self.ruleStyle == NotiRuleDing) {
        if (hasNull) {
            [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputDingDingCallbackAddress", @"")];
            return;
        }
        self.model.dingtalkAddress = [linkArray subarrayWithRange:NSMakeRange(0, linkArray.count-1)];
    }else{
        if (hasNull) {
            [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputCustomCallbackAddress", @"")];
            return;
        }
        self.model.customAddress = [linkArray subarrayWithRange:NSMakeRange(0, linkArray.count-1)];
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
        if (self.style == AddNotiRuleLookOver) {
            [cell hideArrow];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        if (self.ruleStyle == NotiRuleBasic) {

        MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
        [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeSwitch];
        [cell setSwitchBtnisOn:YES];
        cell.switchChange = ^(BOOL isOn) {
            self.subscribe = isOn;
        };
        self.subscribe = YES;
        return cell;
        }else{
            if(self.style != AddNotiRuleLookOver){
                NSArray *array = self.dataSource[indexPath.section];
                if (array.count == indexPath.row+1) {
                    MoreRuleBtnCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MoreRuleBtnCell"];
                    cell.titleStr = self.dataSource[indexPath.section][indexPath.row];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
            
                MoreRuleLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreRuleLinkCell"];
                cell.linkStr = self.dataSource[indexPath.section][indexPath.row];
                cell.isDing = self.ruleStyle == NotiRuleDing?YES:NO;
                if(self.style != AddNotiRuleLookOver){
                    WeakSelf
                    cell.linkBlock = ^(NSString * _Nonnull str) {
                        [weakSelf.dataSource[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
                    };
                    cell.minusBlock = ^(void){
                        [weakSelf.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView reloadData];
                    };
                }else{
                    [cell noBtn];
                }
               
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
        }
    
}
- (void)viewDingDingWebHookHelp {
    [self viewHelpWithUrl:DING_DING_WEBHOOK_HELP];
}

- (void)viewCustomWebHookHelp {
    [self viewHelpWithUrl:CUSTOM_WEBHOOK_HELP];
}

-(void)viewHelpWithUrl:(NSString *)url{
    PWBaseWebVC *web = [[PWBaseWebVC alloc]initWithTitle:NSLocalizedString(@"local.ViewHelp", @"") andURL:[[NSURL alloc] initWithString:url]];
    [self.navigationController pushViewController:web animated: YES];
}
#pragma mark ========== UITableViewDelegate ==========
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if(self.ruleStyle == NotiRuleCustom){
        return 30;
        }else{
        return 20+ZOOM_SCALE(20);
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.ruleStyle == NotiRuleBasic) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 12)];
        //自定义颜色
        view.backgroundColor = PWBackgroundColor;
        return view;
    }
    NSString *title;
    UIView *content = [[UIView alloc]init];
    UIButton *linkBtn = [PWCommonCtrl buttonWithFrame:CGRectMake(kWidth-ZOOM_SCALE(60)-15, 10, ZOOM_SCALE(60), ZOOM_SCALE(20)) type:PWButtonTypeWord text:NSLocalizedString(@"local.ViewHelp", @"")];
    linkBtn.titleLabel.font = RegularFONT(14);
    content.backgroundColor = PWWhiteColor;
    [content addSubview:linkBtn];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = PWLineColor;
    [content addSubview:line];
    if (section == 1 && self.ruleStyle == NotiRuleDing) {
        title = NSLocalizedString(@"local.DingDingNotificationAdress", @"");
         [linkBtn addTarget:self action:@selector(viewDingDingWebHookHelp) forControlEvents:UIControlEventTouchUpInside];
    }else if(section == 1 && self.ruleStyle == NotiRuleCustom){
        title = NSLocalizedString(@"local.CustomCallbacksAddress", @"");
        [linkBtn addTarget:self action:@selector(viewCustomWebHookHelp) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(15, 10, ZOOM_SCALE(100), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTextBlackColor text:title];
    [content addSubview:titleLab];
    
    return content;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return ZOOM_SCALE(65);
    }
    return ZOOM_SCALE(44);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.style== AddNotiRuleLookOver) {
        return;
    }
    if (indexPath.section==0) {
        __block  AddNotiRuleModel *model =self.dataSource[indexPath.section][indexPath.row];
        WeakSelf
        switch (model.cellStyle) {
            case NotiRuleCellName:
                
                break;
            case NotiRuleCellCondition:{
                SelectConditionVC *condition = [[SelectConditionVC alloc]init];
                condition.model = self.model.rule;
                condition.SelectConditionBlock = ^(RuleModel * _Nonnull ruleModel) {
                    weakSelf.model.rule = ruleModel;
                    model.subTitle = [weakSelf conditionStr];
                    [weakSelf.tableView reloadData];
                };
                [self.navigationController pushViewController:condition animated:YES];
            }
                break;
            case NotiRuleCellTime:{
                NoticeTimeVC *timeVC = [[NoticeTimeVC alloc]init];
                timeVC.model = self.model.startTime == nil?nil:self.model;
                timeVC.timeBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime) {
                    weakSelf.model.startTime = startTime;
                    weakSelf.model.endTime = endTime;
                    model.subTitle = [NSString stringWithFormat:@"%@:%@",startTime,endTime];
                    [weakSelf.tableView reloadData];
                };
                [self.navigationController pushViewController:timeVC animated:YES];
            }
                break;
            case NotiRuleCellWeek:{
                SelectVC *selWeek = [[SelectVC alloc]initWithStyle:SelectWeek];
                selWeek.sendModel = self.model;
                selWeek.selectRuleBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
                    weakSelf.model = ruleModel;
                    model.subTitle = [weakSelf weekStr];
                    [weakSelf.tableView reloadData];
                };
                [self.navigationController pushViewController:selWeek animated:YES];
            }
                break;
            case NotiRuleCellNotiWay:{
                SelectVC *selWeek = [[SelectVC alloc]initWithStyle:SelectNotificationWay];
                selWeek.sendModel = self.model;
                selWeek.selectRuleBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
                    weakSelf.model = ruleModel;
                    model.subTitle = [weakSelf subNotificationWayStr];
                    [weakSelf.tableView reloadData];
                };
                [self.navigationController pushViewController:selWeek animated:YES];
            }
                break;
        }
    }else{
        if (self.ruleStyle!= NotiRuleBasic) {
            NSMutableArray *array = self.dataSource[indexPath.section];
            if (array.count == indexPath.row+1) {
                [array insertObject:@"" atIndex:array.count-1];
                [self.dataSource removeObjectAtIndex:indexPath.section];
                [self.dataSource addObject:array];
                
                [self.tableView reloadData];
            }
        }
    }
 
    /*
     __block  AddNotiRuleModel *model =weakSelf.dataSource[0][5];
     MoreRuleLinkVC *moreVC = [[MoreRuleLinkVC alloc]init];
     moreVC.sendModel = self.model;
     moreVC.addRuleLinkBlock = ^(NotiRuleModel * _Nonnull ruleModel) {
     weakSelf.model = ruleModel;
     model.subTitle =[weakSelf moreRuleLinkStr];
     [weakSelf.tableView reloadData];
     };
     [self.navigationController pushViewController:moreVC animated:YES];
     */

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
