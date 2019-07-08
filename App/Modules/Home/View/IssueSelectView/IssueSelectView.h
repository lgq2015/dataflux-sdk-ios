//
//  IssueSelectView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectObject.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SelectViewDelegate <NSObject>
//选择完成
-(void)selectIssueWithSelectObject:(SelectObject *)sel;

@end

@interface IssueSelectView : UIView
@property (nonatomic, copy) void(^disMissClick)(void);
@property (nonatomic, assign)id<SelectViewDelegate> delegate;
@property (nonatomic, assign) BOOL isShow;
-(instancetype)initWithTop:(CGFloat)top;
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
