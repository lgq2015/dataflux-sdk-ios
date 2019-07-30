//
//  DefineOriginVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "DefineOriginVC.h"
#import "TouchLargeButton.h"

@interface DefineOriginVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *originTf;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *historyFooterView;

@end

@implementation DefineOriginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"来源";
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[@"确定"] isLeft:NO target:self action:@selector(navRightClick) tags:@[@13]];
    self.view.backgroundColor = PWWhiteColor;
    self.originTf = [[UITextField alloc]initWithFrame:CGRectMake(16, 12, kWidth-32, ZOOM_SCALE(21))];
    self.originTf.font = RegularFONT(15);
    self.originTf.textColor = PWTextBlackColor;
    self.originTf.placeholder = @"输入来源";
    [self.view addSubview:self.originTf];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.originTf.frame)+11, kWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.view addSubview:line];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(44);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWWhiteColor;
    self.tableView.frame = CGRectMake(0, ZOOM_SCALE(44)+1, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSArray *ary = getPWhistorySearch;
    if (ary.count!=0) {
        self.tableView.tableFooterView = self.historyFooterView;
    }else{
        self.tableView.tableFooterView = nil;
    }
//    [self.tableView registerClass:SelectSourceCell.class forCellReuseIdentifier:@"SelectSourceCell"];
}
- (void)navRightClick{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(31))];
    UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectMake(16, 0, 200, ZOOM_SCALE(18)) font:RegularFONT(13) textColor:[UIColor colorWithHexString:@"#939396"] text:@"历史输入"];
    lab.centerY = header.centerY;
    [header addSubview:lab];
    return header;
}
- (UIView *)historyFooterView{
    if (!_historyFooterView) {
        _historyFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30))];
        _historyFooterView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        TouchLargeButton *button =[[TouchLargeButton alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(5), ZOOM_SCALE(120), ZOOM_SCALE(20))];
        [button setTitle:@"清空历史" forState:UIControlStateNormal];
        [button setTitleColor:PWTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = RegularFONT(12);
        [button addTarget:self action:@selector(delectAllClick) forControlEvents:UIControlEventTouchUpInside];
        button.centerX = self.view.centerX;
        [_historyFooterView addSubview:button];
    }
    return _historyFooterView;
}
- (void)delectAllClick{
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SelectSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSourceCell"];
//    cell.source = self.results[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return nil;
    
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
