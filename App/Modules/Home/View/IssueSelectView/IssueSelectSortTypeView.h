//
//  IssueSelectSortTypeView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectObject.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SelectSortViewDelegate <NSObject>
//选择完成
-(void)selectSortWithSelectObject:(SelectObject *)sel;

@end
@interface IssueSelectSortTypeView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) void(^disMissClick)(void);
@property (nonatomic, assign)id<SelectSortViewDelegate> delegate;

-(instancetype)initWithTop:(CGFloat)top AndSelectTypeIsTime:(BOOL)istime;
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
