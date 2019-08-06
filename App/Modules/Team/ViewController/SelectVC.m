//
//  SelectVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/9.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectVC.h"
#import "RuleModel.h"
#import "IssueSourceManger.h"
#import "SelectSourceCell.h"
#import "MultipleSelectModel.h"
#import "MultipleSelectCell.h"
#import "NotiRuleModel.h"
@interface SelectVC ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) SelectStyle style;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isMultiple;
@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, assign) BOOL hasAllCell;//有全选按钮
@end

@implementation SelectVC
-(instancetype)initWithStyle:(SelectStyle)style{
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    self.selectCount = 1;
    self.isMultiple = YES;
    switch (self.style) {
        case SelectWeek:
            self.title = NSLocalizedString(@"local.selectCycle", @"");
            [self createWeekData];
            break;
        case SelectIssueLevel:
            self.title = NSLocalizedString(@"local.selectIssueLevel", @"");
            [self createLevelAry];
            break;
        case SelectIssueType:
            self.title = NSLocalizedString(@"local.selectIssueType", @"");
            [self createIssueTypeAry];
            break;
        case SelectIssueSource:{
            self.title = NSLocalizedString(@"local.selectIssueSource", @"");
             [self loadFromDB];
            [[IssueSourceManger sharedIssueSourceManger] downLoadAllIssueSourceList:^(BaseReturnModel *model) {
                    [self loadFromDB];
            }];
            self.isMultiple = NO;
        }
            break;
        case SelectNotificationWay:
            self.title = NSLocalizedString(@"local.notificationWay", @"");
            [self createNotificationWayData];

            break;
    }
    [self.view addSubview:self.tableView];
    self.tableView.contentInset =  UIEdgeInsetsMake(12, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(44);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:SelectSourceCell.class forCellReuseIdentifier:@"SelectSourceCell"];
    [self.tableView registerClass:MultipleSelectCell.class forCellReuseIdentifier:@"MultipleSelectCell"];
   
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
- (void)createWeekData{
    NSArray *type = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6"];
    NSArray *name = @[NSLocalizedString(@"local.Monday", @""),NSLocalizedString(@"local.Tuesday", @""),NSLocalizedString(@"local.Wednesday", @""),NSLocalizedString(@"local.Thursday", @""),NSLocalizedString(@"local.Friday", @""),NSLocalizedString(@"local.Saturday", @""),NSLocalizedString(@"local.Sunday", @"")];
    for (NSInteger i=0; i<type.count; i++) {
        MultipleSelectModel *model = [MultipleSelectModel new];
        model.name = name[i];
        model.selectId = type[i];
        model.allSelect = NO;
        model.isSelect = [self.sendModel.weekday containsString:type[i]]?YES:NO;
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)createNotificationWayData{
    NSArray *type = @[@"App",@"email"];
    NSArray *name = @[@"App",@"邮箱"];
   
        MultipleSelectModel *model = [MultipleSelectModel new];
        model.name = name[0];
        model.selectId = type[0];
        model.allSelect = NO;
        model.isSelect = self.sendModel.appNotification;
    
        [self.dataSource addObject:model];
     MultipleSelectModel *emailModel = [MultipleSelectModel new];
     emailModel.name = name[1];
     emailModel.selectId = type[1];
     emailModel.allSelect = NO;
     emailModel.isSelect = self.sendModel.emailNotification;
    
    [self.dataSource addObject:emailModel];
    [self.tableView reloadData];
}
- (void)createLevelAry{
    NSArray *type = @[@"danger",@"warning",@"info"];
    NSArray *name = @[NSLocalizedString(@"local.danger", @""),NSLocalizedString(@"local.warning", @""),NSLocalizedString(@"local.info", @"")];
    MultipleSelectModel *allmodel = [MultipleSelectModel new];
    allmodel.name = @"全部等级";
    allmodel.allSelect = YES;
    if (self.model.level.count == 0 || self.model.level.count == 5) {
        allmodel.isSelect = YES;
        self.hasAllCell = YES;
    }
    [self.dataSource addObject:allmodel];
    for (NSInteger i=0; i<type.count; i++) {
        MultipleSelectModel *model = [MultipleSelectModel new];
        model.name = name[i];
        model.selectId = type[i];
        model.allSelect = NO;
        model.isSelect = [self.model.level containsObject:type[i]]?YES:NO;
        if (allmodel.isSelect) {
            model.isSelect = NO;
        }
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)createIssueTypeAry{
    NSArray *type = @[@"alarm",@"security",@"expense",@"optimization",@"alert"];
    NSArray *name = @[[type[0] getIssueTypeStr],[type[1] getIssueTypeStr],[type[2] getIssueTypeStr],[type[3] getIssueTypeStr],[type[4] getIssueTypeStr]];
    MultipleSelectModel *allmodel = [MultipleSelectModel new];
    allmodel.name = @"全部类型";
    allmodel.allSelect = YES;
    if (self.model.type.count == 0 || self.model.type.count == 5) {
        allmodel.isSelect = YES;
        self.hasAllCell = YES;
    }
    [self.dataSource addObject:allmodel];
    for (NSInteger i=0; i<type.count; i++) {
        MultipleSelectModel *model = [MultipleSelectModel new];
        model.name = name[i];
        model.selectId = type[i];
        model.allSelect = NO;
        model.isSelect = [self.model.type containsObject:type[i]]?YES:NO;
        if (allmodel.isSelect) {
            model.isSelect = NO;
        }
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
}
- (void)loadFromDB {
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:@{@"name":@"全部云服务"}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceList];
        dispatch_async_on_main_queue(^{
            
            if (array.count > 0) {
                [self.dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
            }
            
        });
        
    });
}


-(void)saveData{
    WeakSelf
    switch (self.style) {
        case SelectWeek:{
            __block  NSMutableString *weekstr = [NSMutableString new];
            [self.dataSource enumerateObjectsUsingBlock:^(MultipleSelectModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelect) {
                    if (weekstr.length == 0) {
                        [weekstr appendString:obj.selectId];
                    }else{
                        [weekstr appendFormat:@",%@",obj.selectId];
                    }
                }

            }];

            self.sendModel.weekday = weekstr;
            if (self.selectRuleBlock) {
                self.selectRuleBlock(weakSelf.sendModel);
            }
        }

            break;
        case SelectIssueLevel:{
            __block  NSMutableArray *levelAry = [NSMutableArray new];
            [self.dataSource enumerateObjectsUsingBlock:^(MultipleSelectModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.allSelect == YES &&obj.isSelect) {
                    levelAry = nil;
                    *stop = YES;
                }
                if (obj.isSelect) {
                    [levelAry addObject:obj.selectId];
                }
            }];
            weakSelf.model.level = [levelAry copy];
            if (self.selectBlock) {
                self.selectBlock(weakSelf.model);
            }
        }
            break;
        case SelectIssueType:{
            __block  NSMutableArray *typeAry = [NSMutableArray new];
            [self.dataSource enumerateObjectsUsingBlock:^(MultipleSelectModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.allSelect == YES &&obj.isSelect) {
                    typeAry = nil;
                    *stop = YES;
                }
                if (obj.isSelect) {
                    [typeAry addObject:obj.selectId];
                }
            }];
            weakSelf.model.type = [typeAry copy];
            if (self.selectBlock) {
                self.selectBlock(weakSelf.model);
            }
        }
            break;
        case SelectIssueSource:


            break;
        case SelectNotificationWay:{
            MultipleSelectModel *appModel = [self.dataSource firstObject];
            MultipleSelectModel *email = [self.dataSource lastObject];

            self.sendModel.appNotification = appModel.isSelect;
            self.sendModel.emailNotification = email.isSelect;
            if (self.selectRuleBlock) {
                self.selectRuleBlock(weakSelf.sendModel);
            }
        }
            break;
    }
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == SelectIssueSource) {
        SelectSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSourceCell"];
        cell.source = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        MultipleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultipleSelectCell"];
        cell.cellModel = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isMultiple) {
        if (self.style == SelectIssueSource) {
            NSDictionary *source =self.dataSource[indexPath.row];
            NSString *sourceId = [source stringValueForKey:@"id" default:@""];
            NSArray *sourceAry ;
            if (sourceId.length == 0) {
                sourceAry = @[];
            }else{
                sourceAry = @[sourceId];
            }
            WeakSelf
            weakSelf.model.issueSource = sourceAry;
            if (self.selectBlock) {
                self.selectBlock(weakSelf.model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        MultipleSelectModel *model = self.dataSource[indexPath.row];
        model.isSelect = model.allSelect?YES:!model.isSelect;
        if (self.style == SelectIssueLevel ||self.style == SelectIssueType) {
            if (model.allSelect) {
                self.hasAllCell = model.isSelect;
                self.selectCount = model.isSelect?1:0;
            }else{
                if (model.isSelect) {
                    self.selectCount++;
                }else{
                    self.selectCount--;
                }
            }
            if (self.hasAllCell) {
                if (model.allSelect) {
                    self.selectCount = 1;
                    for (MultipleSelectModel *model in self.dataSource) {
                        if( model.allSelect == NO && model.isSelect){
                            model.isSelect = NO;
                        }
                    }
                }else{
                    self.hasAllCell = NO;
                    self.selectCount--;
                    for (MultipleSelectModel *model in self.dataSource) {
                        if( model.allSelect == YES ){
                            model.isSelect = NO;
                        }
                    }
                }
            }
//            if (self.selectCount == self.dataSource.count-1) {
//                for (MultipleSelectModel *model in self.dataSource) {
//                    if( model.allSelect == NO && model.isSelect){
//                        model.isSelect = NO;
//                    }else{
//                        model.isSelect = YES;
//                        self.hasAllCell = YES;
//                        self.selectCount = 1;
//                    }
//                }
//            }
        }

      
        [self.tableView reloadData];
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveData];
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
//    return NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
