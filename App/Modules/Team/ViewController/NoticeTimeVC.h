//
//  ViewController.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class NotiRuleModel;
typedef void (^SelectTime)(NSString *startTime, NSString * endTime);

@interface NoticeTimeVC : RootViewController
@property (nonatomic, strong) NotiRuleModel *model;
@property (nonatomic, copy) SelectTime timeBlock;
@end

NS_ASSUME_NONNULL_END
