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
#import "InfoDetailVC.h"
#import "IssueListManger.h"
#import "IssueLogModel.h"
#import "CreateQueGuideView.h"

@interface MonitorVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) MonitorCell *tempCell;
@property (nonatomic, strong) NSMutableArray *monitorData;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSString *pageMaker;
@property (nonatomic, strong) UILabel *tipLab;

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
                                             selector:@selector(headerRefreshing:)
                                                 name:KNotificationNewIssue
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(headerRefreshing:)
                                                 name:KNotificationChatNewDatas
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
    self.tableView.tableFooterView = self.footView;
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
    if (![kUserDefaults valueForKey:@"MonitorIsFirst"]) {
        CreateQueGuideView *guid = [[CreateQueGuideView alloc]init];
        [guid showInView:[UIApplication sharedApplication].keyWindow];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"MonitorIsFirst"];
    }
}
- (void)headerRefreshing:(NSNotification *)notification{


    NSDictionary * pass = [notification userInfo];
    if(pass){
        IssueLogModel * model = [[IssueLogModel new] initWithDictionary:pass];
          IssueModel * issueModel=  [[IssueListManger sharedIssueListManger] getIssueDataByData:model.issueId];
          if(issueModel&& [issueModel.type isEqualToString:self.type ]){

              self.tipLab.hidden = NO;
          }

    } else{

        self.tipLab.hidden = NO;
    }
}
- (void)reloadData{
    NSArray *dataSource= [[IssueListManger sharedIssueListManger] getIssueListWithIssueType:self.type];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    if (self.dataSource.count>0) {
        [self.monitorData removeAllObjects];
        [self.dataSource enumerateObjectsUsingBlock:^(IssueModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MonitorListModel *model = [[MonitorListModel alloc]initWithJsonDictionary:obj];
            [self.monitorData addObject:model];
        }];
        [self.tableView reloadData];
        [self removeNoDataImage];
    }else{
        [self showNoDataImage];
    }
    self.tipLab.hidden = YES;
}
- (void)navBtnClick:(UIButton *)btn{
    if([getTeamState isEqualToString:PW_isTeam]){
    CreateQuestionVC *creatVC = [[CreateQuestionVC alloc]init];
    creatVC.type = self.type;
    [self.navigationController pushViewController:creatVC animated:YES];
    }else if([getTeamState isEqualToString:PW_isPersonal]){
        FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
        [self.navigationController pushViewController:createTeam animated:YES];
    }else{
        [userManager judgeIsHaveTeam:^(BOOL isHave, NSDictionary *content) {
            if (isHave) {
                CreateQuestionVC *creatVC = [[CreateQuestionVC alloc]init];
                creatVC.type = self.type;
                [self.navigationController pushViewController:creatVC animated:YES];
            }else{
                FillinTeamInforVC *createTeam = [[FillinTeamInforVC alloc]init];
                [self.navigationController pushViewController:createTeam animated:YES];
            }
        }];
    }
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        NSString *string =@"您有新情报，点击刷新";
        _tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(30)) font:MediumFONT(14) textColor:PWBlueColor text:string];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.backgroundColor = [UIColor colorWithHexString:@"#D3E4F5"];
        [self.view addSubview:_tipLab];
        _tipLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadData)];
        [_tipLab addGestureRecognizer:tap];
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:@"点击刷新"];
    NSRange pointRange = NSMakeRange(0, range.location);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = PWTextColor;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    _tipLab.attributedText = attribut;
    }
    return _tipLab;
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
    MonitorListModel *model =self.monitorData[indexPath.row];
    model.isRead = YES;
    if (model.isFromUser) {
        ProblemDetailsVC *detailVC = [[ProblemDetailsVC alloc]init];
        detailVC.model = self.monitorData[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        InfoDetailVC *infodetial = [[InfoDetailVC alloc]init];
        infodetial.model = model;
        [self.navigationController pushViewController:infodetial animated:YES];
    }
    [[IssueListManger sharedIssueListManger] readIssue:model.issueId];
    [self.tableView reloadData];

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
