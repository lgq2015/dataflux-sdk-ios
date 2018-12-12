//
//  ItemContentCell.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/4.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PWGridViewItemDelegate <NSObject>
- (void)GridViewItemIndex:(NSInteger)index;
@end
@interface ItemContentCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *dataSource;
@end
