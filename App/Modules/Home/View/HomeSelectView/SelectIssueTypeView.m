//
//  SelectIssueTypeView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SelectIssueTypeView.h"
#import "IssueListManger.h"

@interface SelectIssueTypeView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, assign) SelectType type;
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) NSInteger index;
@end
@implementation SelectIssueTypeView
-(instancetype)initWithType:(SelectType)type contentViewPoint:(CGPoint)point{
    if (self) {
        self= [super init];
        self.type = type;
        self.firstPoint = point;
        [self setupContent];
    }
    return self;
}
-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.rowHeight = ZOOM_SCALE(45);
        _mTableView.backgroundColor = PWWhiteColor;
        _mTableView.delegate = self;
        _mTableView.dataSource =self;
        _mTableView.layer.cornerRadius = 8;
        _mTableView.layer.shadowOffset = CGSizeMake(0,2);
        _mTableView.layer.shadowColor = [UIColor blackColor].CGColor;
        _mTableView.layer.shadowRadius = 5;
        _mTableView.layer.shadowOpacity = 0.06;
        _mTableView.layer.masksToBounds = YES;
    }
    return _mTableView;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMissView)];
    tap.delegate =self;
    [self addGestureRecognizer:tap];
    
    switch (self.type) {
        case SelectTypeIssue:
            self.dataSource = @[@1,@2,@3,@4,@5,@6];
       self.index =(NSInteger)[[IssueListManger sharedIssueListManger] getCurrentIssueType];
            break;
        case SelectTypeView:
            self.dataSource = @[@1,@2,@3];
        self.index =(NSInteger)[[IssueListManger sharedIssueListManger] getCurrentIssueViewType];
            break;
        default:
            break;
    }
    [self.mTableView registerClass:HomeSelectCell.class forCellReuseIdentifier:@"HomeSelectCell"];
    self.mTableView.frame = CGRectMake(self.firstPoint.x, self.firstPoint.y, ZOOM_SCALE(95), self.dataSource.count*ZOOM_SCALE(45));
    [self.mTableView reloadData];
   
    
    
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // self.contentView为子控件
    if ([touch.view isDescendantOfView:self.mTableView]) {
        return NO;
    }
    return YES;
}
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    switch (self.type) {
        case SelectTypeIssue:
            self.dataSource = @[@1,@2,@3,@4,@5,@6];
            self.index =(NSInteger)[[IssueListManger sharedIssueListManger] getCurrentIssueType];
            break;
        case SelectTypeView:
            self.dataSource = @[@1,@2,@3];
            self.index =(NSInteger)[[IssueListManger sharedIssueListManger] getCurrentIssueViewType];
            break;
        default:
            break;
    }
    [self addSubview:_mTableView];
    [self.mTableView reloadData];
    [view addSubview:self];

}

#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSelectCell"];
    cell.type = self.type;
    cell.index = indexPath.row;
    cell.titleLab.textColor = PWTitleColor;
    return cell;
}

#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

   if(self.delegate && [self.delegate respondsToSelector:@selector(selectIssueCellClick:selectType:)]){
        [self.delegate selectIssueCellClick:indexPath.row selectType:self.type];
    }
    [self removeFromSuperview];
    [_mTableView removeFromSuperview];

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
        if (indexPath.row == self.index-1){
            cell.selected = YES;
        }else{
            cell.selected = NO;
        }
    

}
- (void)disMissView{

    if(self.delegate && [self.delegate respondsToSelector:@selector(disMissClickWithSelectType:)]){
        [self.delegate disMissClickWithSelectType:self.type];
    }
    [self removeFromSuperview];
    [_mTableView removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
