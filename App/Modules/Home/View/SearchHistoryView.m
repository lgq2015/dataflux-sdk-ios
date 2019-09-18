//
//  SearchHistoryView.m
//  App
//
//  Created by 胡蕾蕾 on 2019/9/12.
//  Copyright © 2019 hll. All rights reserved.
//

#import "SearchHistoryView.h"
#import "IssueListManger.h"
#import "SelfSizingCollectCell.h"
#import "AutoCollectionViewFlowLayout.h"

@interface SearchHistoryView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *historyCollection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
@implementation SearchHistoryView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = PWWhiteColor;
    UILabel *tipLab = [PWCommonCtrl lableWithFrame:CGRectMake(16, ZOOM_SCALE(16), 200, ZOOM_SCALE(20)) font:RegularFONT(15) textColor:PWTitleColor text:@"最近搜索"];
    [self addSubview:tipLab];
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-16-ZOOM_SCALE(20), ZOOM_SCALE(16), ZOOM_SCALE(20), ZOOM_SCALE(20))];
    [clearBtn setImage:[UIImage imageNamed:@"search_delect"] forState:UIControlStateNormal];
    [self addSubview:clearBtn];
   
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self reloadHistoryData];
}
-(void)reloadHistoryData{
    [self.dataSource removeAllObjects];
    [self.dataSource  addObjectsFromArray:[[IssueListManger sharedIssueListManger]getHistoryTitleInput]];
    if (self.dataSource.count>0) {
        self.historyCollection.hidden = NO;
    }else{
        self.historyCollection.hidden = YES;
    }
    [self.historyCollection reloadData];
}
-(UICollectionView *)historyCollection{
    if (!_historyCollection) {
        AutoCollectionViewFlowLayout  *layout = [[AutoCollectionViewFlowLayout alloc] init];
        // 设置具体属性
        // 1.设置 最小行间距
        layout.minimumLineSpacing = 20;
        // 2.设置 最小列间距
        layout.minimumInteritemSpacing  = 20;
        // 3.设置item块的大小 (可以用于自适应)
        layout.estimatedItemSize = CGSizeMake(20, 30);
        // 设置滑动的方向 (默认是竖着滑动的)
        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        // 设置item的内边距
        layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        _historyCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ZOOM_SCALE(53), kWidth, self.height-30) collectionViewLayout:layout];
        _historyCollection.backgroundColor = PWWhiteColor;
        _historyCollection.delegate = self;
        _historyCollection.dataSource = self;
        [self addSubview:_historyCollection];
        [_historyCollection registerClass:[SelfSizingCollectCell class] forCellWithReuseIdentifier:@"SelfSizingCollectCell"];

    }
    return _historyCollection;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)clearBtnClick{
    [self.dataSource removeAllObjects];
    self.historyCollection.hidden = YES;
    [[IssueListManger sharedIssueListManger] setSearchIssueTitleArray:self.dataSource];
}
- (void)saveHistoryData:(NSString *)text{
    NSString *saveText = [text removeFrontBackBlank];
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:saveText]) {
            [self.dataSource removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.dataSource insertObject:saveText atIndex:0];
    if (self.dataSource.count>10) {
        [self.dataSource removeObjectAtIndex:10];
    }
    [[IssueListManger sharedIssueListManger] setSearchIssueTitleArray:self.dataSource];
}
#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelfSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelfSizingCollectCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
    
}
#pragma mark ========== UICollectionViewDelegate ==========
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *searchText = self.dataSource[indexPath.row];
    [self saveHistoryData:searchText];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryWithText:)]) {
        [self.delegate searchHistoryWithText:searchText];
    }
}

-(void)dealloc{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
