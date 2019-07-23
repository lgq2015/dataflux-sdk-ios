//
//  CalendarSelView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CalendarSelDelegate <NSObject>
//选择完成
-(void)selectCalendarViewType:(CalendarViewType )type;
@end 
NS_ASSUME_NONNULL_BEGIN

@interface CalendarSelView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) void(^disMissClick)(void);
@property (nonatomic, assign)id<CalendarSelDelegate> delegate;

-(instancetype)initWithTop:(CGFloat)top;
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
