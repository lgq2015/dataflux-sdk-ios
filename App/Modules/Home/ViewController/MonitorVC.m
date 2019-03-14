//
//  MonitorVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "MonitorVC.h"
#import "MonitorCell.h"
#import "MonitorListModel.h"
#import "CreateQuestionVC.h"
#import "ProblemDetailsVC.h"
#import "IssueModel.h"
#import "FillinTeamInforVC.h"

@interface MonitorVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MonitorCell *tempCell;
@property (nonatomic, strong) NSMutableArray *monitorData;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSString *pageMaker;
@end

@implementation MonitorVC
- (id)initWithTitle:(NSString *)title andIssueType:(NSString *)type{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRereshing)
                                                 name:KNotificationIssueSourceChange
                                               object:nil];
    [self createUI];
    
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
   
    [self addNavigationItemWithTitles:@[@"创建问题"] isLeft:NO target:self action:@selector(navBtnClick:) tags:@[@10]];
    self.monitorData = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MonitorCell class] forCellReuseIdentifier:@"MonitorCell"];
    self.tempCell = [[MonitorCell alloc] initWithStyle:0 reuseIdentifier:@"MonitorCell"];
   
    if (self.dataSource.count>0) {
        [self.dataSource enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MonitorListModel *model = [[MonitorListModel alloc]initWithJsonDictionary:obj];
            [self.monitorData addObject:model];
        }];
        [self.tableView reloadData];
    }else{
        [self showNoDataImage];
    }
}

- (void)navBtnClick:(UIButton *)btn{
    if([getTeamState isEqualToString:PW_isTeam]){
    CreateQuestionVC *creatVC = [[CreateQuestionVC alloc]init];
    creatVC.type = self.type;
    [self.navigationController pushViewController:creatVC animated:YES];
    }else{
        FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
        createTeam.type = FillinTeamTypeAdd;
        [self.navigationController pushViewController:createTeam animated:YES];
    }
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.monitorData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
    cell.model = self.monitorData[indexPath.row];
    cell.backgroundColor = PWWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProblemDetailsVC *detailVC = [[ProblemDetailsVC alloc]init];
    MonitorListModel *model =self.monitorData[indexPath.row];
    model.isRead = YES;
    detailVC.model = self.monitorData[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    PWFMDB *fmdb = [PWFMDB shareDatabase];
    NSString *whereFormat = [NSString stringWithFormat:@"where PWId = %@",model.PWId];
    NSArray<IssueModel*> *itemDatas = [fmdb pw_lookupTable:getPWUserID dicOrModel:[IssueModel class] whereFormat:whereFormat];
    if(itemDatas.count>0){
        itemDatas[0].isRead = YES;
        [fmdb pw_updateTable:getPWUserID dicOrModel:itemDatas[0] whereFormat:whereFormat];
        [self.tableView reloadData];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorListModel *model =self.monitorData[indexPath.row];
    if (model.cellHeight == 0 || !model.cellHeight) {
        CGFloat cellHeight = [self.tempCell heightForModel:self.monitorData[indexPath.row]];
        // 缓存给model
        model.cellHeight = cellHeight;

        return cellHeight;
    } else {
        return model.cellHeight;
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
