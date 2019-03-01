//
//  TeamMemberCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/1.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MemberInfoModel;
@interface TeamMemberCell : UITableViewCell
@property (nonatomic, strong) MemberInfoModel *model;
@end

NS_ASSUME_NONNULL_END
