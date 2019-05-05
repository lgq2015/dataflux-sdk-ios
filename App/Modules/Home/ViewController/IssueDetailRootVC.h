//
//  IssueDetailRootVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "IssueListViewModel.h"
#import "TeamInfoModel.h"
#import "IssueChatVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueDetailRootVC : RootViewController
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *progressBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *dealBtn;
@property (nonatomic, strong) UIButton *solveBtn;
@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) NSDictionary *infoDetailDict;

@property (nonatomic, strong) NSMutableArray *progressData;
- (void)navRightBtnClick;
- (void)updateViewConstraints;
- (void)updateUI;
@end

NS_ASSUME_NONNULL_END
