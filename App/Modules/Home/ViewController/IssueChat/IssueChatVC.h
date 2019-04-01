//
//  IssueChatVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueChatVC : RootViewController
@property (nonatomic, copy) NSString *issueID;
@property (nonatomic, strong) NSDictionary *infoDetailDict;
@end

NS_ASSUME_NONNULL_END
