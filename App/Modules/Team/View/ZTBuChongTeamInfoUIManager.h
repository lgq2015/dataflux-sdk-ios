//
//  ZTBuChongTeamInfoUIManager.h
//  App
//
//  Created by tao on 2019/5/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBuChongBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ZTBuChongTeamInfoUIManager : UIView
- (void)show:(ClickBuChongBlock)clickBuChongBlock;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
