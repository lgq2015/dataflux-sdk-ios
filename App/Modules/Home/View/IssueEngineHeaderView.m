//
//  IssueEngineHeaderView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/15.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueEngineHeaderView.h"
#import "IssueListViewModel.h"
#import "MineViewCell.h"
#import "EchartTableView.h"
#import "EchartView.h"
#import "EchartListView.h"
#import "MineCellModel.h"
#import "HandbookModel.h"
#import "NewsWebView.h"
#import "NSString+Regex.h"
#import "AssignView.h"
#import "TouchLargeButton.h"

@interface IssueEngineHeaderView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) YYLabel *contentLab;
@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) UIImageView *typeIcon;
@property (nonatomic, strong) UILabel *issueNameLab;
@property (nonatomic, strong) UIView *echartContenterView;
@property (nonatomic, strong) NSMutableArray *handbookAry;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIImageView *repairIcon;
@property (nonatomic, strong) TouchLargeButton *repairBtn;
@property (nonatomic, strong) AssignView *assignView;
@end
@implementation IssueEngineHeaderView
-(instancetype)initHeaderWithIssueModel:(IssueListViewModel *)model{
    if (self = [super init]) {
        self.model = model;
        [self createHeaderUI];
    }
    return self;
}
- (void)createHeaderUI{
    self.titleLab.preferredMaxLayoutWidth = kWidth-Interval(32);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.upContainerView).offset(Interval(14));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    [self.upContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(Interval(12));
        make.right.left.mas_equalTo(self);
    }];
    self.titleLab.text =self.model.title;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(16);
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(10));
    }];
    [self stateLabUI];
    [self.repairBtn sizeToFit];
    CGSize btnSize = self.repairBtn.frame.size;
    [self.repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.upContainerView).offset(-16);
        make.width.offset(btnSize.width);
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.repairIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.repairBtn.mas_left).offset(-4);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
    [self.typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(10);
        make.width.offset(ZOOM_SCALE(39));
        make.height.offset(ZOOM_SCALE(27));
    }];
    self.typeIcon.image = [UIImage imageNamed:self.model.icon];
    [self.issueNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(11));
        make.centerY.mas_equalTo(self.typeIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(Interval(10));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.timeLab.text =[self.model.time accurateTimeStr];
    self.issueNameLab.text = self.model.sourceName;
    if (_model.recovered && !_model.statusChangeAccountInfo) {
        [self.issueNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(11));
            make.centerY.mas_equalTo(self.typeIcon);
            make.height.offset(ZOOM_SCALE(18));
            make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-17);
        }];
    }else{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.upContainerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(self.upContainerView);
        make.top.mas_equalTo(self.issueNameLab.mas_bottom).offset(Interval(17));
        make.height.offset(1);
        make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(ZOOM_SCALE(-54));
    }];
    [self.assignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(self.upContainerView);
        make.height.offset(ZOOM_SCALE(54));
        make.bottom.mas_equalTo(self.upContainerView);
    }];
    }
    UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"详细信息"];
    [self.subContainerView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.subContainerView).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(22));
    }];
    self.contentLab.preferredMaxLayoutWidth = kWidth-Interval(32);
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subContainerView).offset(Interval(16));
        make.top.mas_equalTo(lab.mas_bottom).offset(Interval(16));
        make.right.mas_equalTo(self.subContainerView).offset(-Interval(16));
    }];
    NSString * htmlString = self.model.content;
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    self.contentLab.attributedText = attrStr;
    self.contentLab.font = RegularFONT(16);
    self.contentLab.textColor = PWTitleColor;
    
    [self.echartContenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
        make.left.mas_equalTo(self.subContainerView);
        make.right.mas_equalTo(self.subContainerView);
        if(self.model.attrs== nil || self.model.attrs.length== 0){
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(20));
        }
    }];
    if(self.model.attrs.length>0){
        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTextBlackColor text:@"建议"];
        [self.subContainerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.echartContenterView.mas_bottom).offset(Interval(20));
            make.left.mas_equalTo(self.subContainerView).offset(Interval(16));
            make.height.offset(ZOOM_SCALE(22));
        }];
        UILabel *sugLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(17) textColor:PWWhiteColor text:self.model.attrs];
        sugLab.numberOfLines = 0;
        sugLab.textColor = PWTitleColor;
        [self.subContainerView addSubview:sugLab];
        sugLab.preferredMaxLayoutWidth = kWidth-Interval(32);
        [sugLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(title);
            make.top.mas_equalTo(title.mas_bottom).offset(Interval(15));
            make.right.mas_equalTo(self).offset(-16);
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-20);
        }];
        sugLab.text = self.model.attrs;
    }
    
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
        make.width.right.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
     [self zhengze];
}
-(void)setContentLabText:(NSString *)text{
    self.contentLab.text = text;
    [self layoutIfNeeded];
}
- (void)stateLabUI{
    switch (self.model.state) {
        case IssueStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case IssueStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case IssueStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"提示";
            break;
        case IssueStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已恢复";
            break;
        case IssueStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
}
-(void)createUIWithDetailDict:(NSDictionary *)dict{
    [self dealWithEchartView:dict];
    [self dealHandBookViewWith:dict];
    [self layoutSubviews];
}
-(void)setIssueNameLabText:(NSString *)text{
    self.issueNameLab.text = text;
    [self layoutIfNeeded];
}
- (void)dealHandBookViewWith:(NSDictionary *)dict{
    if (dict[@"reference"] &&dict[@"reference"][@"articles"]) {
        self.handbookAry = [NSMutableArray new];
        [self.handbookAry addObjectsFromArray:dict[@"reference"][@"articles"]];
        if (self.handbookAry.count>0) {
            [self setSuggestSubView];
        }
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self.handbookAry.count*45);
            make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-20);
        }];
        [self.mTableView reloadData];
    }
    [self layoutIfNeeded];
}
- (void)dealWithEchartView:(NSDictionary *)dict{
    if ([dict[@"extraJSON"] isKindOfClass:NSDictionary.class]) {
        NSArray *displayItems = dict[@"extraJSON"][@"displayItems"];
        UIView *temp1 = nil;
        for (NSInteger j=0; j<displayItems.count ;j++) {
            if ([displayItems[j] isKindOfClass:NSDictionary.class]){
                NSDictionary *dict = displayItems[j];
                UIView *chartView = [self createChartViewWithDict:dict];
                [self setNeedsUpdateConstraints];
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
            [self layoutIfNeeded];
        }
    }
}
-(void)setSuggestSubView{
    [self.subContainerView addSubview:self.mTableView];
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(16), 200, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTextBlackColor text:@"相关文章"];
    [self.subContainerView addSubview:tipLab];
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.subContainerView addSubview:self.mTableView];
    self.mTableView.backgroundColor = PWWhiteColor;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mTableView.showsVerticalScrollIndicator = NO;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(12));
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-20);
        make.width.offset(kWidth);
        make.height.offset(self.handbookAry.count*45);
    }];
    
    
    [self layoutIfNeeded];
}

- (UIView *)createChartViewWithDict:(NSDictionary *)dict{
    if ([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"table"]) {
        NSDictionary *data = dict[@"data"];
        EchartTableView *tableChart = [[EchartTableView alloc]initWithDict:data];
        [self.echartContenterView addSubview:tableChart];
        return tableChart;
    }else if([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"list"]){
        EchartListView *listView = [[EchartListView alloc]initWithDict:dict[@"data"]];
        [self.echartContenterView addSubview:listView];
        return listView;
    }else{
        EchartView *chart = [[EchartView alloc]initWithDict:dict[@"data"]];
        [self.echartContenterView addSubview:chart];
        return chart;
    }
}
#pragma mark ========== 替换 ==========
- (void)zhengze{
    NSString *regexStr=
    @"!?\\[((?:\\[[^\\[\\]]*\\]|\\\\[\\[\\]]?|`[^`]*`|[^\\[\\]\\\\])*?)\\]\\(\\s*(<(?:\\\\[<>]?|[^\\s<>\\\\])*>|(?:\\\\[()]?|\\([^\\s\\x00-\\x1f\\\\]*\\)|[^\\s\\x00-\\x1f()\\\\])*?)(?:\\s+(\"(?:\\\\\"?|[^\"\\\\])*\"|'(?:\\\\'?|[^'\\\\])*'|\\((?:\\\\\\)?|[^)\\\\])*\\)))?\\s*\\)";

    //self.model.content;
    NSError *regexError;
    NSRegularExpression *aRegx=[NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSArray *results=[aRegx matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
   __block NSString *displatext = self.model.content;
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange matchRange = [match range];
        NSRange first = [match rangeAtIndex:1];
        NSRange second = [match rangeAtIndex:2];
        DLog(@"1:first == %@ 2: second ==%@.", [NSValue valueWithRange:first], [NSValue valueWithRange:second]);
        NSString *http = [displatext substringWithRange:second];
        NSString *nametext =  [displatext substringWithRange:first];
        NSString *repleaceText = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",http,nametext];
        displatext= [displatext stringByReplacingCharactersInRange:matchRange withString:repleaceText];
    }];
    displatext = [displatext stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    self.contentLab.attributedText = [displatext zt_convertLink:RegularFONT(16) textColor:PWTextColor];

}
#pragma mark ========== UI/INIT ==========
-(UIView *)upContainerView{
    if (!_upContainerView) {
        _upContainerView = [[UIView alloc]init];
        _upContainerView.backgroundColor = PWWhiteColor;
        [self addSubview:_upContainerView];
    }
    return _upContainerView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@""];
        _titleLab.numberOfLines = 0;
        [self.upContainerView addSubview:_titleLab];
    }
    return _titleLab;
}
-(AssignView *)assignView{
    if (!_assignView) {
        _assignView = [[AssignView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(54)) IssueModel:self.model];
        WeakSelf
        _assignView.AssignClick = ^(){
            if (weakSelf.recoverClick) {
                weakSelf.recoverClick();
            }
        };
        [self.upContainerView addSubview:_assignView];
    }
    return _assignView;
}
-(YYLabel *)contentLab{
    if (!_contentLab) {
       _contentLab = [PWCommonCtrl zy_lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWTitleColor text:self.model.content];
        _contentLab.backgroundColor = PWWhiteColor;
        _contentLab.numberOfLines = 0;
        WeakSelf
        _contentLab.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect){
            text = [text attributedSubstringFromRange:range];
            NSDictionary *dic = text.attributes;
            YYTextHighlight *user = [dic valueForKey:@"YYTextHighlight"];
            NSString *linkUrl = [user.userInfo valueForKey:@"linkUrl"];
            PWBaseWebVC*webView= [[PWBaseWebVC alloc] initWithTitle:text.string andURLString:linkUrl];
            [weakSelf.viewController.navigationController pushViewController:webView animated:YES];
        };
        [self.subContainerView addSubview:_contentLab];
    }
    return _contentLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        [self.upContainerView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(14);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.upContainerView addSubview:_stateLab];
    }
    return _stateLab;
}

-(UIView *)subContainerView{
    if (!_subContainerView) {
        _subContainerView = [[UIView alloc]init];
        _subContainerView.backgroundColor = PWWhiteColor;
        [self addSubview:_subContainerView];
    }
    return _subContainerView;
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
        _issueNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_issueNameLab];
    }
    return _issueNameLab;
}

-(UIView *)echartContenterView{
    if (!_echartContenterView) {
        _echartContenterView = [[UIView alloc]init];
        [self.subContainerView addSubview:_echartContenterView];
    }
    return _echartContenterView;
}
-(UIImageView *)repairIcon{
    if (!_repairIcon) {
        _repairIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (self.model.recovered) {
            [_repairIcon setImage:[UIImage imageNamed:@"issue_tick"]];
            _repairIcon.userInteractionEnabled = NO;
        }else{
            _repairIcon.userInteractionEnabled = YES;
            [_repairIcon setImage:[UIImage imageNamed:@"icon_repair"]];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoveClick)];
        [_repairIcon addGestureRecognizer:tap];
        [self.upContainerView addSubview:_repairIcon];
    }
    return _repairIcon;
}
-(TouchLargeButton *)repairBtn{
    if (!_repairBtn) {
        _repairBtn = [[TouchLargeButton alloc]initWithFrame:CGRectZero];
        _repairBtn.titleLabel.font = RegularFONT(14);
        [_repairBtn setTitleColor:PWTextBlackColor forState:UIControlStateNormal];
        if (self.model.recovered) {
            [_repairBtn setTitle:@"已恢复" forState:UIControlStateNormal];
            _repairBtn.enabled = NO;
        }else{
            [_repairBtn setTitle:@"修复" forState:UIControlStateNormal];
        }
        [_repairBtn addTarget:self action:@selector(recoveClick) forControlEvents:UIControlEventTouchUpInside];
        [self.upContainerView addSubview:_repairBtn];
    }
    return _repairBtn;
}
- (void)recoveClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手动修复情报后，该情报将不会再出现在您的活跃情报中" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *commit = [PWCommonCtrl actionWithTitle:@"确认修复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
        
        [[PWHttpEngine sharedInstance]recoveIssueWithIssueid:self.model.issueId callBack:^(id response) {
            BaseReturnModel *model = response;
            if (model.isSuccess) {
                KPostNotification(KNotificationReloadIssueList, nil);
                [self recoveUI];
            }else{
                [iToast alertWithTitleCenter:model.errorMsg];
            }
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nullable action) {
        
    }];
    [alert addAction:commit];
    [alert addAction:cancle];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}
- (void)recoveUI{
    [self.assignView repair];
    [_repairBtn setTitle:@"已恢复" forState:UIControlStateNormal];
    _repairBtn.enabled = NO;
    [_repairIcon setImage:[UIImage imageNamed:@"issue_tick"]];
    _repairIcon.userInteractionEnabled = NO;
    [self.repairBtn sizeToFit];
    CGSize btnSize = self.repairBtn.frame.size;
    [self.repairBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.upContainerView).offset(-16);
        make.width.offset(btnSize.width);
        make.height.offset(ZOOM_SCALE(14));
    }];
    [self.repairIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLab);
        make.right.mas_equalTo(self.repairBtn.mas_left).offset(-4);
        make.width.height.offset(ZOOM_SCALE(16));
    }];
    if (self.recoverClick) {
        self.recoverClick();
    }
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
    NSDictionary *param = @{@"id":model.articleId};
    [SVProgressHUD show];
    [PWNetworking requsetWithUrl:PW_handbookdetail withRequestType:NetworkGetType refreshRequest:YES cache:NO params:param progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = PWSafeDictionaryVal(response, @"content");
            NSError *error1;
            HandbookModel *model1 = [[HandbookModel alloc]initWithDictionary:content error:&error1];
            NewsWebView *webview = [[NewsWebView alloc]initWithTitle:model.title andURLString:PW_handbookUrl(model1.articleId)];
            webview.handbookModel = model1;
            [self.viewController.navigationController pushViewController:webview animated:YES];
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[ERROR_CODE], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [error errorToast];
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
