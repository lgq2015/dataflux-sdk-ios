//
//  GuideCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/27.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuideCell : UICollectionViewCell
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^itemClick)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
