//
//  ZTTeamProductCell.h
//  App
//
//  Created by tao on 2019/5/2.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTTeamProductCell : UITableViewCell
-(void)setTeamProduct:(NSArray *)product;
- (CGFloat)caculateProductCellRowHeight;
@end

NS_ASSUME_NONNULL_END
