//
//  TeamFillConfige.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamTF.h"


typedef NS_ENUM(NSUInteger, FillinTeamType){
    FillinTeamTypeAdd = 1,
    FillinTeamTypeIsAdmin,
    FillinTeamTypeIsMember,
    FillinTeamTypeIsManger,
};
NS_ASSUME_NONNULL_BEGIN

@interface TeamFillConfige : NSObject
@property (nonatomic, assign) FillinTeamType type;
@property (nonatomic, strong) NSMutableArray<TeamTF*> *teamTfArray;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL showDescribe;
@property (nonatomic, strong) NSString *describeStr;
@property (nonatomic, strong) NSString *currentProvince;
@property (nonatomic, strong) NSString *currentCity;

@end

NS_ASSUME_NONNULL_END
