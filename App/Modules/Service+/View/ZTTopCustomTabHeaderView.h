//
//  ZTTopCustomTabHeaderView.h
//  App
//
//  Created by tao on 2019/4/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSUInteger{
    talking_status, //洽谈中
    cancel_status,  //订单取消
    notPay_status,  //待支付
    payed_status,   //已完成
    
}OrderStatusType;
typedef void(^CancelBlock)(void);
typedef void(^PayBlock)(void);
NS_ASSUME_NONNULL_BEGIN
@interface ZTTopCustomTabHeaderView : UIView
@property (nonatomic, assign)OrderStatusType orderStatusType;
@property (nonatomic, copy)CancelBlock cancelBlock;
@property (nonatomic, copy)PayBlock payBlock;
@end

NS_ASSUME_NONNULL_END