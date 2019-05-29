//
//  TeamMemberCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class MemberInfoModel;
@interface TeamMemberCell : MGSwipeTableCell
@property (nonatomic, strong) MemberInfoModel *model;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *phoneBtn;
- (void)setTeamMemberSelect:(BOOL)isSelect;
@end

NS_ASSUME_NONNULL_END
