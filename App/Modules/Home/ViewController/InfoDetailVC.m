//
//  InfoDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InfoDetailVC.h"
#import "PPBadgeView.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "NewsWebView.h"
#import "HandbookModel.h"
@interface InfoDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *progressBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *typeIcon;
@property (nonatomic, strong) UILabel *issueNameLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *contentImg;

@property (nonatomic, strong) NSMutableArray *progressData;

@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIView *suggestion;
@property (nonatomic, strong) NSMutableArray *handbookAry;
@end

@implementation InfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报详情";
    [self createUI];
    [self loadInfoDeatil];
}
#pragma mark ========== UI ==========
- (void)createUI{
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:PWBlueColor forKey:NSForegroundColorAttributeName];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    [self setupView];
    [self setSubView];
    [self loadProgressData];
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
    self.timeLab.text =@"今天  11:50";
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
    [self.typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(ZOOM_SCALE(13));
        make.width.offset(ZOOM_SCALE(39));
        make.height.offset(ZOOM_SCALE(27));
    }];
    self.typeIcon.image = [UIImage imageNamed:@"icon_ali"];
    [self.issueNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(11));
        make.centerY.mas_equalTo(self.typeIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.issueNameLab.text = @"我的阿里云";
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.typeIcon.mas_bottom);
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    NSString * htmlString = self.model.content;
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
   
    self.contentLab.attributedText = attrStr;
    self.contentLab.font = MediumFONT(14);
    self.contentLab.textColor = PWSubTitleColor;
    
    [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
        make.height.offset(0);
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
    }];

}
- (void)setSubView{
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
        make.left.right.mas_equalTo(self.view);
        make.width.offset(kWidth);
    }];
    [self setSuggestSubView];
}

-(void)setSuggestSubView{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTextBlackColor text:@"建议"];
    [self.subContainerView addSubview:title];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"professor"]];
    icon.frame = CGRectMake(Interval(16), ZOOM_SCALE(55), ZOOM_SCALE(60), ZOOM_SCALE(60));
    [self.subContainerView addSubview:icon];
    [self.subContainerView addSubview:self.tableView];
   
    UIView *suggestion = [[UIView alloc]init];
    suggestion.backgroundColor = [UIColor colorWithHexString:@"#5090F5"];
    suggestion.layer.cornerRadius = 4;
    [self.subContainerView addSubview:suggestion];
    [suggestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(Interval(18));
        make.top.mas_equalTo(icon);
        make.right.mas_equalTo(self.subContainerView).offset(-Interval(16));
    }];
    self.suggestion = suggestion;
    UILabel *sugLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWWhiteColor text:self.model.attrs];
    sugLab.numberOfLines = 0;
    sugLab.textColor = PWWhiteColor;
    [suggestion addSubview:sugLab];
    [sugLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(suggestion).offset(Interval(14));
        make.top.mas_equalTo(suggestion.mas_top).offset(Interval(9));
        make.right.mas_equalTo(suggestion).offset(-13);
        make.bottom.mas_equalTo(suggestion.bottom).offset(-9);
    }];
    self.tableView.backgroundColor = PWWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.suggestion.mas_bottom).offset(Interval(15));
        make.width.offset(kWidth);
        make.height.offset(self.handbookAry.count*45);
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
    }];
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
    
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
}
#pragma mark ========== UI/INIT ==========
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
-(UIImageView *)typeIcon{
    if (!_typeIcon) {
        _typeIcon = [[UIImageView alloc]init];
        [self.upContainerView addSubview:_typeIcon];
    }
    return _typeIcon;
}
-(UILabel *)issueNameLab{
    if (!_issueNameLab) {
        _issueNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_issueNameLab];
    }
    return _issueNameLab;
}
-(UIImageView *)contentImg{
    if (!_contentImg) {
        _contentImg = [[UIImageView alloc]init];
        _contentImg.backgroundColor = PWGrayColor;
        [self.upContainerView addSubview:_contentImg];
    }
    return _contentImg;
}
-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.clipsToBounds = YES;
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

#pragma mark ========== btnClick ==========
- (void)showProgress:(UIButton *)button{
    self.progressBtn.selected = !button.selected;
    [self.view setNeedsUpdateConstraints];
    if (button.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.offset(self.progressData.count*ZOOM_SCALE(27)+3);
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
    
    CGFloat height =self.model.isFromUser?CGRectGetMaxY(self.ignoreBtn.frame):CGRectGetMaxY(self.subContainerView.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
    
}
- (void)ignoreBtnClick:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文案产品提供" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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


#pragma mark ========== BTNCLICK ==========
- (void)navRightBtnClick{
    
}
#pragma mark ========== DATA/DEAL ==========
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            [self dealHandBookViewWith:content];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (void)dealHandBookViewWith:(NSDictionary *)dict{
    if (dict[@"reference"] &&dict[@"reference"][@"articles"]) {
        self.handbookAry = [NSMutableArray new];
        [self.handbookAry addObjectsFromArray:dict[@"reference"][@"articles"]];
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.suggestion.mas_bottom).offset(Interval(15));
        make.width.offset(kWidth);
        make.height.offset(self.handbookAry.count*45);
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
    }];
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
}
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
-(void)updateViewConstraints{
    [super updateViewConstraints];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.handbookAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    NSString *title = self.handbookAry[indexPath.row][@"title"];
    MineCellModel *model = [[MineCellModel alloc]initWithTitle:title];
    [cell initWithData:model type:MineVCCellTypeTitle];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict =  self.handbookAry[indexPath.row];
    NSError *error;
    HandbookModel *model = [[HandbookModel alloc]initWithDictionary:dict error:&error];
    NewsWebView *webview = [[NewsWebView alloc]initWithTitle:model.title andURLString:PW_handbookUrl(model.articleId)];
    webview.handbookModel = model;
    [self.navigationController pushViewController:webview animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
