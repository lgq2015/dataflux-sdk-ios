//
//  EditBeizhuVC.h
//  App
//
//  Created by tao on 2019/4/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
typedef void(^EditTeamMemberNote)(NSString *noteName);
NS_ASSUME_NONNULL_BEGIN

@interface EditBeizhuVC : RootViewController
@property (nonatomic, copy)NSString *memeberID;
@property (nonatomic, copy)NSString *noteName;
@property (nonatomic, copy)EditTeamMemberNote editTeamMemberNote;
@end

NS_ASSUME_NONNULL_END
