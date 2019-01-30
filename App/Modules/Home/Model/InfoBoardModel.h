//
//  InfoBoardModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger , PWInfoType){
    PWInfoTypeMonitor = 0,
    PWInfoTypeConsume,
    PWInfoTypeAlert,
    PWInfoTypeSecurity,
    PWInfoTypeOptimization,
};
typedef NS_ENUM(NSInteger, PWInfoBoardItemState) {
    PWInfoBoardItemStateRecommend = 1,      //推荐
    PWInfoBoardItemStateWarning,            //警告
    PWInfoBoardItemStateSeriousness,        //严重
};
NS_ASSUME_NONNULL_BEGIN

@interface InfoBoardModel : NSObject
@property (nonatomic, assign) PWInfoType type;
@property (nonatomic, assign) PWInfoBoardItemState state;
@property (nonatomic, strong) NSString *messageCount;
@property (nonatomic, strong) NSString *subTitle;
- (instancetype)initWithJsonDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
