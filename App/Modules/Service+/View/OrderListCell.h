//
//  OrderListCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderListModel;
@interface OrderListCell : UITableViewCell
@property (nonatomic, strong) OrderListModel *model;
@end

NS_ASSUME_NONNULL_END
