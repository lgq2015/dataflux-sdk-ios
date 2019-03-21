//
//  ExpertCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpertCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isInvite; //已邀请；
@property (nonatomic, assign) BOOL isMore;   //更多 类型
@property (nonatomic, strong) NSDictionary *data;
@end

NS_ASSUME_NONNULL_END
