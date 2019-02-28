//
//  FillinTeamInforVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/26.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger, FillinTeamType){
    FillinTeamTypeAdd = 1,
    FillinTeamTypeIsAdmin,
    FillinTeamTypeIsMember,
};
NS_ASSUME_NONNULL_BEGIN

@interface FillinTeamInforVC : RootViewController
@property (nonatomic, assign) FillinTeamType type;
@end

NS_ASSUME_NONNULL_END
