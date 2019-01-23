//
//  MonitorListModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/27.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"

@interface MonitorListModel : JSONModel
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *attrs;
@property (nonatomic, strong) NSString *descs;
@property (nonatomic, strong) NSString *icon;
//@property (nonatomic, assign) MonitorListState state;
@property (nonatomic, strong) NSString *suggestion;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) CGFloat cellHeight;
@end
