//
//  EchartTableView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/20.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EchartTableView : UIView
-(void)createTableWithData:(NSArray *)date header:(NSArray *)header height:(void(^)(CGFloat height))heightBlock;
@end

NS_ASSUME_NONNULL_END
