//
//  CalendarListCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CalendarIssueModel;
@interface CalendarListCell : UITableViewCell
@property (nonatomic, strong) CalendarIssueModel *model;
@property (nonatomic, copy)  void(^CalendarListCellClick)(void);
@property (nonatomic, assign) BOOL lineHide;
@end

NS_ASSUME_NONNULL_END
