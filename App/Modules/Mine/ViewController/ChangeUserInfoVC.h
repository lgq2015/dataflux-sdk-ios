//
//  ChangeUserInfoVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"


typedef NS_ENUM(NSInteger, ChangeUserInfoType) {
    ChangeUITPhoneNumber = 1,
    ChangeUITPassword,
    ChangeUITEmail,
    ChangeUITTeamDissolve,
    ChangeUITTeamTransfer,
};
@interface ChangeUserInfoVC : RootViewController
@property (nonatomic, assign) ChangeUserInfoType type;
@property (nonatomic, copy) NSString *memberID;
@end


