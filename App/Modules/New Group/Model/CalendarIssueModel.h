//
//  CalendarIssueModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueListViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface CalendarIssueModel : NSObject
@property (nonatomic, strong) NSString *typeText;
@property (nonatomic, strong) NSString *timeText;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSString *issueId;
@property (nonatomic, assign) IssueState state;

@property (nonatomic, strong) NSString *groupTitle;
@property (nonatomic, assign) CGFloat calendarContentH; // 日历cell中可变的高度
@property (nonatomic, assign) CGFloat titleH;           // 情报状态的高度
@property (nonatomic, strong) NSDate *dayDate;
@property (nonatomic, assign) long seq;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
