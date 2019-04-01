//
//  PWGridView.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/4.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "PWGridView.h"
#import "ItemContentCell.h"
#import "TAPageControl.h"
@interface PWGridView()<UICollectionViewDelegate,UICollectionViewDataSource,PWGridViewItemDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) TAPageControl *pageControl;
@end
@implementation PWGridView
#pragma mark ========== UI布局 ==========
- (void)createUIwithDatasArray:(NSArray *)datas{
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray arrayWithArray:datas];
    [self.collectionView reloadData];
    [self setupPageControl];
}
- (void)setupPageControl{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整

    if (self.dataSource.count<=8 ) return;
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    TAPageControl *pageControl = [[TAPageControl alloc] init];
    pageControl.frame = CGRectMake(self.frame.size.width/2-30, self.frame.size.height-23, 60, 15);
    pageControl.numberOfPages = self.dataSource.count%8==0?self.dataSource.count/8 :self.dataSource.count/8+1;
    [pageControl setCurrentDotImage:[UIImage imageNamed:@"res_PWGridView/icon_page_pre"]];
    [pageControl setDotImage:[UIImage imageNamed:@"res_PWGridView/icon_page_nor"]] ;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOnPageControl;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % (self.dataSource.count%8 ==0 ? self.dataSource.count/8:self.dataSource.count/8+1);
}
- (int)currentIndex
{
    int index = 0;
    index = (_collectionView.contentOffset.x + self.frame.size.width * 0.5) / self.frame.size.width;
    return MAX(0, index);
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[ItemContentCell class] forCellWithReuseIdentifier:@"ItemContentCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark ========== Delegate ==========
- (void)GridViewItemIndex:(NSInteger)index{
    
}

#pragma mark ========== UICollectionViewDataSource ==========
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.dataSource.count%8 ==0 ? self.dataSource.count/8:self.dataSource.count/8+1;
    return count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemContentCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"ItemContentCell" forIndexPath:indexPath];
    NSInteger cellCount = self.dataSource.count%8 == 0? self.dataSource.count/8:self.dataSource.count/8+1;
    NSInteger lastCount = self.dataSource.count%8 == 0? 8:self.dataSource.count%8;
    if (indexPath.row == cellCount-1) {
        cell.dataSource = [self.dataSource subarrayWithRange:NSMakeRange(indexPath.row*8, lastCount)];
    }else{
        cell.dataSource = [self.dataSource subarrayWithRange:NSMakeRange(indexPath.row*8, 8)];
    }
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
