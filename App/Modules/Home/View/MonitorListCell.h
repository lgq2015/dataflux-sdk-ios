//
//  MonitorListCell.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/26.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorListModel.h"
@interface MonitorListCell : UITableViewCell
- (void)setModel:(MonitorListModel *)model;

- (CGFloat)heightForModel:(MonitorListModel *)model;
@end
