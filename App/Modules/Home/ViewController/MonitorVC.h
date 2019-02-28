//
//  MonitorVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/10.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MonitorVC : RootViewController
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL isFromTeam;
- (id)initWithTitle:(NSString *)title andIssueType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
