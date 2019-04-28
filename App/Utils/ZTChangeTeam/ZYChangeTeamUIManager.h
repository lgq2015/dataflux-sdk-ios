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
//切换团队
- (void)didClickChangeTeamWithGroupID:(NSString *_Nullable)groupID;
//创建团队
- (void)didClickAddTeam;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ZYChangeTeamUIManager : UIView
+ (instancetype)shareInstance;
@property (nonatomic, weak)id<ZYChangeTeamUIManagerDelegate>delegate;
//表明切换团队界面是否弹出
@property (nonatomic, assign)BOOL isShowTeamView;
- (void)showWithOffsetY:(CGFloat)offset;
//修改团队消息数
- (void)changeTeamMessageNum:(NSString *)num withGroupId:(NSString *)groupID;
//有人@我
- (void)somebodyCallMe:(NSString *)groupID;
@end

NS_ASSUME_NONNULL_END
