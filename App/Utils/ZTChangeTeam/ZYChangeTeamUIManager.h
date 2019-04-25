//
//  ZYChangeTeamUIManager.h
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYChangeTeamUIManagerDelegate <NSObject>
@optional
- (void)didClickChangeTeamWithGroupID:(NSString *_Nullable)groupID;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ZYChangeTeamUIManager : UIView
- (void)showWithOffsetY:(CGFloat)offset fromViewController:(UIViewController *)fromVC;
+ (instancetype)shareInstance;
@property (nonatomic, weak)id<ZYChangeTeamUIManagerDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
