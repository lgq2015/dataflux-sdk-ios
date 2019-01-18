//
//  MineViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MineViewController.h"
#import "PWPhotoOrAlbumImagePicker.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "SettingUpVC.h"
#import "ContactUsVC.h"
#import "ToolsVC.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *iconImgBtn;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic,strong) PWPhotoOrAlbumImagePicker *myPicker;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
    self.dataSource = [NSMutableArray new];
    [self dealWithData];
    [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    self.mainScrollView.backgroundColor = PWBackgroundColor;
    self.mainScrollView.contentSize = CGSizeMake(0, kHeight);
    [self.view addSubview:self.mainScrollView];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgBtn).offset(ZOOM_SCALE(11));
        make.left.equalTo(self.iconImgBtn.mas_right).offset(ZOOM_SCALE(30));
        make.right.mas_equalTo(ZOOM_SCALE(30));
        make.height.offset(ZOOM_SCALE(33));
    }];
    self.userName.text = @"User ONE";
    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(ZOOM_SCALE(8));
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(self.userName.mas_right);
        make.height.offset(ZOOM_SCALE(17));
    }];
    self.companyName.text = @"上海驻云信息科技有限公司";
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(ZOOM_SCALE(2));
        make.width.offset(kWidth);
        make.height.offset(self.dataSource.count*45);
    }];
}

       

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.rowHeight = 45;
        _mainTableView.backgroundColor = PWWhiteColor;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 5);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
        [self.mainScrollView addSubview:_mainTableView];
    }
    return _mainTableView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150+kStatusBarHeight-22)];
        _headerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_headerView];
    }
    return _headerView;
}
- (UIButton *)iconImgBtn{
    if (!_iconImgBtn) {
        _iconImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZOOM_SCALE(20), ZOOM_SCALE(52), ZOOM_SCALE(78), ZOOM_SCALE(78))];
        [_iconImgBtn addTarget:self action:@selector(icomImgClick) forControlEvents:UIControlEventTouchUpInside];
        [_iconImgBtn setImage:[UIImage imageNamed:@"icon_defaulthead"] forState:UIControlStateNormal];
        [self.headerView addSubview:_iconImgBtn];
    }
    return _iconImgBtn;
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
#pragma mark ========== 界面布局数据处理 ==========
- (void)dealWithData{
    MineCellModel *company = [[MineCellModel alloc]initWithTitle:@"我的企业" icon:@"icon_corporation" cellType:MineCellTypeCompany];
    MineCellModel *aliyun = [[MineCellModel alloc]initWithTitle:@"阿里云账号管理" icon:@"icon_aliyun" cellType:MineCellTypeAliyun];
    MineCellModel *order = [[MineCellModel alloc]initWithTitle:@"小工具" icon:@"icon_code" cellType:MineCellTypeTool];
    MineCellModel *collection = [[MineCellModel alloc]initWithTitle:@"我的收藏" icon:@"icon_collection" cellType:MineCellTypeCollect];
    MineCellModel *opinion = [[MineCellModel alloc]initWithTitle:@"意见与反馈" icon:@"icon_code" cellType:MineCellTypeOpinion];
    MineCellModel *contact = [[MineCellModel alloc]initWithTitle:@"联系我们" icon:@"icon_code" cellType:MineCellTypeContactuUs];
    MineCellModel *setting = [[MineCellModel alloc]initWithTitle:@"设置" icon:@"icon_code" cellType:MineCellTypeSetting];
    self.dataSource = @[company,aliyun,order,collection,opinion,contact,setting];
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
        case MineCellTypeTool:{
            ToolsVC *tool = [[ToolsVC alloc]init];
            [self.navigationController pushViewController:tool animated:YES];
        }
            break;
        case MineCellTypeAliyun:
            break;
        case MineCellTypeCompany:
            
            break;
    }

}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeBase];
    return cell;
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
