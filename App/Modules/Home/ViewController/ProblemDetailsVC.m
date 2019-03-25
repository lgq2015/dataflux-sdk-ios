//
//  ProblemDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ProblemDetailsVC.h"
#import "IssueExtraCell.h"
#import "IssueExtraModel.h"
#import "PPBadgeView.h"
#import "PWBaseWebVC.h"
#import "PWChatVC.h"

@interface ProblemDetailsVC ()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIButton *ignoreBtn;

@property (nonatomic, strong) NSMutableArray *expireData;
@property (nonatomic, strong) UILabel *createNameLab;
@end

@implementation ProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题详情";
     [self setupView];
    [self loadIssueDetailExtra];
    [self loadInfoDeatil];
}
#pragma mark ========== datas ==========
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            self.infoDetailDict = content;
            NSDictionary *accountInfo = content[@"accountInfo"];
            NSString *name = [accountInfo stringValueForKey:@"name" default:@""];
            self.createNameLab.text = [NSString stringWithFormat:@"%@ 创建",name];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadIssueDetailExtra{
    self.expireData = [NSMutableArray new];
    NSDictionary *param = @{@"pageSize": @100,@"type":@"attachment",@"subType":@"issueDetailExtra",@"_withAttachmentExternalDownloadURL":@YES,@"_attachmentExternalDownloadURLOSSExpires":[NSNumber numberWithInt:3600]};
    [PWNetworking requsetHasTokenWithUrl:PW_issueLog(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            [self.expireData addObjectsFromArray:data];
            [self dealWithSubViewWithData:data];
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark ========== UI ==========


- (void)setupView{
    [self.createNameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(Interval(16));
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(Interval(11));
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.createNameLab.mas_bottom).offset(ZOOM_SCALE(11));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
    }];
    self.contentLab.text = self.model.content;
}

- (void)dealWithSubViewWithData:(NSArray *)data{
       UIView *temp;
    if (data.count>0) {
        [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
            make.width.offset(kWidth);
        }];
        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTextBlackColor text:@"附件"];
        [self.subContainerView addSubview:title];
        [self.subContainerView addSubview:self.tableView];
        self.tableView.backgroundColor = PWWhiteColor;
        [self.tableView registerClass:IssueExtraCell.class forCellReuseIdentifier:@"IssueExtraCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = ZOOM_SCALE(70);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(title.mas_bottom).offset(Interval(25));
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(70)*data.count);
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(15));
        }];
        temp = self.subContainerView;
    }else{
        temp = self.upContainerView;
    }
    DLog(@"model = %@ account = %@",self.model.accountId,getPWUserID);
    if ([[self.model.accountId stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID] || userManager.teamModel.isAdmin) {
        
        [self.ignoreBtn setTitle:@"关闭此问题" forState:UIControlStateNormal];
        
        self.ignoreBtn.hidden = self.model.state == MonitorListStateRecommend?YES:NO;
        
        [self.ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(temp.mas_bottom).offset(Interval(20));
            make.width.offset(ZOOM_SCALE(100));
            make.height.offset(ZOOM_SCALE(20));
            make.centerX.mas_equalTo(self.mainScrollView);
        }];
    }else{
        _ignoreBtn.hidden = YES;
    }
    [self.view layoutIfNeeded];
    
    
    self.mainScrollView.contentSize = CGSizeMake(kWidth, CGRectGetMaxY(self.subContainerView.frame)+35);
}



#pragma mark ========== subView ==========
-(UILabel *)createNameLab{
    if (!_createNameLab) {
        _createNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_createNameLab];
    }
    return _createNameLab;
}
-(UIButton *)ignoreBtn{
    if (!_ignoreBtn) {
        _ignoreBtn = [[UIButton alloc]init];
        [_ignoreBtn setTitle:@"关闭此问题" forState:UIControlStateNormal];
        [_ignoreBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        _ignoreBtn.titleLabel.font = RegularFONT(14);
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:_ignoreBtn];
    }
    return _ignoreBtn;
}
#pragma mark ========== btnClick ==========

- (void)ignoreBtnClick:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭问题将会结束该问题相关的讨论与服务" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm =[PWCommonCtrl actionWithTitle:@"确认关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [PWNetworking requsetHasTokenWithUrl:PW_issueRecover(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
}

#pragma mark ========== 讨论页跳转 ==========
- (void)navRightBtnClick{
    PWChatVC *chat = [[PWChatVC alloc]init];
     chat.infoDetailDict = self.infoDetailDict;
    [self.navigationController pushViewController:chat animated:YES];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.expireData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssueExtraCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueExtraCell"];
    IssueExtraModel *model = [[IssueExtraModel alloc]initWithDictionary:self.expireData[indexPath.row]];
    cell.model = model;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IssueExtraModel *model = [[IssueExtraModel alloc]initWithDictionary:self.expireData[indexPath.row]];
    DLog(@"%@",model.fileUrl);

    PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:@"附件" andURLString:model.fileUrl];
    [self.navigationController pushViewController:webView animated:YES];
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
