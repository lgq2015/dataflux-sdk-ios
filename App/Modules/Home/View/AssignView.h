//
//  AssignView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/6/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueListViewModel.h"
#import "MemberInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AssignView : UIView
@property (nonatomic, copy) void(^AssignClick)(void);

-(instancetype)initWithFrame:(CGRect)frame IssueModel:(IssueListViewModel *)model;
-(void)assignWithMember:(nullable MemberInfoModel *)member;
-(void)repair;
@end

NS_ASSUME_NONNULL_END
