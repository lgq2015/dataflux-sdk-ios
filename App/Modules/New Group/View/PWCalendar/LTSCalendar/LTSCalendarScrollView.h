//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"
#import "CalendarArrowView.h"
#import "HLSafeMutableArray.h"
@interface LTSCalendarScrollView : UIScrollView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LTSCalendarContentView *calendarView;
@property (nonatomic, strong) CalendarArrowView *arrorView;
@property (nonatomic, strong) HLSafeMutableArray *calendarList;

@property (nonatomic, assign) BOOL isUser;
@property (nonatomic, strong) UIColor *bgColor;
- (void)scrollToSingleWeek;
- (void)scrollToAllWeek;
- (void)showNomoreDatasFooter;
- (void)showLoadFooterView;
- (void)endRefreshing;
- (void)tablewViewDatasAdd:(NSArray *)array;
- (void)goDate:(NSDate *)date;
- (void)tablewViewDatasAddBeforeRemove:(NSArray *)array;
@end
