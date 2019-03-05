//
//  PWPhotoGroupView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@class ALAssetsFilter;
@protocol PWPhotoGroupViewProtocol <NSObject>

/**
 *  选中相册
 *
 *  @param assetsGroup 相册
 */
- (void)didSelectGroup:(ALAssetsGroup *)assetsGroup;

@end
NS_ASSUME_NONNULL_BEGIN

@interface PWPhotoGroupView : UITableView
//委托
@property (weak, nonatomic) id<PWPhotoGroupViewProtocol> my_delegate;
//过滤掉不现实的信息
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
//选中相册的索引
@property (nonatomic) NSInteger selectIndex;

/**
 *  加载并显示相册
 */
- (void)setupGroup;
@end

NS_ASSUME_NONNULL_END
