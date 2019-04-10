//
//  ContactUsVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/7.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef enum : NSUInteger{
    //普通用户
    Normal_Type,
    //非普通用户
    VIP_Type,
}ContactUSType;
NS_ASSUME_NONNULL_BEGIN

@interface ContactUsVC : RootViewController
@property (nonatomic, assign)ContactUSType contactUSType;
@end

NS_ASSUME_NONNULL_END
