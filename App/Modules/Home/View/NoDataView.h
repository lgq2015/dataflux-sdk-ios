//
//  IssueListNoDataView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NoDataViewStyle) {
    NoDataViewNormal = 0,           // 没有btn
    NoDataViewIssueList = 1,        // 情报列表无数据 查看过去24小时
    NoDataViewLastDay,              // 查看过去24小时无数据 点击查看日历
};
NS_ASSUME_NONNULL_BEGIN

@interface NoDataView : UIView
@property (nonatomic, copy) void(^btnClickBlock)(void);

-(instancetype)initWithFrame:(CGRect)frame style:(NoDataViewStyle)style;

@end

NS_ASSUME_NONNULL_END
