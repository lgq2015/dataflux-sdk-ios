//
//  IssueDetailRootVC.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueDetailRootVC.h"
#import "IssueListManger.h"
#import "PPBadgeView.h"
#import "IssueModel.h"
#import "ZTCreateTeamVC.h"


@interface IssueDetailRootVC ()
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, assign) BOOL firstInit;

@end

@implementation IssueDetailRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI{

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
    [self stateLabUI];
  
    [self.subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom).offset(Interval(20));
        make.width.offset(kWidth);
    }];
   
}



- (void)stateLabUI{
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
            self.stateLab.text = @"提示";
            break;
        case MonitorListStateRecommend:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"70E1BC"];
            self.stateLab.text = @"已恢复";
            break;
        case MonitorListStateLoseeEfficacy:
            self.stateLab.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
            self.stateLab.text = @"失效";
            break;
    }
}
- (void)updateUI{
    self.titleLab.text =self.model.title;
    self.timeLab.text =[self.model.time accurateTimeStr];
    [self stateLabUI];
}


-(void)dealloc{
    [[IssueListManger sharedIssueListManger] readIssue:self.model.issueId];
    [kNotificationCenter postNotificationName:KNotificationUpdateIssueList object:nil
                                     userInfo:@{@"updateView":@(YES)}];
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
        _titleLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(18) textColor:PWTextBlackColor text:@""];
        _titleLab.numberOfLines = 0;
        [self.upContainerView addSubview:_titleLab];
    }
    return _titleLab;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(16) textColor:PWSubTitleColor text:nil];
        _contentLab.backgroundColor = PWWhiteColor;
        _contentLab.numberOfLines = 0;
        [self.upContainerView addSubview:_contentLab];
    }
    return _contentLab;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:nil];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        [self.upContainerView addSubview:_timeLab];
    }
    return _timeLab;
}
-(UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font =  RegularFONT(14);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        _stateLab.layer.cornerRadius = 4.0f;
        _stateLab.layer.masksToBounds = YES;
        [self.upContainerView addSubview:_stateLab];
    }
    return _stateLab;
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
