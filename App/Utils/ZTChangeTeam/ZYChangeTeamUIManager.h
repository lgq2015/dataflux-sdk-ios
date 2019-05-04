//
//  ZYChangeTeamUIManager.h
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfoModel.h"
@protocol ZYChangeTeamUIManagerDelegate <NSObject>
@optional
//切换团队
- (void)didClickChangeTeamWithGroupID:(NSString *_Nullable)groupID;
//创建团队
- (void)didClickAddTeam;
//有成员缓存可无网络切换
- (void)changeTeamInNoNetwork;
@end
NS_ASSUME_NONNULL_BEGIN
typedef void(^DismissBlock)(BOOL isDismissed);
@interface ZYChangeTeamUIManager : UIView
+ (instancetype)shareInstance;
@property (nonatomic, weak)id<ZYChangeTeamUIManagerDelegate>delegate;
//表明切换团队界面是否弹出
@property (nonatomic, assign)BOOL isShowTeamView;
//消失回调
@property (nonatomic, copy)DismissBlock dismissedBlock;
//从哪个控制器上弹出的
@property (nonatomic, strong)UIViewController *fromVC;
- (void)showWithOffsetY:(CGFloat)offset;
-(void)dismiss;
//修改团队消息数
- (void)changeTeamMessageNum:(NSString *)num withGroupId:(NSString *)groupID;
//有人@我
- (void)somebodyCallMe:(NSString *)groupID;
@end

NS_ASSUME_NONNULL_END
