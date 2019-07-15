//
//  MultipleSelectCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MultipleSelectModel;
@interface MultipleSelectCell : UITableViewCell
@property (nonatomic, strong) MultipleSelectModel *cellModel;
- (void)setCellSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
