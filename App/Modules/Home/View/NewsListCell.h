//
//  NewsListCell.h
//  PWNewsList
//
//  Created by 胡蕾蕾 on 2018/8/24.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
#import "MGSwipeTableCell.h"

@interface NewsListCell : MGSwipeTableCell
@property (nonatomic, strong) NewsListModel *model;
- (CGFloat)heightForModel:(NewsListModel *)model;
@end
