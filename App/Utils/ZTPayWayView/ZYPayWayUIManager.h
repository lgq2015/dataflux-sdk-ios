//
//  ZYPayWayUIManager.h
//  App
//
//  Created by tao on 2019/4/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger{
    //支付宝
    Zhifubao_PayWayType,
    //联系销售
    ContactSale_PayWayType,
}SelectPayWayType;
typedef void(^PayWayBlock)(SelectPayWayType selectPayWayType);
NS_ASSUME_NONNULL_BEGIN
@interface ZYPayWayUIManager : UIView
- (void)showWithPayWaySelectionBlock:(PayWayBlock)payWayBlock;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
