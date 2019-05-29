//
//  ChooseChatStateView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "ChooseChatStateView.h"
#import "ChatInputHeaderView.h"
#import "HomeSelectCell.h"
@interface ChooseChatStateView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) IssueDealState state;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *contentView;
@end
@implementation ChooseChatStateView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    self.dataSource = @[@1,@2,@3];
    [self.mTableView registerClass:HomeSelectCell.class forCellReuseIdentifier:@"HomeSelectCell"];
    [self addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(self);
        make.height.offset(0);
    }];
}
- (void)showWithState:(NSInteger)state{
    self.hidden = NO;
    self.state = (IssueDealState)state;
    [self.mTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(self.dataSource.count*ZOOM_SCALE(45));
            }];
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            
        }];
    });
   
    
}

-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.rowHeight = ZOOM_SCALE(45);
        _mTableView.delegate = self;
        _mTableView.dataSource =self;
        _mTableView.layer.cornerRadius = 8;
        _mTableView.layer.shadowOffset = CGSizeMake(0,2);
        _mTableView.layer.shadowColor = [UIColor blackColor].CGColor;
        _mTableView.layer.shadowRadius = 5;
        _mTableView.layer.shadowOpacity = 0.06;
        _mTableView.clipsToBounds = NO;
        _mTableView.scrollEnabled = NO;

    }
    return _mTableView;
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSelectCell"];
    cell.type = SelectTypeIssueChat;
    cell.index = indexPath.row;
    cell.titleLab.textColor = PWTitleColor;
    WeakSelf
    cell.changeChatStateClick = ^(){
        if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(ChooseChatStateViewCellIndex:)]){
            [weakSelf.delegate ChooseChatStateViewCellIndex:indexPath.row+1];
            }
     [weakSelf disMissView];
    };
    return cell;
}


#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if(self.delegate && [self.delegate respondsToSelector:@selector(ChooseChatStateViewCellIndex:)]){
//        [self.delegate ChooseChatStateViewCellIndex:indexPath.row+1];
//    }
//   [self disMissView];
//    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == (NSInteger)self.state-1){
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
}
- (void)disMissView{
    [UIView animateWithDuration:0.1 animations:^{
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
