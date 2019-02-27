//
//  BindEmailVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindEmailOrPhoneVC : RootViewController
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) BOOL isFirst;//邮箱是否之前没有绑定
@property (nonatomic, assign) BOOL isEmail;
@end

NS_ASSUME_NONNULL_END
