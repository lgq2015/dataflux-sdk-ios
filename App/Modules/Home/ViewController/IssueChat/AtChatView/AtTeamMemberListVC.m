//
//  AtTeamMemberListVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AtTeamMemberListVC.h"
#import "TeamInfoModel.h"
#import "MemberInfoModel.h"
#import "ZLChineseToPinyin.h"
#import "UITableView+SCIndexView.h"
#import "TeamMemberCell.h"
@interface AtTeamMemberListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<MemberInfoModel *> *teamMemberArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic, strong) UILabel *chooseLab;
@property (nonatomic, assign) BOOL isMultiChoice;
// 索引标题数组(排序后的出现过的拼音首字母数组)
@property(nonatomic, strong) NSMutableArray *indexArr;

// 排序好的结果数组
@property(nonatomic, strong) NSMutableArray *resultArr;
@end

@implementation AtTeamMemberListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = userManager.teamModel.name;
    [self createUI];
}
- (void)createUI{
    [self addNavigationItemWithTitles:@[NSLocalizedString(@"local.cancel", @"")] isLeft:YES target:self action:@selector(backBtnClicked:) tags:@[@10]];
    [self addNavigationItemWithTitles:@[@"多选"] isLeft:NO target:self action:@selector(chooseMoreClick) tags:@[@11]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 67;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:TeamMemberCell.class forCellReuseIdentifier:@"TeamMemberCell"];
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleCenterToast];
    configuration.indexItemSelectedBackgroundColor = PWClearColor;
    configuration.indexItemSelectedTextColor = PWTextColor;
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_translucentForTableViewInNavigationBar = NO;
    [userManager getTeamMember:^(BOOL isSuccess, NSArray *member) {
        if (isSuccess) {
            [self dealMemberWithDatas:member];
        }else{
            [self showNoDataImage];
        }
        [PWNetworking requsetHasTokenWithUrl:PW_TeamAccount withRequestType:NetworkGetType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[ERROR_CODE] isEqualToString:@""]) {
                NSArray *content = response[@"content"];
                [userManager setTeamMember:content];
                [self dealMemberWithDatas:content];
            }
        } failBlock:^(NSError *error) {
            [error errorToast];
        }];
    }];
}
- (void)backBtnClicked:(UIButton*)button{
    if (self.chooseMembers) {
        self.chooseMembers(@[]);
    }
    [self backBtnClicked];
}
- (void)dealMemberWithDatas:(NSArray *)content{
   
    if (self.teamMemberArray.count>0) {
        [self.teamMemberArray removeAllObjects];
    }
    [self removeNoDataImage];
    //判断是否要添加专家
//    [self addAtSpecialist];
  __block  NSInteger index = self.teamMemberArray.count>0?1:0;
    [content enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        MemberInfoModel *model =[[MemberInfoModel alloc]initWithDictionary:dict error:&error];
        if(![model.memberID isEqualToString:userManager.curUserInfo.userID]){
            if (model.isAdmin) {
                [self.teamMemberArray insertObject:model atIndex:0];
                index+=1;
            }else{
                [self.teamMemberArray addObject:model];
            }
        }
    }];
    
    [self dealGroupDataWithIgnoreIndex:index];

}
- (void)addAtSpecialist{
    TeamInfoModel *model = [userManager getTeamModel];
    NSDictionary *tags = model.tags;
    NSArray *ISPs = PWSafeArrayVal(tags, @"ISPs");
    NSArray *constISPs = [userManager getTeamISPs];
    if (constISPs != nil && constISPs.count != 0) {
        NSMutableArray *ipsDics = [NSMutableArray array];
        //找出当前团队所有的专家对象数组
        [ISPs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [constISPs enumerateObjectsUsingBlock:^(NSDictionary *ispDic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *ispName = ispDic[@"ISP"];
                if ([obj isEqualToString:ispName]){
                    [ipsDics addObject:ispDic];
                    *stop = YES;
                }
            }];
        }];
        [ipsDics enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *displayName = dic[@"displayName"][@"zh_CN"];
            NSString *mobile = dic[@"mobile"];
            NSString *ISP = dic[@"ISP"];
            MemberInfoModel *model =[[MemberInfoModel alloc]init];
            model.mobile = mobile;
            model.name = displayName;
            model.ISP = ISP;
            model.isSpecialist = YES;
            [self.teamMemberArray addObject:model];
        }];
    }
    
}
- (void)dealGroupDataWithIgnoreIndex:(NSInteger)index{
    if (self.teamMemberArray.count == 0) {
        [self showNoDataImage];
        return;
    }
    if (self.teamMemberArray.count == index) {
        [self.dataSource addObject:self.teamMemberArray];
    }else{
        
        NSArray *data = [self.teamMemberArray subarrayWithRange:NSMakeRange(index, self.teamMemberArray.count-index)];
        self.indexArr = [ZLChineseToPinyin indexWithArray:data Key:@"name"];
        self.dataSource = [ZLChineseToPinyin sortObjectArray:data Key:@"name"];
        [self.dataSource insertObject:[self.teamMemberArray subarrayWithRange:NSMakeRange(0, index)]  atIndex:0];
        [self.indexArr insertObject:@"" atIndex:0];
        self.tableView.sc_indexViewDataSource = self.indexArr;
        [self.tableView reloadData];
    }
}
- (void)chooseMoreClick{
    
    self.isMultiChoice = YES;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight-60-SafeAreaBottom_Height);
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60+SafeAreaBottom_Height)];
    subView.backgroundColor = PWWhiteColor;
    [self.view addSubview:subView];
    [subView addSubview:self.chooseLab];
    UIButton *button = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"确定"];
    [subView addSubview:button];
    button.titleLabel.font = RegularFONT(14);
    [button addTarget:self action:@selector(chooseConfirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(44);
        make.bottom.mas_equalTo(subView).offset(-SafeAreaBottom_Height-20);
        make.height.offset(ZOOM_SCALE(22));
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.chooseLab);
        make.right.mas_equalTo(subView).offset(-Interval(26));
        make.width.offset(ZOOM_SCALE(56));
        make.height.offset(ZOOM_SCALE(22));
    }];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.offset(60+SafeAreaBottom_Height);
    }];
}
- (void)chooseConfirmClick{
    if (self.chooseArr.count>0) {
        self.chooseMembers(self.chooseArr);
    }
     [self backBtnClicked];
}
- (void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.DisMissBlock) {
            self.DisMissBlock();
        }
    }];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
-(NSMutableArray<MemberInfoModel *> *)teamMemberArray{
    if (!_teamMemberArray) {
        _teamMemberArray = [NSMutableArray new];
    }
    return _teamMemberArray;
}
-(UILabel *)chooseLab{
    if (!_chooseLab) {
        _chooseLab = [PWCommonCtrl lableWithFrame:CGRectMake(44, 20, ZOOM_SCALE(100), ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWBlueColor text:@"已选择: 0 人"];
    }
    return _chooseLab;
}
-(NSMutableArray *)chooseArr{
    if (!_chooseArr) {
        _chooseArr = [NSMutableArray new];
    }
    return _chooseArr;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexArr;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionItem = self.dataSource[section];
    return sectionItem.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell"];
    MemberInfoModel *model = self.dataSource[indexPath.section][indexPath.row];
    model.isMultiChoice = self.isMultiChoice;
    cell.model = model;
    NSArray *array =self.dataSource[indexPath.section];
    cell.line.hidden = indexPath.row == array.count-1?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return self.indexArr[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0.1;
    }else{
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isMultiChoice) {
        TeamMemberCell *cell = (TeamMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
        MemberInfoModel *model =self.dataSource[indexPath.section][indexPath.row];
        BOOL isSelect = model.isSelect;
        model.isSelect = !isSelect;
        [cell setTeamMemberSelect:model.isSelect];
        if (model.isSelect) {
            model.isSelect = YES;
        [self.chooseArr addObject:self.dataSource[indexPath.section][indexPath.row]];
        }else{
            model.isSelect = NO;
            [[self.chooseArr modelCopy] enumerateObjectsUsingBlock:^(MemberInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.memberID isEqualToString:obj.memberID]) {
                    [self.chooseArr removeObjectAtIndex:idx];
                }
            }];
        }
    }else{
        if(self.chooseMembers){
            self.chooseMembers(@[self.dataSource[indexPath.section][indexPath.row]]);
            [self backBtnClicked];
        }
    }
    self.chooseLab.text = [NSString stringWithFormat:@"已选择: %lu 人",(unsigned long)self.chooseArr.count];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
