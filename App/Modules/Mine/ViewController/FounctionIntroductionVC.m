//
//  FounctionIntroductionVC.m
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import "FounctionIntroductionVC.h"
#import "FounctionIntroductionModel.h"
#import "FounctionIntroCell.h"
#import "UITableViewCell+ZTCategory.h"
@interface FounctionIntroductionVC ()<UITableViewDelegate,UITableViewDataSource,FounctionIntroCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tab;
@end

@implementation FounctionIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";

    [self requesetData];
    [self.tab registerNib:[FounctionIntroCell cellWithNib] forCellReuseIdentifier:[FounctionIntroCell cellReuseIdentifier]];

}
#pragma mark --UITableViewDataSource--

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FounctionIntroductionModel *model = self.dataArr[indexPath.row];
    FounctionIntroCell *cell = (FounctionIntroCell *)[tableView dequeueReusableCellWithIdentifier:[FounctionIntroCell cellReuseIdentifier]];
    cell.delegate = self;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FounctionIntroductionModel *model = self.dataArr[indexPath.row];
    FounctionIntroCell *cell = (FounctionIntroCell *)[tableView dequeueReusableCellWithIdentifier:[FounctionIntroCell cellReuseIdentifier]];
    CGFloat height = [cell caculateRowHeight:model];
    return height;
}

#pragma mark --FounctionIntroCellDelegate--
- (void)didClickMoreBtn:(FounctionIntroCell *)cell{
    NSIndexPath *indexpath = [self.tab indexPathForCell:cell];
    
    [self.tab reloadRow:indexpath.row inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
}
#pragma mark 请求
- (void)requesetData{
    [SVProgressHUD show];
    NSDictionary *params = @{@"platform":@"IOS",@"n":@"prof.wang"};
    [PWNetworking requsetHasTokenWithUrl:PW_fouctionIntro withRequestType:NetworkGetType refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[ERROR_CODE] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count == 0 || content == nil){
                return ;
            }
            for(NSDictionary *dic in content){
                NSError * error = nil;
                FounctionIntroductionModel *model = [[FounctionIntroductionModel alloc] initWithDictionary:dic error:&error];
                [self.dataArr addObject:model];
                
            }
            [self.tab reloadData];
        }else{
            [iToast alertWithTitleCenter:NSLocalizedString(response[@"errorCode"], @"")];
        }
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark --lazy---
- (NSMutableArray *)dataArr{
    if (!_dataArr){
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}


@end
