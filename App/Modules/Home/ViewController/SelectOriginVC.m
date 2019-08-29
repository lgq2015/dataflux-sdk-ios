//
//  SelectOriginVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/7/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectOriginVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "DefineOriginVC.h"
#import "OriginModel.h"
@interface SelectOriginVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<MineCellModel*> *dataSource;

@end

@implementation SelectOriginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"local.Origin", @"");
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    self.dataSource = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(12, 0, 0, 0); 
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ZOOM_SCALE(44);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    NSArray *array = @[@"ALL",@"",@"crontab",@"user",@"bizSystem",@"alertHub"];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MineCellModel *model = [MineCellModel new];
        model.title = [obj getOriginStr];
        model.describeText = obj;
        [self.dataSource addObject:model];
    }];
    [self.tableView reloadData];
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
    if (!(indexPath.row == self.dataSource.count-1)) {
        cell.arrowImgView.hidden = YES;
    }
    return cell;
    
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   __block OriginModel *model = [OriginModel new];
    model.origin= self.dataSource[indexPath.row].describeText;
    model.name = self.dataSource[indexPath.row].title;
    if (indexPath.row == self.dataSource.count-1) {
        DefineOriginVC *define = [DefineOriginVC new];
   
        WeakSelf
        define.navBtnClick = ^(NSString * _Nonnull origin) {
            model.name = origin;
            if (weakSelf.itemClick) {
              weakSelf.itemClick(model);
            }
        };
        [self.navigationController pushViewController:define animated:YES];
    }else{
        if (self.itemClick) {
            self.itemClick(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)viewDidDisappear:(BOOL)animated{
    if (self.disMissClick) {
        self.disMissClick();
    }
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
