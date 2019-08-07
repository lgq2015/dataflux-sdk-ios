//
//  TeamSuccessVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "TeamSuccessVC.h"
#import "PWWeakProxy.h"

@interface TeamSuccessVC ()
@property (weak, nonatomic) UIView *navBar;
@property (weak, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) UILabel *timeLab;
@end

@implementation TeamSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavBar];
    [self createUI];
}
/**
 *  头部导航
 */
- (void)setupNavBar {
    //界面组件
    UIView *navBar = [[UIView alloc] init];
    navBar.backgroundColor = PWWhiteColor;
    navBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:navBar];
    self.navBar = navBar;
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.offset(kTopHeight);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = PWBackgroundColor;
    [navBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(navBar);
        make.height.offset(1);
    }];
    
    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = PWBlackColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [navBar addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.bottom.mas_equalTo(navBar);
        make.centerX.mas_equalTo(navBar.centerX);
    }];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)createUI{
    if(self.isTrans){
        self.titleLabel.text = NSLocalizedString(@"local.TransferManager", @"");
    }else{
        self.titleLabel.text = @"解散团队";
    }
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight+Interval(12), kWidth, kHeight-kTopHeight-Interval(12))];
    contentView.backgroundColor = PWWhiteColor;
    [self.view addSubview:contentView];
    
    UIImageView *successimg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"team_success"]];
    [contentView addSubview:successimg];
    [successimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(Interval(55));
        make.width.height.offset(ZOOM_SCALE(80));
        make.centerX.mas_equalTo(contentView);
    }];
    NSString *tipstr = self.isTrans?@"转移成功":@"解散成功";
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:tipstr];
    [contentView addSubview:tipLab];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(contentView);
        make.top.mas_equalTo(successimg.mas_bottom).offset(Interval(32));
        make.height.offset(ZOOM_SCALE(25));
    }];
    
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#8E8E93"] text:@""];
    [contentView addSubview:timeLab];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(contentView);
        make.top.mas_equalTo(tipLab.mas_bottom).offset(Interval(16));
        make.height.offset(ZOOM_SCALE(20));
    }];
    timeLab.text = @"将在 5s 后退出登录";
    self.timeLab = timeLab;
    self.second = 5;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf timerRun];
        }];
    } else {
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:[PWWeakProxy proxyWithTarget:self] selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    UIButton *logout = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeContain text:@"我知道了"];
    [contentView addSubview:logout];
    [logout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLab.mas_bottom).offset(Interval(94));
        make.left.mas_equalTo(contentView).offset(Interval(16));
        make.right.mas_equalTo(contentView).offset(-Interval(16));
        make.height.offset(ZOOM_SCALE(47));
    }];
    [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)timerRun{
    if (self.second>0) {
        self.second--;
        self.timeLab.text = [NSString stringWithFormat:@"将在 %lds 后退出登录",(long)self.second];
    }else if(self.second == 0){
         [self.timer invalidate];
    
        [userManager logout:^(BOOL success, NSString *des) {

                }];
    
            }
}
- (void)logoutClick{
    [self.timer invalidate];
    [userManager logout:^(BOOL success, NSString *des) {

    }];
    
}
-(void)dealloc{
    [self.timer invalidate];
    NSLog(@"%s", __func__);
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
