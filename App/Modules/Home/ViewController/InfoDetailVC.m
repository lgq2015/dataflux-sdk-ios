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
#import "IssueSourceManger.h"
#import "iOS-Echarts.h"
#import "EchartTableView.h"
#import "ExpertsSuggestVC.h"
#import "TriangleLeft.h"

@interface InfoDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *typeIcon;
@property (nonatomic, strong) UILabel *issueNameLab;

@property (nonatomic, strong) UIView *suggestion;
@property (nonatomic, strong) NSMutableArray *handbookAry;
@property (nonatomic, strong) UIView *echartContenterView;
@property (nonatomic, strong) PYZoomEchartsView *kEchartView;

@property (nonatomic, strong) NSDictionary *infoDetailDict;

@end

@implementation InfoDetailVC

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
        make.top.mas_equalTo(self.typeIcon.mas_bottom);
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    NSString * htmlString = self.model.content;
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
   
    self.contentLab.attributedText = attrStr;
    self.contentLab.font = MediumFONT(14);
    self.contentLab.textColor = PWSubTitleColor;
    
    [self.echartContenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
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

-(UIView *)echartContenterView{
    if (!_echartContenterView) {
        _echartContenterView = [[UIView alloc]init];
        [self.upContainerView addSubview:_echartContenterView];
    }
    return _echartContenterView;
}

#pragma mark ========== BTNCLICK ==========
- (void)navRightBtnClick{
    PWChatVC *chat = [[PWChatVC alloc]init];
    [self.navigationController pushViewController:chat animated:YES];

}
- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
}
- (void)goExpertsVC{
     ExpertsSuggestVC *experts = [[ExpertsSuggestVC alloc]init];
    if ([self.infoDetailDict[@"tags"] isKindOfClass:NSDictionary.class]) {
        NSDictionary *tags = self.infoDetailDict[@"tags"];
        NSArray *expertGroups = tags[@"expertGroups"];
        if (expertGroups.count>0) {
            experts.expertGroups = [NSMutableArray arrayWithArray:expertGroups];
        }
    }
    [self.navigationController pushViewController:experts animated:YES];
}
#pragma mark ========== DATA/DEAL ==========
- (void)loadInfoDeatil{
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_issueDetail(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSDictionary *content = response[@"content"];
            self.infoDetailDict = content;
            [self loadIssueSourceDetail:content];
            [self dealHandBookViewWith:content];
            [self dealWithEchartView:content];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];

    }];
}
- (void)loadIssueSourceDetail:(NSDictionary *)dict{
    NSString *issueSourceID = [dict stringValueForKey:@"issueSourceId" default:@""];
    NSString *type = [dict stringValueForKey:@"itAssetProvider_cache" default:@""];
    NSString *icon;
    if ([type isEqualToString:@"aliyun"]) {
        icon = @"icon_ali";
    }else if([type isEqualToString:@"qcloud"]){
        icon = @"icon_tencent";
    }else if([type isEqualToString:@"aws"]){
        icon = @"icon_aws";
    }else if([type isEqualToString:@"ucloud"]){
        icon = @"Ucloud";
    }else if ([type isEqualToString:@"domain"]){
        icon = @"icon_domainname";
    }else if ([type isEqualToString:@"carrier.corsairmaster"]){
        icon = @"icon_cluster";
    }else if([type isEqualToString:@"carrier.corsair"]){
        icon =@"icon_single";
    }
    self.typeIcon.image = [UIImage imageNamed:icon];
    NSString *name = [[IssueSourceManger sharedIssueSourceManger] getIssueSourceNameWithID:issueSourceID];
    self.issueNameLab.text = name;
    
}
- (void)dealWithEchartView:(NSDictionary *)dict{
    if ([dict[@"extraJSON"] isKindOfClass:NSDictionary.class]) {
        NSArray *displayItems = dict[@"extraJSON"][@"displayItems"];
        for (NSDictionary *dict in displayItems) {
            if ([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"table"]) {
                NSDictionary *data = dict[@"data"];
                UILabel *titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTextBlackColor text:data[@"title"]];
                [self.view setNeedsUpdateConstraints];
                [self.echartContenterView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
                    make.left.right.mas_equalTo(self.upContainerView);
                    make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
                }];
                [self.echartContenterView addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.echartContenterView).offset(Interval(16));
                    make.top.mas_equalTo(self.echartContenterView);
                    make.right.mas_equalTo(self.echartContenterView).offset(-Interval(16));
                }];
               
                NSArray *header = data[@"header"];
                NSArray *body = data[@"body"];
                UIView *temp = titleLab;
                for (NSInteger i=0; i<body.count; i++) {
                    UIView *table = [self createTableWithData:body[i] header:header];
                    [table mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(temp.mas_bottom).offset(Interval(12));
                            make.left.mas_equalTo(self.echartContenterView).offset(Interval(16));
                            make.right.mas_equalTo(self.echartContenterView).offset(-Interval(16));
                        if (i==body.count-1) {
                            make.bottom.mas_equalTo(self.echartContenterView).offset(-Interval(12));
                        }
                    }];

                    temp = table;
                }
                
              [self.view layoutIfNeeded];
                CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
                self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
            }else {
                //if([[dict stringValueForKey:@"type" default:@""] isEqualToString:@"lineGraph"])
                [self createEChartLineType:dict[@"data"]];
            }
        }
   }
}
-(UIView *)createTableWithData:(NSArray *)date header:(nonnull NSArray *)header{
    UIView *view = [[UIView alloc]init];
    view.layer.shadowOffset = CGSizeMake(0,2);
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 8;
    view.layer.shadowOpacity = 0.06;
    view.layer.cornerRadius = 6;
    view.backgroundColor = PWWhiteColor;
    [self.echartContenterView addSubview:view];
    UIView *temp = nil;
    for (NSInteger i=0;i<date.count;i++) {
        NSString *string = [NSString stringWithFormat:@"%@：%@",header[i],date[i]];

        UILabel *title = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTextColor text:string];
        title.numberOfLines = 0;
        [view addSubview:title];
        
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
        //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
        NSRange range = [string rangeOfString:[NSString stringWithFormat:@"%@：",header[i]]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSForegroundColorAttributeName] = PWTextLight;
        //赋值
        [attribut addAttributes:dic range:range];
        title.attributedText = attribut;
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp == nil) {
                make.top.mas_equalTo(view).offset(Interval(16));
            }else{
                make.top.mas_equalTo(temp.mas_bottom).offset(Interval(9));
            }
            make.left.mas_equalTo(view).offset(Interval(14));
            make.right.mas_equalTo(view).offset(-Interval(14));
            if(i == date.count-1){
                make.bottom.mas_equalTo(view).offset(-Interval(16));
            }
        }];
        temp = title;
    }
    return view;
}
- (void)createEChartLineType:(NSDictionary *)data{
    NSArray *series = data[@"series"];
    NSMutableArray *lineX  = [NSMutableArray new];
    NSString *type = data[@"xAxis"][@"type"];
    if ([type isEqualToString:@"time"]) {
        NSArray *data = series[0][@"data"];
        [data enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *time = [NSString stringWithFormat:@"%@",obj[0]];
            [lineX addObject: [time getTimeFromTimestamp]];
        }];
    }

    /** 图表选项 */
    PYOption *option = [[PYOption alloc] init];
    //是否启用拖拽重计算特性，默认关闭
    option.calculable = NO;
    //数值系列的颜色列表(折线颜色)
    option.color = @[@"#20BCFC", @"#ff6347"];
    // 图标背景色
    // option.backgroundColor = [[PYColor alloc] initWithColor:[UIColor orangeColor]];
    option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
        title.textEqual(data[@"title"][@"text"])
        .subtextEqual(data[@"yAxis"][@"name"]);
    }]);
//    option.title.subtext = @"数值";
    
    /** 提示框 */
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    // 触发类型 默认数据触发
    tooltip.trigger = @"axis";
    // 竖线宽度
    tooltip.axisPointer.lineStyle.width = @1;
    // 提示框 文字样式设置
    tooltip.textStyle = [[PYTextStyle alloc] init];
    tooltip.textStyle.fontSize = @12;
    // 提示框 显示自定义
    // tooltip.formatter = @"(function(params){ var res = params[0].name; for (var i = 0, l = params.length; i < l; i++) {res += '<br/>' + params[i].seriesName + ' : ' + params[i].value;}; return res})";
    // 添加到图标选择中
    option.tooltip = tooltip;
//    NSArray *legendAry = data[@"legend"][@"data"];
//    option.legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
//        legend.dataEqual(legendAry);
//    }]);


    /** 直角坐标系内绘图网格, 说明见下图 */
    PYGrid *grid = [[PYGrid alloc] init];
    // 左上角位置
    grid.x = @(30);
    grid.y = @(50);
    // 右下角位置
    grid.x2 = @(30);
   

    // 添加到图标选择中
    option.grid = grid;
    
    /** X轴设置 */
    PYAxis *xAxis = [[PYAxis  alloc] init];
    //横轴默认为类目型(就是坐标自己设置)
    xAxis.type = @"category";
    // 起始和结束两端空白
    xAxis.boundaryGap = @(NO);
    // 分隔线
    xAxis.splitLine.show = YES;
    // 坐标轴线
    xAxis.axisLine.show = YES;
    // X轴坐标数据
    xAxis.data = lineX;
    // 坐标轴小标记
    xAxis.axisTick = [[PYAxisTick alloc] init];
    xAxis.axisTick.show = YES;
    
    // 添加到图标选择中
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    
    
    /** Y轴设置 */
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.axisLine.show = YES;
    // 纵轴默认为数值型(就是坐标系统生成), 改为 @"category" 会有问题, 读者可以自行尝试
    yAxis.type = @"value";
    // 分割段数，默认为5
    
    // 分割线类型
    // yAxis.splitLine.lineStyle.type = @"dashed";   //'solid' | 'dotted' | 'dashed' 虚线类型
    
    //单位设置,  设置最大值, 最小值
    // yAxis.axisLabel.formatter = @"{value} k";
    NSNumber *max = [data[@"yAxis"] numberValueForKey:@"max" default:@100];
    NSNumber *min = [data[@"yAxis"] numberValueForKey:@"min" default:@0];
    yAxis.max = max;
    yAxis.min =min;
     NSNumber *interval =[data[@"yAxis"] numberValueForKey:@"interval" default:@10];
     NSInteger interval2 =([max integerValue]-[min integerValue])/[interval integerValue] ;
    yAxis.splitNumber =[NSNumber numberWithInteger:interval2];
    //[NSNumber numberWithLong:interval];
    
    // 添加到图标选择中  ( y轴更多设置, 自行查看官方文档)
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    
    
    /** 定义坐标点数组 */
    NSMutableArray *seriesArr = [NSMutableArray array];
    for (NSInteger i=0; i<series.count; i++) {
        NSDictionary *linedata = series[i];
        NSArray *datas = linedata[@"data"];
        NSMutableArray *lineY = [NSMutableArray new];
        [datas enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [lineY addObject:obj[1]];
        }];
        /** 第一条折线设置 */
        PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
        series1.name = linedata[@"name"];
        // 类型为折线
        series1.type = linedata[@"type"];
        // 曲线平滑
        // series1.smooth = YES;
        // 坐标点大小
        series1.symbolSize = @(1.5);
        // 坐标点样式, 设置连线的宽度
        series1.itemStyle = [[PYItemStyle alloc] init];
        series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
        series1.itemStyle.normal.lineStyle = [[PYLineStyle alloc] init];
        series1.itemStyle.normal.lineStyle.width = @(1.5);
        // 添加坐标点 y 轴数据 ( 如果某一点 无数据, 可以传 @"-" 断开连线 如 : @[@"7566", @"-", @"7571"]  )
        series1.data = lineY;
        
        [seriesArr addObject:series1];
    }
    
    [option setSeries:seriesArr];
    
    /** 初始化图表 */
    self.kEchartView = [[PYZoomEchartsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    // 添加到 scrollView 上
    [self.echartContenterView addSubview:self.kEchartView];
    
    // 图表选项添加到图表上
    [self.kEchartView setOption:option];
     [self.kEchartView loadEcharts];
    [self.view setNeedsUpdateConstraints];
    [self.echartContenterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(300);
    }];
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
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
