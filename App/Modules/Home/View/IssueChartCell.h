//
//  IssueChartCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/11/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyModel;
NS_ASSUME_NONNULL_BEGIN
typedef void (^reportClickBlock)(NSInteger indentify);

@interface IssueChartCell : UITableViewCell
@property (nonatomic, strong) ClassifyModel *model;
@property (nonatomic, copy) reportClickBlock block;
- (void)initCardItem;
@end

NS_ASSUME_NONNULL_END
