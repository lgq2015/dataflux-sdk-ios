//
//  FounctionIntroCell.h
//  App
//
//  Created by tao on 2019/4/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FounctionIntroductionModel.h"


NS_ASSUME_NONNULL_BEGIN
@class FounctionIntroCell;
@protocol FounctionIntroCellDelegate <NSObject>

- (void)didClickMoreBtn:(FounctionIntroCell *)cell;

@end

@interface FounctionIntroCell : UITableViewCell
@property (nonatomic,strong)FounctionIntroductionModel *model;
- (CGFloat)caculateRowHeight:(FounctionIntroductionModel *)model;
@property (nonatomic, weak)id<FounctionIntroCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@end

NS_ASSUME_NONNULL_END
