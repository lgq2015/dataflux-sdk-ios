//
//  LTSCalendarCollectionViewFlowLauout.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/9.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LTSCalendarCollectionViewFlowLayout <UICollectionViewDelegateFlowLayout>

- (NSString *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundTextForSection:(NSInteger)section;

@end
@interface LTSCalendarCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) NSUInteger itemCountPerRow;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *SectionBgNumberViewAttrs;
//    一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
