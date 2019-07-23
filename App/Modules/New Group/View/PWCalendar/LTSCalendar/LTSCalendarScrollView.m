//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#import "CalendarIssueModel.h"
#import "CalendarListCell.h"
#import "PWLibraryListNoMoreFootView.h"
#import <MJRefresh.h>

@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource,CalendarArrowViewDelegate>
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) BOOL isUpScroll;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, assign) CGFloat oldY;
@property (nonatomic, strong) PWLibraryListNoMoreFootView *footView;
@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong) MJRefreshBackStateFooter *footer;

@end
@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
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
- (void)initUI{
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.viewType = [userManager getCurrentCalendarViewType];
    self.isUser= YES;
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
//    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    CalendarArrowView *arrorView = [[CalendarArrowView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), ZOOM_SCALE(55)+8)];
    [self addSubview:arrorView];
    arrorView.delegate = self;
    self.arrorView = arrorView;
    self.arrorView.selDateLab.text = [calendarView.currentDate getCalenarTimeStr];
    self.arrorView.backTodayBtn.hidden = YES;
    DLog(@"CGRectGetHeight(self.frame) == %f",CGRectGetHeight(self.frame));
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(arrorView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(arrorView.frame)-ZOOM_SCALE(70))];
    self.tableView.backgroundColor = PWWhiteColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight=0 ;
        _tableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:CalendarListCell.class forCellReuseIdentifier:@"CalendarListCell"];
    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [self bringSubviewToFront:self.arrorView];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}
- (void)tablewViewDatasAdd:(NSArray *)array{
    [self.calendarList addObject:array];
    [self.tableView reloadData];
}
- (void)tablewViewDatasAddBeforeRemove:(NSArray *)array{
    [self.calendarList removeAllObjects];
    [self.calendarList addObjectsFromArray:array];
    [self.tableView reloadData];
}
-(HLSafeMutableArray *)calendarList{
    if (!_calendarList) {
        _calendarList = [HLSafeMutableArray new];
    }
    return _calendarList;
}
-(PWLibraryListNoMoreFootView*)footView{
    if (!_footView) {
        _footView = [[PWLibraryListNoMoreFootView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 60)];
        _footView.backgroundColor =PWWhiteColor;
    }
    return _footView;
}
-(MJRefreshBackStateFooter *)footer{
    if (!_footer) {
        _footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    }
    return _footer;
}
-(void)headerRefreshing{
    WeakSelf
    if (self.calendarView.eventSource && [self.calendarView.eventSource respondsToSelector:@selector(tableViewLoadHeaderData)]) {
        [weakSelf.calendarView.eventSource tableViewLoadHeaderData];
    }
}
-(void)footerRefreshing{
    WeakSelf
    if (self.calendarView.eventSource && [self.calendarView.eventSource respondsToSelector:@selector(tableViewLoadMoreData)]) {
        [weakSelf.calendarView.eventSource tableViewLoadMoreData];
    }
}
- (void)endRefreshing{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CalendarIssueModel *model = self.calendarList[indexPath.section][indexPath.row];
    if (model.calendarContentH) {
       return model.calendarContentH +Interval(28)+model.titleSize.height;
    }else{
        return ZOOM_SCALE(30);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *array= [self.calendarList copy];
    return array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_calendarList.count>0 && section<_calendarList.count) {
        NSArray *array = [self.calendarList[section] copy];

        return  array.count;
    }else{
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *groupHeader = [[UIView alloc]init];
    if (_calendarList.count>0 && section<_calendarList.count) {
    groupHeader.backgroundColor = PWWhiteColor;
    CalendarIssueModel *model = self.calendarList[section][0];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [groupHeader addSubview:line];
    UILabel *groupTitle = [PWCommonCtrl lableWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(11), kWidth-30, ZOOM_SCALE(18)) font:RegularFONT(13) textColor:PWSubTitleColor text:model.groupTitle];
    [groupHeader addSubview:groupTitle];
    return groupHeader;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ZOOM_SCALE(40);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_calendarList.count > 0  && indexPath.section<_calendarList.count){
        
    CalendarListCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CalendarListCell"];
    
    cell.model =(CalendarIssueModel *)self.calendarList[indexPath.section][indexPath.row];
    WeakSelf
    cell.CalendarListCellClick = ^(void){
        if (weakSelf.calendarView.eventSource && [weakSelf.calendarView.eventSource respondsToSelector:@selector(tableViewDidSelectRowAtIndexPath:)]) {
            [weakSelf.calendarView.eventSource tableViewDidSelectRowAtIndexPath:indexPath];
        }
    };
    NSArray *arrar = self.calendarList[indexPath.section];
    if (indexPath.row == arrar.count-1) {
        cell.lineHide = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    if(_isUser && (_currentSection - section) == 1 && !_isTouch){
        
        //最上面组头（不一定是第一个组头，指最近刚被顶出去的组头）又被拉回来
        
        _currentSection = section;
        CalendarIssueModel *model = self.calendarList[_currentSection][0];
        [self goDate:model.dayDate];
        DLog(@"willDisplayHeaderView显示第%ld组",(long)section);
        
    }
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    if(!_isFirstLoad && _isUpScroll && _isUser && !_isTouch){
        
        _currentSection = section + 1;
        //最上面的组头被顶出去
        CalendarIssueModel *model = self.calendarList[_currentSection][0];
        [self goDate:model.dayDate];
        DLog(@"didEndDisplayingHeaderView显示第%ld组",(long)section + 1);
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isEqual: self.tableView]) {
        
        if (self.tableView.contentOffset.y > _oldY) {
            // 上滑
            _isUpScroll = YES;
//            DLog(@"上滑");
        }else{
            // 下滑
            _isUpScroll = NO;
//            DLog(@"下滑");
        }
        _isFirstLoad = NO;
    }
    if (scrollView != self) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    CGRect arrowFrame = self.arrorView.frame;

    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    DLog(@"self.frame.height  === %f",CGRectGetHeight(self.frame))
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(arrowFrame)-CGRectGetHeight(calendarFrame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        arrowFrame.origin.y = CGRectGetMaxY(calendarFrame);
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(arrowFrame)-ZOOM_SCALE(70);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    self.arrorView.frame =arrowFrame;
    [self.calendarView setUpVisualRegion];
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.tableView.frame;
    if (CGRectContainsPoint(bounds, point)) {
        self.scrollEnabled = self.arrorView.arrowUp;
    }else{
        self.scrollEnabled = YES;
    }
    CGRect calendar = self.calendarView.frame;
    CGRect arrow = self.arrorView.frame;
    if (CGRectContainsPoint(calendar, point)||CGRectContainsPoint(arrow, point)) {
        _isTouch = YES;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}
- (void)showNomoreDatasFooter{
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
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self != scrollView) {
        self.isUser = YES;
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _isTouch = NO;
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (appearce.isShowSingleWeek) {
            return;
        }
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _oldY = self.tableView.contentOffset.y;
    if (self != scrollView) {
        return;
    }
}


- (void)scrollToSingleWeek{
    self.arrorView.arrowUp = NO;
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    if (!appearce.isShowSingleWeek) {
        [self.calendarView setUpVisualRegion];
    }
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
   
    
}

- (void)scrollToAllWeek{
    self.arrorView.arrowUp = YES;
    [self setContentOffset:CGPointMake(0, 0) animated:true];
  
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}
-(void)goDate:(NSDate *)date{
    if ([date isToday]) {
        self.arrorView.backTodayBtn.hidden = YES;
    }else{
        self.arrorView.backTodayBtn.hidden = NO;
    }
    self.arrorView.selDateLab.text = [date getCalenarTimeStr];
    [LTSCalendarAppearance share].defaultDate = date;
    [self.calendarView reloadDefaultDate];
    [self.calendarView reloadAppearance];
}
#pragma mark ========== CalendarArrowViewDelegate ==========
-(void)backToday{
    self.arrorView.selDateLab.text = [[NSDate date] getCalenarTimeStr];
    [self.tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.arrorView.backTodayBtn.hidden = YES;
//    if ([self.calendarView.currentDate month] != [[NSDate date] month]) {
//        [self.calendarView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//    }
    [LTSCalendarAppearance share].defaultDate = [NSDate date];
    [self.calendarView reloadDefaultDate];
    [self.calendarView reloadAppearance];
    if (self.calendarView.eventSource &&[self.calendarView.eventSource respondsToSelector:@selector(backToToday)]) {
        [self.calendarView.eventSource backToToday];
    }
}

-(void)arrowClickWithUnfold:(BOOL)unfold{
    if (unfold) {
        [self scrollToAllWeek];
    }else{
        [self scrollToSingleWeek];
    }
}
@end
