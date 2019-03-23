//
//  InfoRootVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "MonitorListModel.h"
#import "TeamInfoModel.h"
#import "PWChatVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoRootVC : RootViewController
@property (nonatomic, strong) MonitorListModel *model;
@property (nonatomic, strong) UIBarButtonItem *navRightBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *stateLab;
@property (nonatomic, strong) UIButton *progressBtn;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIView *subContainerView;
@property (nonatomic, strong) NSDictionary *infoDetailDict;

@property (nonatomic, strong) NSMutableArray *progressData;
- (void)navRightBtnClick;
- (void)showProgress:(UIButton *)button;
-(void)updateViewConstraints;
@end

NS_ASSUME_NONNULL_END
