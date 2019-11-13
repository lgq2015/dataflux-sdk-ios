//
//  ClassifyModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/11/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,ClassifyType){
    ClassifyTypeCrontab = 1,//诊断
    ClassifyTypeTask = 2,   //任务
    ClassifyTypeAlarm = 3,  //告警
    ClassifyTypeReport = 4, //报告
};
NS_ASSUME_NONNULL_BEGIN

@interface ClassifyModel : NSObject
@property (nonatomic, strong) NSArray *dangerAry;
@property (nonatomic, strong) NSArray *warningAry;
@property (nonatomic, strong) NSArray *commonAry;
@property (nonatomic, strong) NSArray *allAry;
@property (nonatomic, assign) ClassifyType type;
@property (nonatomic, strong) NSDictionary *echartDatas;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) NSArray *dayAry;
@property (nonatomic, strong) NSArray *serviceAry;
@property (nonatomic, strong) NSArray *webAry;
@end

NS_ASSUME_NONNULL_END
