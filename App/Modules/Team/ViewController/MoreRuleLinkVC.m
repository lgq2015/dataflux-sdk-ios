//
//  MoreRuleLinkVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreRuleLinkVC.h"
#import "NotiRuleModel.h"
#import "MoreRuleLinkCell.h"
#import "MoreRuleBtnCell.h"
#import "HLSafeMutableArray.h"
#import "PWBaseWebVC.h"

@interface MoreRuleLinkVC ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HLSafeMutableArray *dataSource;
@end

@implementation MoreRuleLinkVC
-(void)viewWillAppear:(BOOL)animated{
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.more", @"");
    [self creteUI];
}

- (void)creteUI{
    self.dataSource = [HLSafeMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(44);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:MoreRuleLinkCell.class forCellReuseIdentifier:@"MoreRuleLinkCell"];
    [self.tableView registerClass:MoreRuleBtnCell.class forCellReuseIdentifier:@"MoreRuleBtnCell"];
    NSMutableArray *dingAry = [NSMutableArray new];
    NSMutableArray *customAry = [NSMutableArray new];
    if (self.sendModel.dingtalkAddress.count>0) {
        [dingAry addObjectsFromArray:self.sendModel.dingtalkAddress];
    }
    if (self.sendModel.customAddress.count>0) {
        [customAry addObjectsFromArray:self.sendModel.customAddress];
    }
    [dingAry addObject:NSLocalizedString(@"local.AddDingDingCallbackAddress", @"")];
    [customAry addObject:NSLocalizedString(@"local.AddCustomCallbackAddress", @"")];
    [self.dataSource addObject:dingAry];
    [self.dataSource addObject:customAry];
    [self.tableView reloadData];

}
-(void)backBtnClicked{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithArray:[self.dataSource firstObject]];
    NSMutableArray *array2 = [[NSMutableArray alloc]initWithArray:[self.dataSource lastObject]];

   __block BOOL isEmpty = NO;
    [array1 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]) {
            isEmpty = YES;
            *stop = YES;
        }
    }];
    if (isEmpty) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputDingDingCallbackAddress", @"")];
        return;
    }
    [array2 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]) {
            isEmpty = YES;
            *stop = YES;
        }
    }];
    if (isEmpty) {
        [iToast alertWithTitleCenter:NSLocalizedString(@"local.PleaseInputCustomCallbackAddress", @"")];
        return;
    }
    self.sendModel.dingtalkAddress = [array1 subarrayWithRange:NSMakeRange(0, array1.count-1)];
    self.sendModel.customAddress = [array1 subarrayWithRange:NSMakeRange(0, array2.count-1)];
    if (self.addRuleLinkBlock) {
        self.addRuleLinkBlock(self.sendModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataSource[indexPath.section];
    if (array.count == indexPath.row+1) {
        return ZOOM_SCALE(44);
    }
    return ZOOM_SCALE(62);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array =self.dataSource[section];
    return array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20+ZOOM_SCALE(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title;
    if (section == 0) {
        title = NSLocalizedString(@"local.DingDingNotification", @"");
    }else{
        title = NSLocalizedString(@"local.CustomCallbacks", @"");
    }
    UIView *content = [[UIView alloc]init];
    UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectMake(15, 10, ZOOM_SCALE(70), ZOOM_SCALE(20)) font:RegularFONT(14) textColor:PWTextBlackColor text:title];
    [content addSubview:titleLab];
    UIButton *linkBtn = [PWCommonCtrl buttonWithFrame:CGRectMake(kWidth-ZOOM_SCALE(60)-15, 10, ZOOM_SCALE(60), ZOOM_SCALE(20)) type:PWButtonTypeWord text:NSLocalizedString(@"local.ViewHelp", @"")];
    linkBtn.titleLabel.font = RegularFONT(14);
    content.backgroundColor = PWBackgroundColor;
    [content addSubview:linkBtn];

    if (section == 0) {
        [linkBtn addTarget:self action:@selector(viewDingDingWebHookHelp) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [linkBtn addTarget:self action:@selector(viewCustomWebHookHelp) forControlEvents:UIControlEventTouchUpInside];
    }

    return content;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataSource[indexPath.section];
    if (array.count == indexPath.row+1) {
        MoreRuleBtnCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MoreRuleBtnCell"];
        cell.titleStr = self.dataSource[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
    MoreRuleLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreRuleLinkCell"];
        cell.linkStr = self.dataSource[indexPath.section][indexPath.row];
        cell.isDing = indexPath.section == 0?YES:NO;
        WeakSelf
        cell.linkBlock = ^(NSString * _Nonnull str) {
            [weakSelf.dataSource[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
        };
        cell.minusBlock = ^(void){
            [weakSelf.dataSource[indexPath.section] removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSMutableArray *array = self.dataSource[indexPath.section];
    if (array.count == indexPath.row+1) {
        [array insertObject:@"" atIndex:array.count-1];
        [self.dataSource removeObjectAtIndex:indexPath.section];
        if (indexPath.section == 0) {
            [self.dataSource insertObject:array atIndex:0];
        }else{
            [self.dataSource addObject:array];
        }
        [self.tableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    return NO;
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
