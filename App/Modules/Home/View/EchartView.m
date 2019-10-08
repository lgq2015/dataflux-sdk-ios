//
//  EchartView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import "EchartView.h"
#import "iOS-Echarts.h"
@interface EchartView()
@property (nonatomic, strong) PYEchartsView *kEchartView;
@end
@implementation EchartView
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self) {
        self= [super init];
       
        [self setupEchartWithDict:dict];
    }
    return self;
}
- (void)setupEchartWithDict:(NSDictionary *)data{
   
    NSArray *series = PWSafeArrayVal(data, @"series");
    NSArray *xdata = series[0][@"data"];
    if ([[series firstObject] containsObjectForKey:@"type"]&&[[series[0] stringValueForKey:@"type" default:@""] isEqualToString:@"pie"]) {
        [self createPieWithDict:data];
    }else{
   __block  NSMutableArray *lineX  = [NSMutableArray new];
    NSDictionary *xAxisDict = PWSafeDictionaryVal(data, @"xAxis");
    NSDictionary *yAxisDict = PWSafeDictionaryVal(data, @"yAxis");
    NSString *type = [xAxisDict stringValueForKey:@"type" default:@"category"];
    
        [xdata enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *time = [NSString stringWithFormat:@"%@",obj[0]];
            if([type isEqualToString:@"time"]){
                if([time deptNumInputShouldNumber]){
                [lineX addObject:[time getTimeFromTimestamp]];
                }else{
                   [lineX addObject:[time dealWithTimeFormatted]];
                }
            }else{
                [lineX addObject:time];
            }
        }];
    
    
    /** 图表选项 */
    PYOption *option = [[PYOption alloc] init];
    //是否启用拖拽重计算特性，默认关闭
    option.calculable = NO;
    //数值系列的颜色列表(折线颜色)
    // 图标背景色
    // option.backgroundColor = [[PYColor alloc] initWithColor:[UIColor orangeColor]];
    option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
        title.textEqual(data[@"title"][@"text"])
        .subtextEqual(data[@"yAxis"][@"name"]);
    }]);
    PYTitle *title = [[PYTitle alloc]init];
    title.textEqual(data[@"title"][@"text"]);
    title.subtextEqual(data[@"yAxis"][@"name"]);
    title.textStyle.fontSize = @16;
    title.textStyle.fontStyle = PYTextStyleFontStyleNormal;
    option.title = title;
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
    grid.x = @(40);
    grid.y = @(50);
    // 右下角位置
    grid.x2 = @(30);
    
    
    // 添加到图标选择中
    option.grid = grid;
    
    /** X轴设置 */
    PYAxis *xAxis = [[PYAxis  alloc] init];
    //横轴默认为类目型(就是坐标自己设置)
    xAxis.type = @"category";
    xAxis.name =  [xAxisDict stringValueForKey:@"name" default:@""];
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
    yAxis.type = [yAxisDict stringValueForKey:@"type" default:@"value"];
    // 分割段数，默认为5
    
    // 分割线类型
    // yAxis.splitLine.lineStyle.type = @"dashed";   //'solid' | 'dotted' | 'dashed' 虚线类型
    
    //单位设置,  设置最大值, 最小值
    // yAxis.axisLabel.formatter = @"{value} k";

    // 添加到图标选择中  ( y轴更多设置, 自行查看官方文档)
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    
    /** 定义坐标点数组 */
    NSMutableArray *seriesArr = [NSMutableArray array];
    for (NSInteger i=0; i<series.count; i++) {
        NSDictionary *linedata = series[i];
        NSArray *datas = linedata[@"data"];
        NSMutableArray *lineY = [NSMutableArray new];
        [datas enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[1] isKindOfClass:NSNull.class]) {
                [lineY addObject:@"-"];
            }else{
            [lineY addObject:obj[1]];
            }
        }];
        /** 第一条折线设置 */
        PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
        NSString *name =[linedata stringValueForKey:@"name" default:@""];
        series1.name = name;
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
    [self addSubview:self.kEchartView];
    [self.kEchartView setOption:option];
    [self.kEchartView loadEcharts];
    // 添加到 scrollView 上
 }
}
- (void)createPieWithDict:(NSDictionary *)dict{
    NSArray *series = PWSafeArrayVal(dict, @"series");
    NSArray *xdata = series[0][@"data"];
   __block NSMutableArray *nameArray = [NSMutableArray new];
    __block NSMutableArray *itemArray = [NSMutableArray new];

    [xdata enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:@{@"icon":@"rect",@"name":[obj stringValueForKey:@"name" default:@""]}];
        NSDictionary *itemStyle = @{@"itemStyle":@{@"normal":@{@"color":[self addItemStyleColorWithType:obj[@"id"]]}}};
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict addEntriesFromDictionary:obj];
        [dict addEntriesFromDictionary:itemStyle];
        [itemArray addObject:dict];
    }];
    PYOption *option = [[PYOption alloc] init];
    //拖拽重计算，设置no可以提高加载速度
    option.calculable = NO;
    option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
        title.textEqual(dict[@"title"][@"text"]);
        title.xEqual(PYPositionCenter);
        title.yEqual(PYPositionCenter);
    }]);
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    tooltip.trigger = PYTooltipTriggerItem;
    tooltip.formatter = @"{a} <br/>{b}:{c}({d}%)";
    option.tooltip = tooltip;
    
    PYLegend *legend = [[PYLegend alloc] init];
    //提示栏 布局方式 'horizontal' 横| 'vertical' 竖
    legend.orient = PYOrientVertical;
    //对齐位置
    legend.x = PYPositionRight;
    legend.show = @NO;
    legend.itemHeight = @10;
    legend.itemWidth = @20;
    legend.data =nameArray;
    option.legend = legend;
    
    //toolbox 用于切换数据视图，暂且不写
    NSMutableArray *dataArr = [NSMutableArray array];
    PYPieSeries *series1 = [[PYPieSeries alloc] init];
    series1.name = dict[@"title"][@"text"];
    series1.type = PYSeriesTypePie;
    series1.data = itemArray;
    series1.legendHoverLink = NO;
    series1.radius = @[@"60%",@"80%"];
    //圆心坐标
    //    series1.center = @[@"50%",@"50%"];
    PYItemStyle *itemStyle = [[PYItemStyle alloc] init];
//    itemStyle.normal.color = @[[PYColor colorWithHexString:@"#028BFF"],[PYColor colorWithHexString:@"#FFB23F"],[PYColor colorWithHexString:@"#FF7A6A"]];
    series1.itemStyle = itemStyle;
    //圈外数据 normal
    //    series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
    //圈外数据信息label
    series1.itemStyle.normal.label.show = NO;
    //圈外数据圆柱图连线
    series1.itemStyle.normal.labelLine.show = NO;
    
   
    
    
    
    [dataArr addObject:series1];
    
    [option setSeries:dataArr];
    /* 初始化图标 */
    self.kEchartView = [[PYEchartsView alloc] initWithFrame:CGRectMake(0, 0, kWidth  , 300)];
    [self addSubview:self.kEchartView];
    [self.kEchartView setOption:option];
    [self.kEchartView loadEcharts];
}
-(NSString *)addItemStyleColorWithType:(NSString *)str{
    if ([str isEqualToString:@"info"]) {
        return @"#028BFF";
    }else if([str isEqualToString:@"danger"]){
        return @"#FF7A6A";
    }else if([str isEqualToString:@"warning"]){
        return @"#FFB23F";
    }else if ([str isEqualToString:@"alarm"]) {
        return @"#F9BA04";
    }else if([str isEqualToString:@"security"]){
        return @"#60D837";
    }else if([str isEqualToString:@"expense"]){
        return @"#FF2501";
    }else if([str isEqualToString:@"optimization"]){
        return @"#028BFF";
    }else if([str isEqualToString:@"misc"]){
        return @"#4AD1FF";
    }else if([str isEqualToString:@"report"]){
        return @"#8061CB ";
    }else if([str isEqualToString:@"task"]){
        return @"#C24885 ";
    }
    return @"#FF7A6A";
}
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
