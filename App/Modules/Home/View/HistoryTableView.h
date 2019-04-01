//
//  HistoryTableView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableView : UIView
@property (nonatomic, copy) void(^searchItem)(NSString *search);

-(void)reloadHistoryList;
@end

NS_ASSUME_NONNULL_END
