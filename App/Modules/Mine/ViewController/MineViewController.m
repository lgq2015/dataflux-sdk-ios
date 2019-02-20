//
//  MineViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MineViewController.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "PersonalInfoVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "SettingUpVC.h"
#import "ContactUsVC.h"
#import "AboutUsVC.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIButton *personalBtn;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PWWhiteColor;
    self.isHidenNaviBar = YES;
    self.dataSource = [NSArray new];
    [self dealWithData];
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(ZOOM_SCALE(30));
        make.right.mas_equalTo(ZOOM_SCALE(30));
        make.centerY.mas_equalTo(self.iconImgView);
        make.height.offset(ZOOM_SCALE(25));
    }];
    self.userName.text = @"User ONE";
    [self.personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userName);
        make.right.mas_equalTo(self.view).offset(-Interval(16));
        make.width.height.offset(ZOOM_SCALE(20));
    }];

    self.tableView.rowHeight = ZOOM_SCALE(45);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 58, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    self.tableView.frame = CGRectMake(0, 0, kWidth, kHeight-kTabBarHeight);
}

       


- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160+kStatusBarHeight-22)];
        _headerView.backgroundColor = PWWhiteColor;
    }
    return _headerView;
}
-(UIButton *)personalBtn{
    if (!_personalBtn) {
        _personalBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_personalBtn setImage:[UIImage imageNamed:@"icon_nextbig"] forState:UIControlStateNormal];
        [_personalBtn addTarget:self action:@selector(personalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_personalBtn];
    }
    return _personalBtn;
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(Interval(16), kStatusBarHeight-22+54, ZOOM_SCALE(70), ZOOM_SCALE(70))];
        _iconImgView.image = [UIImage imageNamed:@"icon_defaulthead"];
        [self.headerView addSubview:_iconImgView];
    }
    return _iconImgView;
}
- (UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc]initWithFrame:CGRectZero];
        _userName.font = [UIFont fontWithName:@"PingFangHK-Medium" size: 24];
        _userName.textColor = PWBlackColor;
        _userName.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:_userName];
    }
    return _userName;
}
- (UILabel *)companyName{
    if (!_companyName) {
        _companyName = [[UILabel alloc]initWithFrame:CGRectZero];
        _companyName.font =  [UIFont fontWithName:@"PingFangHK-Light" size: 12];
        _companyName.textColor = PWTextLight;
        _companyName.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:_companyName];
    }
    return _companyName;
}
- (void)personalBtnClick:(UIButton *)button{
    PersonalInfoVC *personal = [[PersonalInfoVC alloc]init];
    [self.navigationController pushViewController:personal animated:YES];
}
#pragma mark ========== 界面布局数据处理 ==========
- (void)dealWithData{
    MineCellModel *mynews = [[MineCellModel alloc]initWithTitle:@"我的消息" icon:@"icon_news" cellType:MineCellTypeInformation];
    MineCellModel *infoSource = [[MineCellModel alloc]initWithTitle:@"情报源" icon:@"icon_information" cellType:MineCellTypeInfoSource];
    MineCellModel *collection = [[MineCellModel alloc]initWithTitle:@"收藏" icon:@"icon_collection" cellType:MineCellTypeCollect];
    MineCellModel *opinion = [[MineCellModel alloc]initWithTitle:@"意见与反馈" icon:@"icon_opinion" cellType:MineCellTypeOpinion];
    MineCellModel *contact = [[MineCellModel alloc]initWithTitle:@"联系我们" icon:@"icon_contact" cellType:MineCellTypeContactuUs];
    MineCellModel *encourage = [[MineCellModel alloc]initWithTitle:@"鼓励我们" icon:@"icon_encourage" cellType:MineCellTypeEncourage];
    MineCellModel *aboutPW = [[MineCellModel alloc]initWithTitle:@"关于王教授" icon:@"icon_about" cellType:MineCellTypeAboutPW];
    MineCellModel *setting = [[MineCellModel alloc]initWithTitle:@"设置" icon:@"icon_setting" cellType:MineCellTypeSetting];
    NSArray *group1 = @[mynews,infoSource,collection];
    NSArray *group2 = @[opinion,contact,encourage,aboutPW];
    NSArray *group3 = @[setting];
    self.dataSource = @[group1,group2,group3];
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = (MineViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    switch (cell.data.type) {
        case MineCellTypeSetting:{
            SettingUpVC *settingVC = [[SettingUpVC alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case MineCellTypeContactuUs:{
            ContactUsVC *contactVC = [[ContactUsVC alloc]init];
            [self.navigationController pushViewController:contactVC animated:YES];
        }
            break;
        case MineCellTypeOpinion:
            break;
        case MineCellTypeCollect:
            break;
        case MineCellTypeAboutPW:{
            AboutUsVC *aboutVC = [[AboutUsVC alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case MineCellTypeEncourage:
            [self evaluateSkip];
            break;
        
        case MineCellTypeInformation:
            
            break;
        case MineCellTypeInfoSource:
            
            break;
    }

}
- (void)evaluateSkip{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE_AFTER_IOS11]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_OPEN_EVALUATE]];
#endif
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arry = [self.dataSource objectAtIndex:section];
    if (arry&&arry.count) {
        return arry.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.section][indexPath.row] type:MineVCCellTypeBase];
    NSArray *array =self.dataSource[indexPath.section];
    if(indexPath.row == array.count-1){
     cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 12)];
    //自定义颜色
    view.backgroundColor = PWBackgroundColor;
    return view;
}
#pragma mark ========== 用户头像选取 ==========
- (void)icomImgClick{
    self.myPicker = [[PWPhotoOrAlbumImagePicker alloc]init];
    [self.myPicker getPhotoAlbumOrTakeAPhotoWithController:self photoBlock:^(UIImage *image) {
        //回调图片
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [PWNetworking uploadFileWithUrl:PW_currentUserIcon fileData:data type:@"png" name:@"avatar" mimeType:@"image/jpg/png" progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
            
        } successBlock:^(id response) {
            
        } failBlock:^(NSError *error) {
            
        }];
    }];

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
