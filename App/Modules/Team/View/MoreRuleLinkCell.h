//
//  MoreRuleLinkCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/7/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreRuleLinkCell : UITableViewCell
@property (nonatomic, assign) BOOL isDing;
@property (nonatomic, copy) NSString *linkStr;
@property (nonatomic, copy) void (^linkBlock)(NSString *str);
@property (nonatomic, copy) void (^minusBlock)(void);
- (void)noBtn;
@end

NS_ASSUME_NONNULL_END
