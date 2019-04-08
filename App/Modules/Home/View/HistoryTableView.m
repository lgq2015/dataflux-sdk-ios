//
//  HistoryTableView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HistoryTableView.h"
#import "HistoryCell.h"
@interface HistoryTableView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *historyFooterView;
@end
@implementation HistoryTableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpUI];
}
- (void)setUpUI{
    self.tableview.frame = CGRectMake(0, Interval(5), kWidth, kHeight-kTopHeight-Interval(5));
    [self addSubview:self.tableview];
    self.dataSource = [NSMutableArray new];
     NSArray *ary = getPWhistorySearch;
    if (ary.count!=0) {
        self.tableview.tableFooterView = self.historyFooterView;
    }else{
        self.tableview.tableFooterView = nil;
    }
    [self.dataSource addObjectsFromArray:ary];
    [self.tableview reloadData];
}
-(void)reloadHistoryList{
    [self.dataSource removeAllObjects];
    NSArray *ary = getPWhistorySearch;
    if (ary.count!=0) {
        self.tableview.tableFooterView = self.historyFooterView;
    }else{
        self.tableview.tableFooterView = nil;
    }
    [self.dataSource addObjectsFromArray:ary];
    [self.tableview reloadData];
}
- (UIView *)historyFooterView{
    if (!_historyFooterView) {
        _historyFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30))];
        _historyFooterView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UIButton *button = [PWCommonCtrl buttonWithFrame:CGRectMake(0, ZOOM_SCALE(5), ZOOM_SCALE(120), ZOOM_SCALE(20)) type:PWButtonTypeWord text:@"清空搜索历史"];
        [button setTitleColor:PWTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = RegularFONT(14);
        [button addTarget:self action:@selector(delectAllClick) forControlEvents:UIControlEventTouchUpInside];
        button.centerX = self.centerX;
        [_historyFooterView addSubview:button];
    }
    return _historyFooterView;
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableview.rowHeight = ZOOM_SCALE(40);
        _tableview.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.scrollsToTop = YES;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[HistoryCell class] forCellReuseIdentifier:@"HistoryCell"];
    }
    return _tableview;
}
- (void)delectAllClick{
   
    [kUserDefaults removeObjectForKey:PW_historySearch];
    [self reloadHistoryList];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    cell.title = self.dataSource[indexPath.row];
    cell.delectClick = ^(){
        [self.dataSource removeObjectAtIndex:indexPath.row];
        setPWhistorySearch(self.dataSource);
        [self reloadHistoryList];
    };
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchItem) {
        self.searchItem(self.dataSource[indexPath.row]);
    }
    
}

@end
