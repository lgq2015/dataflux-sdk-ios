//
//  PopItemView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PopItemView.h"
#import "MineViewCell.h"
#import "MineCellModel.h"
@interface PopItemView()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) CGSize mTabSize;
@end
@implementation PopItemView
-(instancetype)init{
    if (self) {
        self = [super init];
        [self setupContent];
    }
    return self;
}
- (void)setupContent{
    self.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    [self addGestureRecognizer:tap];
    tap.delegate =self;

}
-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mTableView.rowHeight = ZOOM_SCALE(35);
        _mTableView.backgroundColor = PWBackgroundColor;
        [_mTableView registerClass:MineViewCell.class forCellReuseIdentifier:@"MineViewCell"];
        _mTableView.layer.cornerRadius = 8;
        _mTableView.delegate = self;
    }
    return _mTableView;
}
- (void)setItemDatas:(NSArray *)itemDatas{
    _itemDatas = itemDatas;
    __block NSString *largestLenStr;
    [self.itemDatas enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length>largestLenStr.length) {
            largestLenStr = obj;
        }
    }];
    CGSize strSize = [largestLenStr strSizeWithMaxWidth:kWidth/2 withFont:RegularFONT(13)];
    self.mTabSize = CGSizeMake(strSize.width+24, ZOOM_SCALE(35)*itemDatas.count);
}
#pragma mark ========== UITableViewDataSource ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineViewCell"];
    MineCellModel *model = [MineCellModel new];
    model.title = self.itemDatas[indexPath.row];
    [cell initWithData:model type:MineVCCellTypeOnlyTitle];
    cell.titleLab.textAlignment = NSTextAlignmentCenter;
    [cell.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(cell);
    }];
    cell.titleLab.font = RegularFONT(13);
    return cell;
}
#pragma mark ========== UITableViewDelegate ==========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:indexPath.row];
    }
    [self disMissView];
}
-(void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    [view addSubview:self];
    [self addSubview:self.mTableView];
    self.mTableView.frame = CGRectMake(kWidth-16-self.mTabSize.width, kTopHeight, self.mTabSize.width,self.mTabSize.height);
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = PWRedColor;
    [self.mTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [self.mTableView setFrame:CGRectMake(kWidth-16-self.mTabSize.width, 12+kTopHeight, self.mTabSize.width, self.mTabSize.height)];
        
    } completion:nil];
    
    
}
- (void)disMissView{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [self.mTableView setFrame:CGRectMake(kWidth-16-self.mTabSize.width, kTopHeight, self.mTabSize.width,self.mTabSize.height)];

                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [self.mTableView removeFromSuperview];
                     }];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // self.contentView为子控件
    if ([touch.view isDescendantOfView:self.mTableView]) {
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
