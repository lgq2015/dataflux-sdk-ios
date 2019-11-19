//
//  AlarmChartListModel.m
//  App
//
//  Created by 胡蕾蕾 on 2019/11/19.
//  Copyright © 2019 hll. All rights reserved.
//

#import "AlarmChartListModel.h"
#import "AlarmItemModel.h"
@implementation AlarmChartListModel

- (id)getItemData:(NSDictionary *)dic {

    return [[AlarmItemModel alloc] initWithDictionary:dic];
}
@end
