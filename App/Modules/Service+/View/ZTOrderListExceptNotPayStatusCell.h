//
//  ZTOrderListExceptNotPayStatusCell.h
//  App
//
//  Created by tao on 2019/4/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FounctionIntroductionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTOrderListExceptNotPayStatusCell : UITableViewCell
- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model;
@end

NS_ASSUME_NONNULL_END