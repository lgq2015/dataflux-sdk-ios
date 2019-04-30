//
//  IssueIndexHeaderView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueBoard.h"
@class HomeNoticeScrollView;
NS_ASSUME_NONNULL_BEGIN

@interface IssueIndexHeaderView : UIView
@property (nonatomic, strong) IssueBoard *issueBoard;
@property(nonatomic, strong) HomeNoticeScrollView *notice;

-(instancetype)initWithStyle:(PWIssueBoardStyle)style;
- (void)updateTitle:(NSString *)title withStates:(BOOL)isCheck;
- (void)updateIssueBoardStyle:(PWIssueBoardStyle)style itemData:(NSDictionary *)paramsDict;
@end

NS_ASSUME_NONNULL_END
