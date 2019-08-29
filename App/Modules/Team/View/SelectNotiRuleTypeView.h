//
//  SelectNotiRuleTypeView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/8/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectNotiRuleTypeView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) void(^disMissClick)(void);
@property (nonatomic, copy) void(^selectClick)(NotiRuleStyle style);

-(instancetype)initWithTop:(CGFloat)top;
- (void)showInView:(UIView *)view notiRuleStyle:(NotiRuleStyle)style;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
