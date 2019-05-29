//
//  ReadUnreadListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/6.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ReadUnreadListVC.h"
#import "MemberInfoModel.h"
#import "TeamMemberCell.h"
#import "MemberInfoVC.h"
@interface ReadUnreadListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ReadUnreadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(void)setAtStatusAry:(NSArray *)atStatusAry{
    _atStatusAry = atStatusAry;
    [self.dataSource addObjectsFromArray:atStatusAry];
    [self.tableView reloadData];
}
- (void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight-48-SafeAreaBottom_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = PWBackgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 67;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:TeamMemberCell.class forCellReuseIdentifier:@"TeamMemberCell"];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model =self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberInfoModel *model =self.dataSource[indexPath.row];
    MemberInfoVC *member = [[MemberInfoVC alloc]init];
    member.isHidenNaviBar = YES;
    //团队成员分三类： 1. 我 2. 其他人 3.虚拟专家
   
        if (model.isSpecialist){
            member.type = PWMemberViewTypeSpecialist;
        }else{
            member.type = PWMemberViewTypeTeamMember;
    }
    member.model = model;
    [self.navigationController pushViewController:member animated:YES];
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
