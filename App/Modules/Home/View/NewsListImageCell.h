//
//  NewsListImageCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class NewsListModel;
@interface NewsListImageCell : MGSwipeTableCell

@property (nonatomic, strong) NewsListModel *model;
@end

NS_ASSUME_NONNULL_END
