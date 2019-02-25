//
//  ProblemDetailsVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/1/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ProblemDetailsVC.h"
#import "PPBadgeView.h"

@interface ProblemDetailsVC ()
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *progressBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *typeIcon;
@property (nonatomic, strong) UILabel *issueNameLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *contentImg;

@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) UIButton *ignoreBtn;
@end

@implementation ProblemDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.isFromUser == YES?@"问题详情":@"情报详情";
    [self createUI];
}
#pragma mark ========== UI ==========
- (void)createUI{
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:PWBlueColor forKey:NSForegroundColorAttributeName];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self setupBadges];
//    });
    [self setupView];
    [self setSubView];
#pragma mark 导航
//    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
//    [self.navRightBtn setBadgeValue:2];
//    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)setupView{
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_upContainerView).offset(Interval(16));
        make.top.mas_equalTo(_upContainerView).offset(Interval(14));
        make.right.mas_equalTo(_upContainerView).offset(-Interval(16));
    }];
    [self.upContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScrollView).offset(Interval(12));
        make.width.offset(kWidth);
    }];
    self.titleLab.text =self.model.title;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(16);
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(10));
    }];
    self.stateLab.text =@"已解决";
    self.stateLab.backgroundColor = [UIColor colorWithHexString:@"75E3A4"];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(ZOOM_SCALE(15));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.timeLab.text =@"今天  11:50";
    [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(Interval(7));
        make.centerY.mas_equalTo(self.timeLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kWidth);
        make.height.offset(1);
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(ZOOM_SCALE(1));
    }];
    [self.typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(ZOOM_SCALE(13));
        make.width.offset(ZOOM_SCALE(39));
        make.height.offset(ZOOM_SCALE(27));
    }];
    self.typeIcon.image = [UIImage imageNamed:@"icon_ali"];
    [self.issueNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon.mas_right).offset(Interval(11));
        make.centerY.mas_equalTo(self.typeIcon);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.issueNameLab.text = @"我的阿里云";
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeIcon);
        make.top.mas_equalTo(self.typeIcon.mas_bottom).offset(ZOOM_SCALE(6));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
        if (self.model.isFromUser) {
            make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
        }
    }];
    self.contentLab.text = self.model.attrs;
    if (!self.model.isFromUser) {
        [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLab.mas_bottom).offset(ZOOM_SCALE(13));
            make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
            make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
            make.height.offset(ZOOM_SCALE(170));
            make.bottom.mas_equalTo(self.upContainerView.mas_bottom).offset(-Interval(20));
        }];
    }
}
- (void)setSubView{
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
        make.width.offset(kWidth);
    }];
    if (self.model.isFromUser) {
        [self setAccessorySubView];
    }else{
        [self setSuggestSubView];
    }
}
-(void)setAccessorySubView{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTextBlackColor text:@"附件"];
    [self.subContainerView addSubview:title];
    [self.subContainerView addSubview:self.tableView];
    self.tableView.backgroundColor = PWWhiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(Interval(25));
        make.width.offset(kWidth);
        make.height.offset(4*45);
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
    }];
    [self.ignoreBtn setTitle:@"关闭此问题" forState:UIControlStateNormal];
    
    self.ignoreBtn.hidden = self.model.state == MonitorListStateRecommend?YES:NO;
    
    [self.ignoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subContainerView.mas_bottom).offset(Interval(20));
        make.width.offset(ZOOM_SCALE(100));
        make.height.offset(ZOOM_SCALE(20));
        make.centerX.mas_equalTo(self.mainScrollView);
    }];
    [self.view layoutIfNeeded];
    CGFloat height = self.model.state == MonitorListStateRecommend? CGRectGetMaxY(self.subContainerView.frame):CGRectGetMaxY(self.ignoreBtn.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);

}
-(void)setSuggestSubView{
    UILabel *title = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), Interval(17), 100, ZOOM_SCALE(22)) font:MediumFONT(16) textColor:PWTextBlackColor text:@"建议"];
    [self.subContainerView addSubview:title];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"professor"]];
    icon.frame = CGRectMake(Interval(16), ZOOM_SCALE(55), ZOOM_SCALE(60), ZOOM_SCALE(60));
    [self.subContainerView addSubview:icon];
    [self.subContainerView addSubview:self.tableView];
    self.tableView.backgroundColor = PWWhiteColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(icon.mas_bottom).offset(Interval(25));
        make.width.offset(kWidth);
        make.height.offset(4*45);
        make.bottom.mas_equalTo(self.subContainerView.mas_bottom).offset(-Interval(5));
    }];
  
    [self.view layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(self.subContainerView.frame);

    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
}
-(UIView *)upContainerView{
    if (!_upContainerView) {
        _upContainerView = [[UIView alloc]init];
        _upContainerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_upContainerView];
    }
    return _upContainerView;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(16) textColor:PWTextBlackColor text:@""];
        _titleLab.numberOfLines = 0;
        [self.upContainerView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(14) textColor:PWSubTitleColor text:nil];
        _contentLab.numberOfLines = 0;
        [self.upContainerView addSubview:_contentLab];
    }
    return _contentLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectMake(Interval(22), Interval(17), ZOOM_SCALE(50), ZOOM_SCALE(24))];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.upContainerView addSubview:_stateLab];
    }
    return _stateLab;
}
-(UIButton *)progressBtn{
    if (!_progressBtn) {
        _progressBtn = [[UIButton alloc]init];
        [_progressBtn setTitle:@"情报进展" forState:UIControlStateNormal];
        _progressBtn.titleLabel.font =MediumFONT(13);
        [_progressBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        [_progressBtn setImage:[UIImage imageNamed:@"icon_nextgray"] forState:UIControlStateNormal];
        [_progressBtn addTarget:self action:@selector(showProgress:) forControlEvents:UIControlEventTouchUpInside];
        [_progressBtn sizeToFit];

        _progressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_progressBtn.imageView.frame.size.width - _progressBtn.frame.size.width + _progressBtn.titleLabel.frame.size.width, 0, 0);
        
        _progressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_progressBtn.titleLabel.frame.size.width - _progressBtn.frame.size.width + _progressBtn.imageView.frame.size.width);
        [self.upContainerView addSubview:_progressBtn];
    }
    return _progressBtn;
}
-(UIImageView *)typeIcon{
    if (!_typeIcon) {
        _typeIcon = [[UIImageView alloc]init];
        [self.upContainerView addSubview:_typeIcon];
    }
    return _typeIcon;
}
-(UILabel *)issueNameLab{
    if (!_issueNameLab) {
        _issueNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(13) textColor:PWSubTitleColor text:nil];
        [self.upContainerView addSubview:_issueNameLab];
    }
    return _issueNameLab;
}
-(UIImageView *)contentImg{
    if (!_contentImg) {
        _contentImg = [[UIImageView alloc]init];
        _contentImg.backgroundColor = PWGrayColor;
        [self.upContainerView addSubview:_contentImg];
    }
    return _contentImg;
}
-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.backgroundColor = PWWhiteColor;
        [self.upContainerView addSubview:_progressView];
    }
    return _progressView;
}
#pragma mark ========== subView ==========
-(UIView *)subContainerView{
    if (!_subContainerView) {
        _subContainerView = [[UIView alloc]init];
        _subContainerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_subContainerView];
    }
    return _subContainerView;
}
-(UIButton *)ignoreBtn{
    if (!_ignoreBtn) {
        _ignoreBtn = [[UIButton alloc]init];
        [_ignoreBtn setTitle:@"关闭此问题" forState:UIControlStateNormal];
        [_ignoreBtn setTitleColor:PWSubTitleColor forState:UIControlStateNormal];
        _ignoreBtn.titleLabel.font = RegularFONT(14);
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:_ignoreBtn];
    }
    return _ignoreBtn;
}
#pragma mark ========== btnClick ==========
- (void)showProgress:(UIButton *)button{
    self.progressBtn.selected = !button.selected;
    
    if (button.selected) {
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stateLab.mas_bottom).offset(8);
            make.width.offset(kWidth);
            make.height.offset(ZOOM_SCALE(70));
        }];
      
    }else{
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(kWidth);
            make.height.offset(1);
            make.top.mas_equalTo(self.stateLab.mas_bottom).offset(ZOOM_SCALE(1));
        }];
    }
    [self.view layoutIfNeeded];
 
    CGFloat height =self.model.isFromUser?CGRectGetMaxY(self.ignoreBtn.frame):CGRectGetMaxY(self.subContainerView.frame);
    self.mainScrollView.contentSize = CGSizeMake(kWidth, height+35);
  
}
- (void)ignoreBtnClick:(UIButton *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文案产品提供" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *confirm =[PWCommonCtrl actionWithTitle:@"确认关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [PWNetworking requsetHasTokenWithUrl:PW_issueRecover(self.model.issueId) withRequestType:NetworkPostType refreshRequest:NO cache:NO params:nil progressBlock:nil successBlock:^(id response) {
            if ([response[@"errCode"] isEqualToString:@""]) {
                [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failBlock:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setupBadges{
    [self.navigationItem.rightBarButtonItem pp_addBadgeWithNumber:2];
}


-(void)didClickBtn:(UIButton *)button {
    //    self.btnSize = CGSizeMake(self.btnSize.width * 1.3, self.btnSize.height * 1.3); //设置一个属性（btnSize）保存其大小的变化
    
    //1.告知需要更新约束，但不会立刻开始，系统然后调用updateConstraints
    [self.view setNeedsUpdateConstraints];
    
    //2.告知立刻更新约束，系统立即调用updateConstraints
    [self.view updateConstraintsIfNeeded];
    
    //3.这里动画当然可以取消，具体看项目的需求
    //系统block内引用不会导致循环引用，block结束就会释放引用对象
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded]; //告知页面立刻刷新，系统立即调用updateConstraints
    }];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
}

- (void)navRightBtnClick:(UIButton *)button{
    
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
