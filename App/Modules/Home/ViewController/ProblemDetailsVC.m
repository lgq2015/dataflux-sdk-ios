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
#import "TeamInfoModel.h"
#import "PWBaseWebVC.h"

@interface ProblemDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *progressBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) UIButton *ignoreBtn;

@property (nonatomic, strong) NSMutableArray *progressData;
@property (nonatomic, strong) NSMutableArray *expireData;
@end

@implementation ProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题详情";
    [self createUI];
    [self loadIssueDetailExtra];
}
#pragma mark ========== datas ==========
- (void)loadProgressData{
    self.progressData = [NSMutableArray new];
    NSDictionary *param = @{@"pageSize": @100,@"type":@"keyPoint,bizPoint",@"subType":@"issueCreated,issueRecovered,issueExpired,exitExpertGroups,issueDiscarded,updateExpertGroups"};
    [PWNetworking requsetHasTokenWithUrl:PW_issueLog(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            [self.progressData addObjectsFromArray:data];
            [self dealWithProgressView];
        }
    } failBlock:^(NSError *error) {
        
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
- (void)createUI{
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:PWBlueColor forKey:NSForegroundColorAttributeName];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self setupBadges];
    //    });
    [self setupView];
    [self loadProgressData];
#pragma mark 导航
    //    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    //    [self.navRightBtn setBadgeValue:2];
    //    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)dealWithProgressView{
    DLog(@"progressData = %@",self.progressData);
    UIView *temp = nil;
    if (self.progressData.count>0) {
        for (NSInteger i= 0; i<self.progressData.count; i++) {
            UIView *dot = [[UIView alloc]init];
            dot.layer.cornerRadius = 3;
            dot.backgroundColor = [UIColor colorWithHexString:@"#FFB0B0"];
            [self.progressView addSubview:dot];
            if (temp==nil) {
                [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view).offset(Interval(16));
                    make.top.mas_equalTo(self.progressView).offset(Interval(12));
                    make.width.height.offset(6);
                }];
            }else{
                [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(temp);
                    make.top.mas_equalTo(temp.mas_bottom).offset(Interval(18));
                    make.width.height.offset(6);
                }];
            }
            UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTitleColor text:@""];
            [self.progressView addSubview:timeLab];
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(dot.mas_right).offset(Interval(3));
                make.centerY.mas_equalTo(dot);
                make.height.offset(ZOOM_SCALE(17));
            }];
            timeLab.text = [NSString progressLabText:self.progressData[i]];
            temp = dot;
        }
    }
}
- (void)setupView{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_upContainerView).offset(Interval(16));
        make.top.mas_equalTo(_upContainerView).offset(Interval(14));
        make.right.mas_equalTo(_upContainerView).offset(-Interval(16));
    }];
    [self.upContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScrollView).offset(Interval(12));
        make.width.offset(kWidth);
    }];
    self.titleLab.text =self.model.title;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(16);
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(10));
    }];
    switch (self.model.state) {
        case MonitorListStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case MonitorListStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case MonitorListStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"普通";
            break;
        case MonitorListStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已解决";
            break;
        case MonitorListStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(ZOOM_SCALE(15));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.timeLab.text = self.model.time;
    [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(Interval(7));
        make.centerY.mas_equalTo(self.timeLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kWidth);
        make.height.offset(1);
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(ZOOM_SCALE(1));
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(ZOOM_SCALE(11));
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

-(UIView *)upContainerView{
    if (!_upContainerView) {
        _upContainerView = [[UIView alloc]init];
        _upContainerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_upContainerView];
    }
    return _upContainerView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTextBlackColor text:@""];
        _titleLab.numberOfLines = 0;
        [self.upContainerView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWSubTitleColor text:nil];
        _contentLab.backgroundColor = PWWhiteColor;
        _contentLab.numberOfLines = 0;
        [self.upContainerView addSubview:_contentLab];
    }
    return _contentLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), Interval(17), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.upContainerView addSubview:_stateLab];
    }
    return _stateLab;
}
-(UIButton *)progressBtn{
    if (!_progressBtn) {
        _progressBtn = [[UIButton alloc]init];
        [_progressBtn setTitle:@"情报进展" forState:UIControlStateNormal];
        _progressBtn.titleLabel.font =MediumFONT(13);
        [_progressBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        [_progressBtn setImage:[UIImage imageNamed:@"icon_nextgray"] forState:UIControlStateNormal];
        [_progressBtn addTarget:self action:@selector(showProgress:) forControlEvents:UIControlEventTouchUpInside];
        [_progressBtn sizeToFit];

        _progressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_progressBtn.imageView.frame.size.width - _progressBtn.frame.size.width + _progressBtn.titleLabel.frame.size.width, 0, 0);
        
        _progressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_progressBtn.titleLabel.frame.size.width - _progressBtn.frame.size.width + _progressBtn.imageView.frame.size.width);
        [self.upContainerView addSubview:_progressBtn];
    }
    return _progressBtn;
}


-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.clipsToBounds =YES;
        [self.upContainerView addSubview:_progressView];
    }
    return _progressView;
}
#pragma mark ========== subView ==========
-(UIView *)subContainerView{
    if (!_subContainerView) {
        _subContainerView = [[UIView alloc]init];
        _subContainerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_subContainerView];
    }
    return _subContainerView;
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
- (void)showProgress:(UIButton *)button{

    self.progressBtn.selected = !button.selected;
    [self.view setNeedsUpdateConstraints];
    if (button.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            
                make.height.offset(self.progressData.count*ZOOM_SCALE(23)+3);
            }];
            [self.progressView layoutIfNeeded];
            [self.view layoutIfNeeded];

        }];
        

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(1);
            }];
            [self.progressView layoutIfNeeded];
            [self.view layoutIfNeeded];

        }];
       
    }
//    self.progressView.hidden = !button.selected;

    CGFloat height =CGRectGetMaxY(self.subContainerView.frame);
    if (!self.ignoreBtn.hidden) {
        height+=50;
    }
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
  
}
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
- (void)navRightBtnClick:(UIButton *)button{
    
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
