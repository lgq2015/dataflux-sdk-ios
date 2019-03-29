//
//  InfoRootVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "InfoRootVC.h"

@interface InfoRootVC ()
@property (nonatomic, strong) UIImageView *arrowImg;
@end

@implementation InfoRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (void)createUI{
//    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithTitle:@"讨论" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick)];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:PWBlueColor forKey:NSForegroundColorAttributeName];
//    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = item;
    self.mainScrollView.frame = CGRectMake(0, 0, kWidth, kHeight-kTopHeight);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(Interval(16));
        make.top.mas_equalTo(self.upContainerView).offset(Interval(14));
        make.right.mas_equalTo(self.upContainerView).offset(-Interval(16));
    }];
    [self.upContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainScrollView).offset(Interval(12));
        make.right.left.mas_equalTo(self.view);
    }];
    self.titleLab.text =self.model.title;
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upContainerView).offset(16);
        make.width.offset(ZOOM_SCALE(54));
        make.height.offset(ZOOM_SCALE(24));
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(ZOOM_SCALE(10));
    }];
    switch (self.model.state) {
        case MonitorListStateWarning:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FFC163"];
            self.stateLab.text = @"警告";
            break;
        case MonitorListStateSeriousness:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"FC7676"];
            self.stateLab.text = @"严重";
            break;
        case MonitorListStateCommon:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"599AFF"];
            self.stateLab.text = @"普通";
            break;
        case MonitorListStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已解决";
            break;
        case MonitorListStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLab.mas_right).offset(ZOOM_SCALE(15));
        make.centerY.mas_equalTo(self.stateLab);
        make.height.offset(ZOOM_SCALE(18));
    }];
    self.timeLab.text =[self.model.time accurateTimeStr];
    [self.progressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(Interval(7));
        make.centerY.mas_equalTo(self.timeLab);
        make.height.offset(ZOOM_SCALE(20));
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressBtn.mas_right).offset(Interval(3));
        make.centerY.mas_equalTo(self.progressBtn);
        make.height.width.offset(ZOOM_SCALE(13));

    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(kWidth);
        make.height.offset(1);
        make.top.mas_equalTo(self.stateLab.mas_bottom).offset(ZOOM_SCALE(1));
    }];
   
    [self loadProgressData];
}
#pragma mark ========== BTNCLICK ==========
- (void)navRightBtnClick{
    
}

- (void)loadProgressData{
    self.progressData = [NSMutableArray new];
    NSDictionary *param = @{@"pageSize": @100,@"type":@"keyPoint,bizPoint",@"subType":@"issueCreated,issueRecovered,issueExpired,exitExpertGroups,issueDiscarded,updateExpertGroups"};
    [PWNetworking requsetHasTokenWithUrl:PW_issueLog(self.model.issueId) withRequestType:NetworkGetType refreshRequest:NO cache:NO params:param progressBlock:nil successBlock:^(id response) {
        if([response[ERROR_CODE] isEqualToString:@""]){
            NSDictionary *content = response[@"content"];
            NSArray *data = content[@"data"];
            [self.progressData addObjectsFromArray:data];
            [self dealWithProgressView];
        }
    } failBlock:^(NSError *error) {
        
    }];
}
- (void)dealWithProgressView{
    DLog(@"progressData = %@",self.progressData);
    UIView *temp = nil;
    if (self.progressData.count>0) {
        for (NSInteger i= 0; i<self.progressData.count; i++) {
            UIView *dot = [[UIView alloc]init];
            dot.layer.cornerRadius = 3;
            dot.backgroundColor = [UIColor colorWithHexString:@"#FFB0B0"];
            [self.progressView addSubview:dot];
            if (temp==nil) {
                [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view).offset(Interval(16));
                    make.top.mas_equalTo(self.progressView).offset(Interval(12));
                    make.width.height.offset(6);
                }];
            }else{
                [dot mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(temp);
                    make.top.mas_equalTo(temp.mas_bottom).offset(Interval(18));
                    make.width.height.offset(6);
                }];
            }
            UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:MediumFONT(12) textColor:PWTitleColor text:@""];
            [self.progressView addSubview:timeLab];
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(dot.mas_right).offset(Interval(3));
                make.centerY.mas_equalTo(dot);
                make.height.offset(ZOOM_SCALE(17));
            }];
            timeLab.text = [NSString progressLabText:self.progressData[i]];
            temp = dot;
        }
    }
}
- (void)showProgress{
    self.progressBtn.selected = !self.progressBtn.selected;
    [self.view setNeedsUpdateConstraints];
    if (self.progressBtn.selected) {
        self.arrowImg.transform = CGAffineTransformMakeRotation(M_PI/2);
        [UIView animateWithDuration:0.3 animations:^{
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(self.progressData.count*ZOOM_SCALE(27)+3);
            }];
            [self.progressView layoutIfNeeded];
            [self.view layoutIfNeeded];
            
        }];
        
    }else{
        self.arrowImg.transform = CGAffineTransformMakeRotation(0);
        [UIView animateWithDuration:0.3 animations:^{
            [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(1);
            }];
            [self.progressView layoutIfNeeded];
            [self.view layoutIfNeeded];
            
        }];
    }
    CGFloat height =CGRectGetMaxY(self.subContainerView.frame);

    if ([[self.model.accountId stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqualToString:getPWUserID] || userManager.teamModel.isAdmin) {
        height += 50;
    }
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
        _contentLab.backgroundColor = PWWhiteColor;
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
//        [_progressBtn setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
//        [_progressBtn setImage:[UIImage imageNamed:@"selectGroup_tip"] forState:UIControlStateSelected];
        [_progressBtn addTarget:self action:@selector(showProgress) forControlEvents:UIControlEventTouchUpInside];
        [_progressBtn sizeToFit];

//        _progressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_progressBtn.imageView.frame.size.width - _progressBtn.frame.size.width + _progressBtn.titleLabel.frame.size.width, 0, 0);
//
//        _progressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_progressBtn.titleLabel.frame.size.width - _progressBtn.frame.size.width + _progressBtn.imageView.frame.size.width);
        [self.upContainerView addSubview:_progressBtn];
    }
    return _progressBtn;
}
-(UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_next"]];
        _arrowImg.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProgress)];
        [_arrowImg addGestureRecognizer:tap];
        _arrowImg.userInteractionEnabled = YES;
        [self.upContainerView addSubview:_arrowImg];
    }
    return _arrowImg;
}
-(UIView *)subContainerView{
    if (!_subContainerView) {
        _subContainerView = [[UIView alloc]init];
        _subContainerView.backgroundColor = PWWhiteColor;
        [self.mainScrollView addSubview:_subContainerView];
    }
    return _subContainerView;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
}
-(UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc]init];
        _progressView.clipsToBounds =YES;
        [self.upContainerView addSubview:_progressView];
    }
    return _progressView;
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
