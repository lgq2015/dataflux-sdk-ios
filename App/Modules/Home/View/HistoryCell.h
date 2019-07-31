//
//  HistoryCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isNoIcon;
@property (nonatomic, copy) void(^delectClick)(void);

@end

NS_ASSUME_NONNULL_END
