//
//  ZTHandBookNoPicCell.h
//  App
//
//  Created by tao on 2019/4/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandbookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTHandBookNoPicCell : UITableViewCell
@property (nonatomic, strong)HandbookModel *model;
@property (nonatomic, assign)BOOL isSearch; //区别是否是搜索（搜索也公用这个cell）
- (CGFloat)caculateRowHeight:(HandbookModel *)model;
@end

NS_ASSUME_NONNULL_END
