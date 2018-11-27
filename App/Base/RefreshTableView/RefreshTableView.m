//
//  RefreshTableView.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/15.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "RefreshTableView.h"
#import <MJRefresh.h>
@implementation RefreshTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setRefreshHeader{
    NSArray *images;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片 (idleImages 是图片)
    [header setImages:images forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:images forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:images forState:MJRefreshStateRefreshing];
    // 设置header
    self.mj_header = header;
}
- (void)setRefreshFooter{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
- (void)loadNewData{
    
}
- (void)loadMore{
    
}
- (void)endHeaderRefreshing{
    [self.mj_header endRefreshing];
}
- (void)endFooterRefreshing{
    [self.mj_footer endRefreshing];
}
@end
