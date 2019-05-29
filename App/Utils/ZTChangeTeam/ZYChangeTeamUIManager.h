//
//  ZYChangeTeamUIManager.h
//  App
//
//  Created by tao on 2019/4/25.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DismissBlock)(BOOL isDismissed);
@interface ZYChangeTeamUIManager : UIView
//+ (instancetype)shareInstance;
//表明切换团队界面是否弹出
@property (nonatomic, assign)BOOL isShowTeamView;
//消失回调
@property (nonatomic, copy) DismissBlock dismissedBlock;
//从哪个控制器上弹出的
@property (nonatomic, weak) UIViewController *fromVC;
- (void)showWithOffsetY:(CGFloat)offset;
- (void)dismiss;
//修改团队消息数
- (void)changeTeamMessageNum:(NSString *)num withGroupId:(NSString *)groupID;
//有人@我
- (void)somebodyCallMe:(NSString *)groupID;
@end

NS_ASSUME_NONNULL_END
