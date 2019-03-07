//
//  HandbookIndexVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "HandbookIndexVC.h"
#import "PWDraggableModel.h"
#import "UITableView+SCIndexView.h"
#import "HandbookModel.h"
@interface HandbookIndexVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HandbookIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    [self createUI];
    [self loadData];
}
- (void)createUI{
    self.tableView.frame = CGRectMake(0, Interval(60), kWidth, kHeight-kTopHeight-Interval(60));
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = YES;
}
- (void)loadData{
    self.dataSource = [NSMutableArray new];
    [SVProgressHUD show];
    [PWNetworking requsetHasTokenWithUrl:PW_handbook(self.model.handbookId) withRequestType:NetworkGetType refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        [SVProgressHUD dismiss];
        if ([response[@"errCode"] isEqualToString:@""]) {
            NSArray *content = response[@"content"];
            if (content.count>0) {
                [self dealWithData:content];

            }else{
                [self showNoDataImage];
            }
        }
        
    } failBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}
- (void)dealWithData:(NSArray *)data{
    NSMutableArray *index = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        HandbookModel *model = [[HandbookModel alloc]initWithDictionary:dict error:&error];
        
    }];
    
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    SectionItem *sectionItem = self.tableViewDataSource[indexPath.section];
//    cell.textLabel.text = sectionItem.items[indexPath.row];;
    return cell;
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
