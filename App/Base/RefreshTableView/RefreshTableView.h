//
//  RefreshTableView.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/15.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshTableView : UITableView
/** 创建下拉刷新 */
- (void)setRefreshHeader;
/** 创建上拉加载 */
- (void)setRefreshFooter;
/** 结束下拉刷新 */
- (void)endHeaderRefreshing;
/** 结束上拉加载 */
- (void)endFooterRefreshing;
@end
