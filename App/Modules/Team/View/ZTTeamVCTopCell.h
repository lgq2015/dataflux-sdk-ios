//
//  ZTTeamVCTopCell.h
//  App
//
//  Created by tao on 2019/5/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZTTeamVCTopCell;
typedef enum: NSUInteger{
    inviteMemberType,
    cloudServerType,
    teamManagerType,
    notificationRule,
}TeamTopType;
@protocol ZTTeamVCTopCellDelegate <NSObject>
@optional
- (void)didClickTeamTopCell:(UITableViewCell *)cell withType:(TeamTopType)type;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ZTTeamVCTopCell : UITableViewCell
- (CGFloat)caculateRowHeight;
@property (nonatomic, weak)id<ZTTeamVCTopCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
