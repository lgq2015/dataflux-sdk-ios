//
//  InformationVC.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/12.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "InformationVC.h"
#import "PWInfoBoard.h"
#import "HomeNoticeScrollView.h"
#import "PWNewsListCell.h"
#import "MonitorVC.h"
#import "InformationSourceVC.h"
#import "AddSourceVC.h"
@interface InformationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *newsDatas;
@property (nonatomic, strong) NSMutableArray *infoDatas;
@property (nonatomic, strong) PWInfoBoard *infoboard;
@property (nonatomic, strong) HomeNoticeScrollView *notice;
@end

@implementation InformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScrollView.backgroundColor = PWBackgroundColor;
    self.mainScrollView.mj_header = self.header;
    [self createUI];
    [self loadNewData];
}
- (void)createUI{
    self.infoDatas = [NSMutableArray arrayWithArray:@[@{@"type":@"monitor"}]];
    [self.infoboard createUIWithParamsDict:@{@"datas":self.infoDatas}];
    __weak typeof(self) weakSelf = self;
    self.infoboard.historyInfoClick = ^(void){
        InformationSourceVC *infosourceVC = [[InformationSourceVC alloc]init];
        [weakSelf.navigationController pushViewController:infosourceVC animated:YES];
    };
    self.infoboard.itemClick = ^(NSInteger index){
        switch (index) {
            case 0:{
                MonitorVC *monitor = [[MonitorVC alloc]init];
                [weakSelf.navigationController pushViewController:monitor animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    self.infoboard.connectClick = ^(){
        AddSourceVC *addVC = [[AddSourceVC alloc]init];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    };
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoboard.mas_bottom).offset(Interval(10));
        make.width.offset(kWidth);
        make.height.offset(ZOOM_SCALE(60));
    }];
    [self.mainScrollView addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, ZOOM_SCALE(464), kWidth, self.newsDatas.count*60);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(128);
    [self.tableView registerClass:[PWNewsListCell class] forCellReuseIdentifier:@"PWNewsListCell"];
    [self.mainScrollView addSubview:self.tableView];
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 800);
}
-(PWInfoBoard *)infoboard{
    if (!_infoboard) {
        _infoboard = [[PWInfoBoard alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(600)) style:PWInfoBoardStyleNotConnected]; // type从用户信息里提前获取
        [self.mainScrollView addSubview:_infoboard];
    }
    return _infoboard;
}
-(HomeNoticeScrollView *)notice{
    if (!_notice) {
       _notice = [[HomeNoticeScrollView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(400), kWidth, ZOOM_SCALE(60))];
       _notice.backgroundColor = PWWhiteColor;
       [self.mainScrollView addSubview:_notice];
    }
    return _notice;
}
- (void)headerRereshing{
    [self.mainScrollView.mj_header endRefreshing];
}
- (void)loadNewData{
    
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PWNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PWNewsListCell"];
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
