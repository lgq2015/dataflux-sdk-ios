//
//  UIViewController+FT_RootVC.h
//  FTAutoTrack
//
//  Created by 胡蕾蕾 on 2019/12/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FT_RootVC)
@property(nonatomic,strong) NSDate *viewLoadStartTime;

+ (NSString *)ft_getRootViewController;
-(NSString *)ft_getVCPath;
-(NSString *)ft_getParentVC;
@end

NS_ASSUME_NONNULL_END
