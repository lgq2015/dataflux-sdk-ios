//
//  CollectionCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionModel;
NS_ASSUME_NONNULL_BEGIN

@interface CollectionCell : UITableViewCell
@property (nonatomic, strong) CollectionModel *model;
@end

NS_ASSUME_NONNULL_END