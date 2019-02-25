//
//  AboutUsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AboutUsVC.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
#import "PWBaseWebVC.h"
@interface AboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self createUI];
}
- (void)createUI{
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, Interval(30), ZOOM_SCALE(64), ZOOM_SCALE(64))];
    CGPoint center = icon.center;
    center.x = self.view.centerX;
    icon.center = center;
    icon.image = [UIImage imageNamed:@"icon_pws"];
    [self.view addSubview:icon];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *versonLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWTitleColor text:[NSString stringWithFormat:@"王教授 %@",version]];
    versonLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versonLab];
    [versonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kWidth);
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(15));
        make.height.offset(ZOOM_SCALE(20));
    }];
    MineCellModel *service = [[MineCellModel alloc]initWithTitle:@"功能介绍"];
    MineCellModel *privacy = [[MineCellModel alloc]initWithTitle:@"服务协议"];
    MineCellModel *newVersion = [[MineCellModel alloc]initWithTitle:@"检测新版本"];
//    MineCellModel *encourage = [[MineCellModel alloc]initWithTitle:@"鼓励我们"];
    self.dataSource = [NSMutableArray arrayWithArray:@[service,privacy,newVersion]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, Interval(16), 0, 0);
    [self.tableView registerClass:[MineViewCell class] forCellReuseIdentifier:@"MineViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, Interval(86)+ZOOM_SCALE(84), kWidth, self.dataSource.count*45);
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:{
            PWBaseWebVC *webView = [[PWBaseWebVC alloc]initWithTitle:@"服务协议" andURLString:PW_servicelegal];
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
        case 2:
            [[AppDelegate shareAppDelegate] DetectNewVersion];
            break;
        default:
            break;
    }
}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    [cell initWithData:self.dataSource[indexPath.row] type:MineVCCellTypeTitle];
    if(indexPath.row ==self.dataSource.count-1){
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kWidth);
    }
    return cell;
}


@end
