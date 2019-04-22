//
//  IssueDetailVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueDetailVC.h"
#import "PPBadgeView.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "NewsWebView.h"
#import "HandbookModel.h"
#import "IssueSourceManger.h"
#import "EchartTableView.h"
#import "ExpertsSuggestVC.h"
#import "TriangleLeft.h"
#import "EchartView.h"
#import "EchartTableView.h"
#import "EchartListView.h"
#import "FillinTeamInforVC.h"
#import "ExpertsMoreVC.h"
@interface IssueDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *typeIcon;
@property (nonatomic, strong) UILabel *issueNameLab;

@property (nonatomic, strong) UIView *suggestion;
@property (nonatomic, strong) NSMutableArray *handbookAry;
@property (nonatomic, strong) UIView *echartContenterView;


@end

@implementation IssueDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"情报详情";
    [self setupView];
    [self setSubView];
    [self loadInfoDeatil];
}
#pragma mark ========== UI ==========

- (void)setupView{
    [self.typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(ZOOM_SCALE(13));
        make.width.offset(ZOOM_SCALE(39));
        make.height.offset(ZOOM_SCALE(27));
    }];
    [self.issueNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(11));
        make.centerY.mas_equalTo(self.typeIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.typeIcon.mas_bottom).offset(Interval(8));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    NSString * htmlString = self.model.content;
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    self.contentLab.attributedText = attrStr;
    self.contentLab.font = RegularFONT(14);
    self.contentLab.textColor = PWSubTitleColor;
   
    [self.echartContenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
        make.left.mas_equalTo(self.upContainerView);
        make.right.mas_equalTo(self.upContainerView);
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
    }];
   
}
- (void)setSubView{
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
        make.left.right.mas_equalTo(self.view);
        make.width.offset(kWidth);
    }];
    if(!self.model.isInvalidIssue){
        [self setSuggestSubView];
    }
}

-(void)setSuggestSubView{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTextBlackColor text:@"建议"];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goExpertsVC)];
    [suggestion addGestureRecognizer:tap];
    TriangleLeft *triangle = [[TriangleLeft alloc]initWithFrame:CGRectZero];
    [self.subContainerView addSubview:triangle];
    [triangle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ZOOM_SCALE(10));
        make.height.offset(ZOOM_SCALE(18));
        make.right.mas_equalTo(suggestion.mas_left).offset(1);
        make.centerY.mas_equalTo(icon);
    }];
    [self.subContainerView bringSubviewToFront:suggestion];
    self.suggestion = suggestion;
    UILabel *sugLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(17) textColor:PWWhiteColor text:self.model.attrs];
    sugLab.numberOfLines = 0;
    sugLab.textColor = PWWhiteColor;
    [suggestion addSubview:sugLab];
    [sugLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(suggestion).offset(Interval(14));
        make.top.mas_equalTo(suggestion.mas_top).offset(Interval(9));
        make.right.mas_equalTo(suggestion).offset(-13);
        make.bottom.mas_equalTo(suggestion.bottom).offset(-9);
    }];
    if (self.model.attrs.length == 0) {
        title.hidden = YES;
        suggestion.hidden = YES;
        icon.hidden = YES;
        triangle.hidden = YES;
    }
    self.tableView.backgroundColor = PWWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.model.attrs.length == 0) {
        make.top.mas_equalTo(self.subContainerView);
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom);
        }else{
        make.top.mas_equalTo(self.suggestion.mas_bottom).offset(Interval(15));
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
        }
        make.width.offset(kWidth);
        make.height.offset(self.handbookAry.count*45);
    }];
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
    
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
}
#pragma mark ========== UI/INIT ==========
-(UIImageView *)typeIcon{
    if (!_typeIcon) {
        _typeIcon = [[UIImageView alloc]init];
        [self.upContainerView addSubview:_typeIcon];
    }
    return _typeIcon;
}
-(UILabel *)issueNameLab{
    if (!_issueNameLab) {
        _issueNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_issueNameLab];
    }
    return _issueNameLab;
}

-(UIView *)echartContenterView{
    if (!_echartContenterView) {
        _echartContenterView = [[UIView alloc]init];
        [self.upContainerView addSubview:_echartContenterView];
    }
    return _echartContenterView;
}

#pragma mark ========== BTNCLICK ==========

- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
}
- (void)goExpertsVC{
    [SVProgressHUD show];
    [userManager judgeIsHaveTeam:^(BOOL isSuccess, NSDictionary *content) {
        [SVProgressHUD dismiss];
            if ([getTeamState isEqualToString:PW_isTeam]) {
                NSDictionary *tags =userManager.teamModel.tags;
                NSDictionary *product = PWSafeDictionaryVal(tags, @"product");
                if (product ==nil) {
                    [self.navigationController pushViewController:[ExpertsMoreVC new] animated:YES];
                    return;
                }
                ExpertsSuggestVC *expert = [[ExpertsSuggestVC alloc]init];
                expert.model = self.model;
                [self.navigationController pushViewController:expert animated:YES];
            }else if([getTeamState isEqualToString:PW_isPersonal]){
             [self.navigationController pushViewController:[ExpertsMoreVC new] animated:YES];
            }
    }];

}

#pragma mark ========== DATA/DEAL ==========
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
       
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            [self loadIssueSourceDetail:content];
            [self dealHandBookViewWith:content];
            [self dealWithEchartView:content];
        }else{
             [SVProgressHUD dismiss];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (void)loadIssueSourceDetail:(NSDictionary *)dict{
    NSString *issueSourceID = [dict stringValueForKey:@"issueSourceId" default:@""];
    NSString *type = [dict stringValueForKey:@"itAssetProvider_cache" default:@""];
    NSString *icon;
    NSString *name = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameWithID:issueSourceID];
    self.issueNameLab.text = name;
    if (self.model.isInvalidIssue) {
        [userManager getissueSourceNameByKey:type name:^(NSString *name1) {
            self.contentLab.text = [NSString stringWithFormat:@"您的 %@情报源 %@ 最近一次检测失效，请检查该情报源是否存在问题。",name1,name];
        }];
    }
    if ([type isEqualToString:@"carrier.corsairmaster"]){
        icon = @"icon_foresight_small";
        self.typeIcon.image = [UIImage imageNamed:icon];
        if([name isEqualToString:@""] || name == nil){
            [self loadIssueSuperSourceDetail:issueSourceID issueProvider:type];
        }else{
            [SVProgressHUD dismiss];
        }
        return;
    }
    if ([type isEqualToString:@"aliyun"]) {
        icon = @"icon_alis";
    }else if([type isEqualToString:@"qcloud"]){
        icon = @"icon_tencent_small";
    }else if([type isEqualToString:@"aws"]){
        icon = @"icon_aws_small";
    }else if([type isEqualToString:@"ucloud"]){
        icon = @"icon_tencent_small";
    }else if ([type isEqualToString:@"domain"]){
        icon = @"icon_mainframe_small";
    }else if([type isEqualToString:@"carrier.corsair"]){
        icon =@"icon_domainname_small";
    }else if([type isEqualToString:@"carrier.alert"]){
        self.issueNameLab.text = @"消息坞";
        icon = @"message_docks";
    }
    self.typeIcon.image = [UIImage imageNamed:icon];
    [SVProgressHUD dismiss];
}
- (void)dealWithEchartView:(NSDictionary *)dict{
    if ([dict[@"extraJSON"] isKindOfClass:NSDictionary.class]) {
        NSArray *displayItems = dict[@"extraJSON"][@"displayItems"];
        UIView *temp1 = nil;
        for (NSInteger j=0; j<displayItems.count ;j++) {
            if ([displayItems[j] isKindOfClass:NSDictionary.class]){
                NSDictionary *dict = displayItems[j];
                UIView *chartView = [self createChartViewWithDict:dict];
                 [self.view setNeedsUpdateConstraints];
                [chartView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(self.echartContenterView);
                    if (temp1 == nil) {
                        make.top.mas_equalTo(self.echartContenterView);
                    }else{
                        make.top.mas_equalTo(temp1.mas_bottom).offset(Interval(15));
                    }
                    if ([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"lineGraph"]){
                        make.height.offset(300);
                    }
                    if (j==displayItems.count-1) {
                        make.bottom.mas_equalTo(self.echartContenterView).offset(-Interval(12));
                    }
                }];
                temp1 = chartView;
            }
            [self.view layoutIfNeeded];
            CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
            self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
        }

   }
}
#pragma mark ========== 请求一级情报源详情 获取情报源名称 ==========
- (void)loadIssueSuperSourceDetail:(NSString *)issueSourceId issueProvider:(NSString *)provider{
    NSDictionary *param = @{@"id":issueSourceId};
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueSourceList withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSArray *data = PWSafeArrayVal(content, @"data");
            if (data.count>0) {
                if ([data[0] isKindOfClass:NSDictionary.class]) {
                    NSDictionary *dict = data[0];
                   self.issueNameLab.text = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameWithID:[dict stringValueForKey:@"parentId" default:@""]];
                    if (self.model.isInvalidIssue) {
                        [userManager getissueSourceNameByKey:provider name:^(NSString *name1) {
                            self.contentLab.text = [NSString stringWithFormat:@"您的 %@情报源 %@ 最近一次检测失效，请检查该情报源是否存在问题。",name1,self.issueNameLab.text];
                        }];
                    }
                }
            }
        }else{
        [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
}
- (UIView *)createChartViewWithDict:(NSDictionary *)dict{
    if ([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"table"]) {
        NSDictionary *data = dict[@"data"];
        EchartTableView *tableChart = [[EchartTableView alloc]initWithDict:data];
        [self.echartContenterView addSubview:tableChart];
        return tableChart;
    }else if([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"lineGraph"]){
        EchartView *chart = [[EchartView alloc]initWithDict:dict[@"data"]];
        [self.echartContenterView addSubview:chart];
        return chart;
    }else if([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"list"]){
        EchartListView *listView = [[EchartListView alloc]initWithDict:dict[@"data"]];
        [self.echartContenterView addSubview:listView];
        return listView;
    }else{
        return nil;
    }
}
- (void)dealHandBookViewWith:(NSDictionary *)dict{
    if (dict[@"reference"] &&dict[@"reference"][@"articles"]) {
        self.handbookAry = [NSMutableArray new];
        [self.handbookAry addObjectsFromArray:dict[@"reference"][@"articles"]];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.handbookAry.count*45);
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
        }];
        [self.tableView reloadData];
    }
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
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
