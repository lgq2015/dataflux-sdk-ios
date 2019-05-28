//
//  CalendarAppearance.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarAppearance : NSObject
///从星期几开始   8 代表星期天开始
@property (nonatomic, assign) NSInteger firstWeekday;
///是否显示日历
@property (nonatomic, assign) BOOL isShowLunarCalender;
///当显示为单周时 滚动周默认选中星期几   1 代表星期天 2代表星期一 default = 1
@property (nonatomic, assign) NSInteger singWeekDefaultSelectedIndex;
///每一周视图的高度  默认  ZOOM_SCALE(44) 圆部分  ZOOM_SCALE(44) dot ZOOM_SCALE(6)
@property (nonatomic, assign)CGFloat weekDayHeight;
///每个月显示多少周  默认：6
@property (nonatomic, assign)NSInteger weeksToDisplay;
///是否显示单周  默认：false
@property (nonatomic, assign)BOOL isShowSingleWeek;
@end

NS_ASSUME_NONNULL_END
