//
//  PWPhotoGroupCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ALAssetsGroup;

@interface PWPhotoGroupCell : UITableViewCell
/**
 *  显示相册信息
 *
 *  @param assetsGroup 相册
 */
- (void)bind:(ALAssetsGroup *)assetsGroup;
@end

NS_ASSUME_NONNULL_END
