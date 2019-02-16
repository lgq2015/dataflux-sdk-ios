//
//  MonitorListModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MonitorListState){
    MonitorListStateWarning,
    MonitorListStateSeriousness,
    MonitorListStateRecommend,
    MonitorListStateCommon,
    MonitorListStateLoseeEfficacy,
};

@class IssueModel;
@interface MonitorListModel : NSObject
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *attrs;
@property (nonatomic, strong) NSString *highlight;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, assign) MonitorListState state;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL isFromUser;
@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithJsonDictionary:(IssueModel *)model;

@end
