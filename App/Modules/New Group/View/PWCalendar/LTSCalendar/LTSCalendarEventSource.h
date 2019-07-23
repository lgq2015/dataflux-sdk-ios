//
//  LTSCalendarEventSource.h
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  点击有事件日期。。。

#import <Foundation/Foundation.h>
@class LTSCalendarManager;

@protocol LTSCalendarEventSource <NSObject>

/**
 该日期是否有事件
 @param date  NSDate
 @return BOOL
 */
@optional
- (BOOL)calendarHaveEventWithDate:(NSDate *)date;
- (UIColor *)calendarHaveEventDotColorWithDate:(NSDate *)date;

/**
 点击 日期后的执行的操作
 @param date 选中的日期
 */
- (void)calendarDidSelectedDate:(NSDate *)date firstDay:(NSDate *)first lastDay:(NSDate *)last;

//获取当前滑动的年月
- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month firstDay:(NSDate *)first lastDay:(NSDate *)last currentDate:(NSDate*)currentDate;
/**
 翻页完成后的操作

 */
- (void)backToToday;
- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewLoadMoreData;
- (void)tableViewLoadHeaderData;
@end
