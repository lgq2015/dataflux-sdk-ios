//
//  RootViewController.h
//  App
//
//  Created by 胡蕾蕾 on 2018/11/15.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "NaviBarView.h"
#import "PWLibraryListNoMoreFootView.h"
@interface RootViewController : UIViewController
/**
 *  修改状态栏颜色
 */
@property (nonatomic, assign) UIStatusBarStyle StatusBarStyle;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong) MJRefreshBackStateFooter *footer;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PWLibraryListNoMoreFootView *footView;
/** 导航条 */
@property(nonatomic, strong)NaviBarView *topNavBar;
/**
 *  下拉刷新
 */
- (void)setRefreshHeader;
- (void)headerRereshing;
- (void)footerRereshing;
/**
 *  显示没有数据页面
 */
-(void)showNoDataImage;
-(void)setBackgroundColor:(UIColor *)color;
/**
 *  移除无数据页面
 */
-(void)removeNoDataImage;

/**
 *  加载视图
 */
- (void)showLoadingAnimation;

/**
 *  停止加载
 */
- (void)stopLoadingAnimation;
/**
 *  获取渐变背景
 */
- (CAGradientLayer *)getbackgroundLayerWithFrame:(CGRect)frame;
/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;

/**
 是否隐藏导航栏
 */
@property (nonatomic, assign) BOOL isHidenNaviBar;
/**
 是否显示自定义导航
 */
@property (nonatomic, assign) BOOL isShowCustomNaviBar;
/**
 设置导航标题
 */
- (void)setNaviTitle:(NSString *)naviTitle ;
/**
 
 导航栏添加文本按钮
 
 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)backBtnClicked;

//取消网络请求
- (void)cancelRequest;
/**
 *  显示没有更多数据 tableView footer
 */
-(void)showNoMoreDataFooter;
/**
 * 下拉刷新后 footer 为可加载
 */
-(void)showLoadFooterView;

@end
