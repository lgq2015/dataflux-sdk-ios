//
//  MineViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *iconImgBtn;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHidenNaviBar = YES;
   // [self createUI];
}
#pragma mark ========== UI布局 ==========
- (void)createUI{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_offset(0);
        make.top.mas_offset(0);
        make.height.offset(ZOOM_SCALE(130));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgBtn).offset(ZOOM_SCALE(11));
        make.left.equalTo(self.iconImgBtn.mas_right).offset(ZOOM_SCALE(-30));
        make.right.mas_offset(-30);
        make.height.offset(ZOOM_SCALE(33));
    }];
    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(ZOOM_SCALE(8));
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(self.userName.mas_right);
        make.height.offset(ZOOM_SCALE(17));
    }];
    
}
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.rowHeight = 45;
        
    }
    return _mainTableView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(130))];
        _headerView.backgroundColor = PWWhiteColor;
        [self.view addSubview:_headerView];
    }
    return _headerView;
}
- (UIButton *)iconImgBtn{
    if (!_iconImgBtn) {
        _iconImgBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_iconImgBtn addTarget:self action:@selector(icomImgClick) forControlEvents:UIControlEventTouchUpInside];
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
    }
    return _userName;
}
- (UILabel *)companyName{
    if (!_companyName) {
        _companyName = [[UILabel alloc]initWithFrame:CGRectZero];
        _companyName.font =  [UIFont fontWithName:@"PingFangHK-Light" size: 12];
        _companyName.textColor = PWTextLight;
        _companyName.textAlignment = NSTextAlignmentLeft;
    }
    return _companyName;
}
#pragma mark ========== 用户头像选取 ==========
- (void)icomImgClick{
    
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
