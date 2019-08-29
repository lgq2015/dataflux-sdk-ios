//
//  AddNotiRuleModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "JSONModel.h"
typedef NS_ENUM(NSInteger,NotiRuleCellStyle){
    NotiRuleCellName,
    NotiRuleCellCondition,
    NotiRuleCellTime,
    NotiRuleCellWeek,
    NotiRuleCellNotiWay,
};
NS_ASSUME_NONNULL_BEGIN

@interface AddNotiRuleModel : JSONModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic, assign) NotiRuleCellStyle cellStyle;
@end

NS_ASSUME_NONNULL_END
