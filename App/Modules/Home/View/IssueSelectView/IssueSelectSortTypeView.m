//
//  IssueSelectSortTypeView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/6/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueSelectSortTypeView.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
@interface IssueSelectSortTypeView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat topCons;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) SelectObject *mySel;
@end
@implementation IssueSelectSortTypeView
-(instancetype)initWithTop:(CGFloat)top{
    if (self) {
        self= [super init];
        _topCons = top;
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, self.topCons, kWidth, kHeight-self.topCons);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap=   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    [self addGestureRecognizer:tap];
    tap.delegate =self;
    [self.mTableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
    [self.contentView addSubview:self.mTableView];
}
-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(108)) style:UITableViewStylePlain];
        _mTableView.rowHeight = ZOOM_SCALE(54);
        _mTableView.backgroundColor = PWWhiteColor;
        _mTableView.delegate = self;
        _mTableView.dataSource =self;
    }
    return _mTableView;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(108))];
        _contentView.backgroundColor = PWWhiteColor;
        _contentView.layer.masksToBounds = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTap)];
//        [_contentView addGestureRecognizer:tap];
        [self addSubview:_contentView];
    }
    return _contentView;
}
-(void)contentTap{
    
}
-(void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    self.isShow = YES;
    [view addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
    SelectObject *sel = [[IssueListManger sharedIssueListManger] getCurrentSelectObject];
    self.mySel = sel;
    self.dataSource = @[@"产生时间排序",@"更新时间排序"];
    [self.mTableView reloadData];
    [_contentView setFrame:CGRectMake(0, -ZOOM_SCALE(108), kWidth,ZOOM_SCALE(108))];
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.alpha = 1.0;
        _contentView.alpha =1.0;
        [_contentView setFrame:CGRectMake(0, 0, kWidth, ZOOM_SCALE(108))];
        
    } completion:nil];
}
-(void)disMissView{
    if (self.disMissClick) {
        self.disMissClick();
    }
    self.isShow = NO;
   
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.alpha = 0;
        self.contentView.frame = CGRectMake(0, -ZOOM_SCALE(108), kWidth, ZOOM_SCALE(108));
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [UIView commitAnimations];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // self.contentView为子控件
    if ([touch.view isDescendantOfView:self.mTableView]) {
        return NO;
    }
    return YES;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    MineCellModel *model = [MineCellModel new];
    model.title = self.dataSource[indexPath.row];
    [cell initWithData:model type:MineVCCellTypeOnlyTitle];
    if (self.mySel.issueSortType == (IssueSortType)(indexPath.row+1)) {
        cell.titleLab.textColor = PWBlueColor;
    }else{
        cell.titleLab.textColor = PWTitleColor;
    }
    return cell;
}

#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.mySel.issueSortType =(IssueSortType)(indexPath.row+1);
    WeakSelf
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectSortWithSelectObject:)]){
        [self.delegate selectSortWithSelectObject:weakSelf.mySel];
    }
    [self disMissView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
