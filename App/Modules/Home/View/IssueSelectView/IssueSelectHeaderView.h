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
typedef NS_ENUM(NSInteger ,SelectHeaderType){
    SelectHeaderAddIssue = 1, //无全部情报切换 有创建按钮
    SelectHeaderSearch = 2,   //有全部情报切换 无创建按钮
    SelectHeaderStatistical = 3,// 无全部情报切换 无创建按钮
}
;@protocol IssueSelectHeaderDelegate <NSObject>

-(void)selectIssueSelectObject:(SelectObject *)sel;
@end
@interface IssueSelectHeaderView : UIView
@property (nonatomic, strong) IssueSelectView *selView;//筛选
@property (nonatomic, strong) IssueSelectSortTypeView *sortByTimeView;//时间排序
@property (nonatomic, strong) IssueSelectSortTypeView *isMineView;//我的情报
@property (nonatomic, assign) id<IssueSelectHeaderDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame selectObject:(SelectObject *)selObj type:(SelectHeaderType)selectType;
-(instancetype)initWithFrame:(CGRect)frame type:(SelectHeaderType)selectType;
-(instancetype)initWithFrame:(CGRect)frame selectObject:(SelectObject *)selObj type:(SelectHeaderType)selectType classifyType:(ClassifyType)classifyType;
- (void)disMissView;
- (void)teamSwitchChangeBtnTitle;
@end

NS_ASSUME_NONNULL_END
