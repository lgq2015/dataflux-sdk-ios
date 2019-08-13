//
//  DefineOriginVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "DefineOriginVC.h"
#import "TouchLargeButton.h"
#import "IssueListManger.h"
#import "HistoryCell.h"

@interface DefineOriginVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *originTf;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *historyFooterView;
@property (nonatomic, strong) UIButton *navRightBtn;

@end

@implementation DefineOriginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.Origin", @"");
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
    self.navigationItem.rightBarButtonItem = item;
    self.dataSource = [NSMutableArray new];
    self.view.backgroundColor = PWWhiteColor;
    self.originTf = [[UITextField alloc]initWithFrame:CGRectMake(16, 12, kWidth-32, ZOOM_SCALE(21))];
    self.originTf.font = RegularFONT(15);
    self.originTf.textColor = PWTextBlackColor;
    self.originTf.placeholder = NSLocalizedString(@"local.InputOrigin", @"");
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
    NSArray *ary = [[IssueListManger sharedIssueListManger] getHistoryOriginInput];
    if (ary.count!=0) {
        [self.dataSource addObjectsFromArray:ary];
        self.tableView.tableFooterView = self.historyFooterView;
        [self.tableView reloadData];
    }else{
        self.tableView.hidden = YES;
        self.tableView.tableFooterView = nil;
    }
    [self.tableView registerClass:HistoryCell.class forCellReuseIdentifier:@"HistoryCell"];
    RACSignal * navBtnSignal = [[self.originTf rac_textSignal] map:^id(NSString *value) {
       NSString *new = [value removeFrontBackBlank];
        return @(new.length >0);
    }];
    RAC(self.navRightBtn,enabled) = navBtnSignal;
}
-(UIButton *)navRightBtn{
    if (!_navRightBtn) {
        _navRightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _navRightBtn.frame = CGRectMake(0, 0, 40, 30);
        [_navRightBtn setTitle:NSLocalizedString(@"local.confirm", @"") forState:UIControlStateNormal];
        [_navRightBtn addTarget:self action:@selector(navRightClick) forControlEvents:UIControlEventTouchUpInside];
        _navRightBtn.titleLabel.font = RegularFONT(16);
        [_navRightBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        [_navRightBtn setTitleColor:PWGrayColor forState:UIControlStateDisabled];
        _navRightBtn.enabled = NO;
        [_navRightBtn sizeToFit];
    }
    return _navRightBtn;
}
- (void)navRightClick{
    if (self.originTf.text.length>0) {
        if (self.navBtnClick) {
            self.navBtnClick([self.originTf.text removeFrontBackBlank]);
        }
        [self saveHistoryData:[self.originTf.text removeFrontBackBlank]];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)saveHistoryData:(NSString *)text{
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:text]) {
            [self.dataSource removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.dataSource insertObject:text atIndex:0];
    if (self.dataSource.count>10) {
        [self.dataSource removeObjectAtIndex:10];
    }
    [[IssueListManger sharedIssueListManger] setHistoryOriginInputWithArray:self.dataSource];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(31))];
    UILabel *lab = [PWCommonCtrl lableWithFrame:CGRectMake(16, 0, 200, ZOOM_SCALE(18)) font:RegularFONT(13) textColor:[UIColor colorWithHexString:@"#939396"] text:NSLocalizedString(@"local.HistoricalInput", @"")];
    lab.centerY = header.centerY;
    [header addSubview:lab];
    return header;
}
- (UIView *)historyFooterView{
    if (!_historyFooterView) {
        _historyFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30))];
        _historyFooterView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        TouchLargeButton *button =[[TouchLargeButton alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(5), ZOOM_SCALE(120), ZOOM_SCALE(20))];
        [button setTitle:NSLocalizedString(@"local.ClearHistory", @"") forState:UIControlStateNormal];
        [button setTitleColor:PWTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = RegularFONT(12);
        [button addTarget:self action:@selector(delectAllClick) forControlEvents:UIControlEventTouchUpInside];
        button.centerX = self.view.centerX;
        [_historyFooterView addSubview:button];
    }
    return _historyFooterView;
}
- (void)delectAllClick{
    [[IssueListManger sharedIssueListManger] setHistoryOriginInputWithArray:@[]];
    [self.dataSource removeAllObjects];
    self.tableView.hidden = YES;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
     cell.isNoIcon = YES;
     cell.title = self.dataSource[indexPath.row];
    WeakSelf
     cell.delectClick = ^(){
        [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
         if (weakSelf.dataSource.count==0) {
             weakSelf.tableView.hidden = YES;
         }else{
             [weakSelf.tableView reloadData];
         }
         [[IssueListManger sharedIssueListManger] setHistoryOriginInputWithArray:weakSelf.dataSource];
     };
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self saveHistoryData:self.dataSource[indexPath.row]];
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
