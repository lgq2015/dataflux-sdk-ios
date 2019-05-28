//
//  CalendarArrowView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchLargeButton.h"
@protocol CalendarArrowViewDelegate <NSObject>
- (void)backToday;
- (void)arrowClickWithUnfold:(BOOL)unfold;
@end
NS_ASSUME_NONNULL_BEGIN

@interface CalendarArrowView : UIView
@property (nonatomic, assign) BOOL arrowUp;
@property (nonatomic, strong) UILabel *selDateLab;
@property (nonatomic, strong) TouchLargeButton *backTodayBtn;
@property (nonatomic, assign) id<CalendarArrowViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
