//
//  ZTOrderListCell.h
//  App
//
//  Created by tao on 2019/4/23.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FounctionIntroductionModel.h"
@class ZTOrderListCell;
@protocol ZTOrderListCellDelegate <NSObject>
- (void)didClickCancelOrder:(ZTOrderListCell *_Nonnull)cell;
- (void)didClickPayOrder:(ZTOrderListCell *_Nonnull)cell;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ZTOrderListCell : UITableViewCell
- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model;
@property (nonatomic, weak)id <ZTOrderListCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
