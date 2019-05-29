//
//  ZTCreateTeamConfig.h
//  App
//
//  Created by tao on 2019/4/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamTF.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTCreateTeamConfig : NSObject
@property (nonatomic, strong) NSMutableArray<TeamTF*> *teamTfArray;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL showDescribe;
@property (nonatomic, strong) NSString *describeStr;
@property (nonatomic, strong) NSString *currentProvince;
@property (nonatomic, strong) NSString *currentCity;
- (void)createTeamConfige;
@end

NS_ASSUME_NONNULL_END
