//
//  SelectIssueTypeView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSelectCell.h"

@protocol SelectIssueViewDelegate <NSObject>
//点击头像
-(void)selectIssueCellClick:(NSInteger )index selectType:(SelectType)type;
-(void)disMissClickWithSelectType:(SelectType)type;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SelectIssueTypeView : UIView
-(instancetype)initWithType:(SelectType)type contentViewPoint:(CGPoint)point;
- (void)showInView:(UIView *)view;
@property(nonatomic,assign)id<SelectIssueViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
