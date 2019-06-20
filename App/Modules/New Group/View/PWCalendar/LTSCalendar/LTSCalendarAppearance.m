//
//  LTSCalendarAppearance.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//  日历外观样式

#import "LTSCalendarAppearance.h"

@implementation LTSCalendarAppearance


+ (instancetype)share{
    static dispatch_once_t onceToken;
    static LTSCalendarAppearance *appearance;
    dispatch_once(&onceToken, ^{
        appearance = [LTSCalendarAppearance new];
    });
    return  appearance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}
- (void)setFirstWeekday:(NSInteger)firstWeekday{
    _firstWeekday = firstWeekday;
    self.calendar.firstWeekday = firstWeekday;
}

- (void)setDefaultValues{
    self.dayCircleSize = ZOOM_SCALE(36);
    self.dayDotSize= ZOOM_SCALE(6) ;
    self.weekDayFormat = LTSCalendarWeekDayFormatSingle;
    self.weekDayTextFont = RegularFONT(14);
    self.weekDayTextColor = [UIColor colorWithHexString:@"#8E8E93"];
    self.weeksToDisplay = 6;
    self.weekDayHeight = ZOOM_SCALE(40);
    self.isShowSingleWeek = true;
    self.firstWeekday = 1;
    self.defaultDate = [NSDate date];
    self.singWeekDefaultSelectedIndex = 2;
    self.dayTextFont = [UIFont systemFontOfSize:16];
    self.lunarDayTextFont =[UIFont systemFontOfSize:10];
    
    [self setDayDotColorForAll:[UIColor colorWithRed:43./256. green:88./256. blue:134./256. alpha:1.]];
    [self setDayTextColorForAll:[UIColor whiteColor]];
    
   
    self.dayTextColor = [UIColor blackColor];
    self.lunarDayTextColor = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];;
    
    self.dayTextColorOtherMonth  = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    self.lunarDayTextColorOtherMonth = [UIColor colorWithRed:152./256. green:147./256. blue:157./256. alpha:1.];
    
    self.dayTextColorSelected = [UIColor whiteColor];
    self.lunarDayTextColorSelected = [UIColor whiteColor];
    
    
    self.dayBorderColorToday = [UIColor colorWithHexString:@"#2A7AF7"];
    self.dayCircleColorSelected  = [UIColor colorWithHexString:@"#C7C7CC"];
    self.dayCircleColorToday = [UIColor colorWithHexString:@"#2A7AF7"];
    self.dayTextColorToday = [UIColor whiteColor];
    self.dayDotColor = [UIColor colorWithHexString:@"#FFC163"];
  
    self.defaultSelected = YES;
    
    self.weekDayBgColor = [UIColor whiteColor];
    self.calendarBgColor = [UIColor whiteColor];
    self.scrollBgcolor = PWWhiteColor;
    //[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    self.isShowLunarCalender = NO;
    self.defaultSelected = NO;
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}
- (NSCalendar *)chineseCalendar{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (void)setDayDotColorForAll:(UIColor *)dotColor
{
    self.dayDotColor = dotColor;

}

- (void)setDayTextColorForAll:(UIColor *)textColor
{
    self.dayTextColor = textColor;
    self.dayTextColorSelected = textColor;
    self.lunarDayTextColor = textColor;
    self.lunarDayTextColorSelected = textColor;
    
    self.dayTextColorOtherMonth = textColor;
    self.lunarDayTextColorOtherMonth = textColor;
    
    self.dayTextColorToday = textColor;
}

@end
