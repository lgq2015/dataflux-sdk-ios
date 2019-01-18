//
//  MonitorCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MonitorListModel;
@interface MonitorCell : UITableViewCell
@property (nonatomic, strong) MonitorListModel *model;
- (CGFloat)heightForModel:(NSDictionary *)model;
@end


