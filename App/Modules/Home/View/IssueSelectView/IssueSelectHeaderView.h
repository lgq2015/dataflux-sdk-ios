//
//  IssueSelectView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueSelectView.h"
#import "IssueSelectSortTypeView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol IssueSelectHeaderDelegate <NSObject>

-(void)selectIssueSelectObject:(SelectObject *)sel;
@end
@interface IssueSelectHeaderView : UIView
@property (nonatomic, strong) IssueSelectView *selView;//筛选
@property (nonatomic, strong) IssueSelectSortTypeView *sortByTimeView;//时间排序
@property (nonatomic, strong) IssueSelectSortTypeView *isMineView;//我的情报
@property (nonatomic, assign) id<IssueSelectHeaderDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame selectObject:(SelectObject *)selObj;
- (void)disMissView;
- (void)teamSwitchChangeBtnTitle;
@end

NS_ASSUME_NONNULL_END
