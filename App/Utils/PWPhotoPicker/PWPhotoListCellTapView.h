//
//  PWPhotoListCellTapView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PWPhotoListCellTapView : UIView
//是否选中
@property (nonatomic, assign) BOOL selected;
//是否可操作
@property (nonatomic, assign) BOOL disabled;
@end

NS_ASSUME_NONNULL_END
