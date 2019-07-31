//
//  RootViewController.m
//  App
//
//  Created by 胡蕾蕾 on 2018/11/15.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "RootViewController.h"
#import "UIScrollView+UITouch.h"

@interface RootViewController ()
@property(nonatomic, strong) NoDataView *noDataView;
@property(nonatomic, strong) UILabel *noDataLab;
@property(nonatomic, strong) UIView *noNetWordView;
@property(nonatomic, strong) UIView *noSearchView;
@end

@implementation RootViewController


- (UIStatusBarStyle)preferredStatusBarStyle{
    return _StatusBarStyle;
}
//动态更新状态栏颜色
-(void)setStatusBarStyle:(UIStatusBarStyle)StatusBarStyle{
    _StatusBarStyle = StatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =PWBackgroundColor;
    //是否显示返回按钮
    self.isShowLiftBack = YES;
    //默认导航栏样式：黑字
    self.StatusBarStyle = UIStatusBarStyleDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if(self.isShowCustomNaviBar){
        self.isHidenNaviBar = YES;
        self.isShowLiftBack = NO;

        [self drawTopNaviBar];
    }
}
-(void)setBackgroundColor:(UIColor *)color{
    self.view.backgroundColor = color;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [iToast hiddenIToast];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (NaviBarView *)topNavBar {
    return _topNavBar;
}
-(void)setIsShowWhiteBack:(BOOL)isShowWhiteBack{
    _isShowWhiteBack = isShowWhiteBack;
    if (_isHidenNaviBar == YES) {
        self.whiteBackBtn.hidden = !_isShowWhiteBack;
    }
}
-(UIButton *)whiteBackBtn{
    if (!_whiteBackBtn) {
        
    
    _whiteBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_whiteBackBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    _whiteBackBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_whiteBackBtn];
    [_whiteBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.top.mas_equalTo(self.view).offset(kTopHeight-44);
        make.left.mas_equalTo(self.view);
        make.width.offset(40);
    }];
    }
    return _whiteBackBtn;
}
- (void)drawTopNaviBar{
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    NaviBarView *naviBar = [[NaviBarView alloc] initWithController:self];
    naviBar.backgroundColor = PWBackgroundColor;
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
    self.topNavBar.userInteractionEnabled = YES;
        // 添加返回按钮
    [self.view bringSubviewToFront:self.topNavBar];
    [self.topNavBar addBackBtn];
        // 添加底部分割线 - 如果不需要添加,这里处理即可
//    [_topNavBar addBottomSepLine];
}
- (void)setNaviTitle:(NSString *)naviTitle {
    if (self.isHidenNaviBar) {
        [_topNavBar setNavigationTitle:naviTitle];
    }else{
        self.title = naviTitle;
    }
}
- (void)showLoadingAnimation
{
    
}

- (void)stopLoadingAnimation
{
    
}
-(PWLibraryListNoMoreFootView*)footView{
    if (!_footView) {
        _footView = [[PWLibraryListNoMoreFootView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        _footView.backgroundColor =PWBackgroundColor;
    }
    return _footView;
}
/**
 优先级 ScrollView>tableView>collectionView
 */
- (void)setRefreshHeader{
    //头部刷新
    if (_mainScrollView) {
        self.mainScrollView.mj_header = self.header;
    }
    if (_tableView) {
        self.tableView.mj_header = self.header;
    }
    if (_collectionView) {
        self.collectionView.mj_header = self.header;
    }
}
-(MJRefreshGifHeader *)header{
    if (!_header) {
        _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        NSMutableArray *araray = [NSMutableArray new];
        for (int i =0; i<30; i++) {
            NSString *imgName = [NSString stringWithFormat:@"frame-%d@2x.png",i];
            [araray addObject:[UIImage imageNamed:imgName]];
        }
        NSArray *pullingImages = araray;
        _header.lastUpdatedTimeLabel.hidden = YES;
        _header.stateLabel.hidden =YES;
        [_header setImages:pullingImages duration:0.3 forState:MJRefreshStateIdle];
        
        [_header setImages:pullingImages duration:1 forState:MJRefreshStatePulling];
    }
    return _header;
}
-(MJRefreshBackStateFooter *)footer{
    if (!_footer) {
        _footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    }
    return _footer;
}
#pragma mark ========== 没有数据空页面 ==========
- (void)showNoDataImage{
    [self showNoDataViewWithStyle:NoDataViewNormal];
}
-(void)showNoDataViewWithStyle:(NoDataViewStyle)style
{
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            obj.hidden = YES;
        }
    }];
    CGFloat height = self.isHidenNaviBar?Interval(12)+kTopHeight:Interval(12);
    if (!_noDataView) {
       _noDataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, height, kWidth, kHeight-kTopHeight) style:style];
        WeakSelf
        _noDataView.btnClickBlock = ^(){
            [weakSelf noDataBtnClick];
        };
    }
    [self.view addSubview:self.noDataView];
}
- (void)noDataBtnClick{
    
}
-(void)removeNoDataImage{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
    if (_tableView) {
        _tableView.hidden = NO;
    }
}
#pragma mark ========== 搜索结果为空页面 ==========
-(void)hideNoSearchView{
    if (_noSearchView) {
        self.noSearchView.hidden = YES;
    }
    if (_tableView) {
        _tableView.hidden = NO;
    }
}
-(void)showNoSearchView{
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            obj.hidden = YES;
        }
    }];
    self.noSearchView.hidden = NO;
    CGFloat height = self.isHidenNaviBar?Interval(12)+kTopHeight:Interval(12)+CGRectGetMinY(self.tableView.frame);
    self.noSearchView.frame =CGRectMake(0, height, kWidth, kHeight-kTopHeight);
    [self.view addSubview:self.noSearchView];
}
-(void)showNoNetWorkView{
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            obj.hidden = YES;
        }
    }];
    self.noNetWordView.hidden = NO;
    [self.view addSubview:self.noNetWordView];
}
-(void)hideNoNetworkView{
    if (_noNetWordView) {
        self.noSearchView.hidden = YES;
    }
    if (_tableView) {
        _tableView.hidden = NO;
    }
}
-(UIView *)noSearchView{
    if (!_noSearchView) {
        CGFloat height = self.isHidenNaviBar?Interval(12)+kTopHeight:Interval(12);
        _noSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, height, kWidth, kHeight-kTopHeight)];
        _noSearchView.backgroundColor = PWWhiteColor;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(111), ZOOM_SCALE(222), ZOOM_SCALE(190))];
        [image setImage:[UIImage imageNamed:@"no_message"]];
        image.centerX = self.view.centerX;
        [_noSearchView addSubview:image];
        UILabel *no = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(328), kWidth, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTitleColor text:@"暂无搜索结果"];
        no.textAlignment = NSTextAlignmentCenter;
        [_noSearchView addSubview:no];
    }
    return _noSearchView;
}

-(UIView *)noNetWordView{
    if (!_noNetWordView) {
        CGFloat height = self.isHidenNaviBar?Interval(12)+kTopHeight:Interval(12);
        
        _noNetWordView = [[UIView alloc]initWithFrame:CGRectMake(0, height, kWidth, kHeight-kTopHeight)];
        _noNetWordView.backgroundColor = PWWhiteColor;
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(36), ZOOM_SCALE(232), ZOOM_SCALE(350))];
        [image setImage:[UIImage imageNamed:@"no_network"]];
        image.centerX = self.view.centerX;
        [_noNetWordView addSubview:image];
        UILabel *no = [PWCommonCtrl lableWithFrame:CGRectMake(0, ZOOM_SCALE(412), kWidth, ZOOM_SCALE(22)) font:RegularFONT(16) textColor:PWTitleColor text:@"没有网络"];
        no.textAlignment = NSTextAlignmentCenter;
        [_noNetWordView addSubview:no];
    }
    return _noNetWordView;
}
-(void)showNoMoreDataFooter{
    if (_footer) {
        self.footer.hidden = YES;
    }
    if (_tableView ) {
        self.tableView.tableFooterView = self.footView;
    }
}
-(void)showLoadFooterView{
    if (_footer) {
        self.footer.hidden = NO;
    }
    if (_tableView && _footView) {
        self.tableView.tableFooterView = nil;
    }
}

/**
 *  懒加载UIScrollView
 *
 *  @return UIScrollView
 */
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-kTopHeight)];
        _mainScrollView.alwaysBounceHorizontal = NO;
        _mainScrollView.directionalLockEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
  
        _tableView.scrollsToTop = YES;
        _tableView.backgroundColor = PWBackgroundColor;
         _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


-(void)headerRefreshing{
    [NSException raise:@"[RootViewController headerRefreshing]"
                format:@"You Must Override This Method."];
}

-(void)footerRefreshing{
    [NSException raise:@"[RootViewController footerRefreshing]"
                format:@"You Must Override This Method."];
}

/**
 *  是否显示返回按钮
 */
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"icon_back"] isLeft:YES target:self action:@selector(backBtnClicked) tags:nil];
        
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}
- (void)backBtnClicked
{
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}
- (CAGradientLayer *)getbackgroundLayerWithFrame:(CGRect)frame{
    CAGradientLayer *backLayer = [CAGradientLayer layer];
    backLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    backLayer.colors = @[
                          (id)[UIColor colorWithHexString:@"FFBC88"].CGColor,
                          (id)[UIColor colorWithHexString:@"FF6F5B"].CGColor
                          ];
    // 设置渐变方向(0~1)
    backLayer.locations = @[@0];
    backLayer.startPoint = CGPointMake(0, 0);
    backLayer.endPoint = CGPointMake(1.0, 0);
    return backLayer;
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //  UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 40, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = RegularFONT(16);
        [btn setTitleColor:PWBlueColor forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        //设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

//取消请求
- (void)cancelRequest
{
    
}
//-(void)viewDidDisappear:(BOOL)animated{
//    [SVProgressHUD dismiss];
//}
- (void)dealloc{
    [self cancelRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //当前支持的旋转类型
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    // 是否支持旋转
    return NO;
}
- (void)clearNavBarBackgroundColor{
    [self.topNavBar clearNavBarBackgroundColor];
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    // 默认进去类型
    return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
