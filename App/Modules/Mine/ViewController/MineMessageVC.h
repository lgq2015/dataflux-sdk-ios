//
//  MineMessageVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/4.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
//消息所有者
typedef enum:  NSUInteger{
    Account_Message, //账户消息
    Team_Message,   //团队消息
}ZTMessageOwnerShip;
NS_ASSUME_NONNULL_BEGIN

@interface MineMessageVC : RootViewController
@property (nonatomic, assign)ZTMessageOwnerShip ownership;
@end

NS_ASSUME_NONNULL_END
