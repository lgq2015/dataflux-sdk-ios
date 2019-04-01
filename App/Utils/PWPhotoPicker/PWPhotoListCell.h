//
//  PWPhotoListCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ALAsset;

@interface PWPhotoListCell : UICollectionViewCell
/**
 *  显示照片
 *
 *  @param asset           照片
 *  @param selectionFilter 过滤器
 *  @param isSelected YES选中，NO取消选中
 */
- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSelected:(BOOL)isSelected;


/**
 *  选中
 *
 *  @param isSelected YES选中，NO取消选中
 */
- (void)isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
