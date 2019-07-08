//
//  LTSCalendarCollectionViewFlowLauout.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/9.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarCollectionViewFlowLayout.h"
#import "SectionBgNumberView.h"
#import "CanlendarBgLayoutAttributes.h"

NSString *const CalendarSectionBackground = @"CalendarSectionBackground";
NSString *const CalendarSectionNullBackground = @"CalendarSectionNullBackground";

@interface LTSCalendarCollectionViewFlowLayout()
@property (strong, nonatomic) NSMutableArray *allAttributes;
@end
@implementation LTSCalendarCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.SectionBgNumberViewAttrs = [NSMutableArray new];
    self.allAttributes = [NSMutableArray array];
    [self registerClass:[SectionBgNumberView class] forDecorationViewOfKind:CalendarSectionBackground];

    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++)
    {
        NSMutableArray * tmpArray = [NSMutableArray array];
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        
        for (NSUInteger j = 0; j<count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [tmpArray addObject:attributes];
        }
        
        [self.allAttributes addObject:tmpArray];
        id delegate = self.collectionView.delegate;
        if (!sections || ![delegate conformsToProtocol:@protocol(LTSCalendarCollectionViewFlowLayout)]) {
            return;
        }
        NSString *text = [delegate collectionView:self.collectionView layout:self backgroundTextForSection:i];
        
        if (![text isEqualToString:@""]) {
            UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:count - 1 inSection:i]];
            CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
            CanlendarBgLayoutAttributes *attr = [CanlendarBgLayoutAttributes layoutAttributesForDecorationViewOfKind:CalendarSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
            attr.frame = sectionFrame;
            attr.zIndex = -1;
            
            attr.bgText =text;
            [self.SectionBgNumberViewAttrs addObject:attr];
            
        }
      
    }
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    NSUInteger x;
    NSUInteger y;
    [self targetPositionWithItem:item resultX:&x resultY:&y];
    NSUInteger item2 = [self originItemAtX:x y:y];
    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];

    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
    theNewAttr.indexPath = indexPath;

    return theNewAttr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.SectionBgNumberViewAttrs) {
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    return attrs;
   
}



// 根据 item 计算目标item的位置
// x 横向偏移  y 竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item
                       resultX:(NSUInteger *)x
                       resultY:(NSUInteger *)y
{
    NSUInteger page = item/(self.itemCountPerRow*self.rowCount);
    
    NSUInteger theX = item % self.itemCountPerRow + page * self.itemCountPerRow;
    NSUInteger theY = item / self.itemCountPerRow - page * self.rowCount;
    if (x != NULL) {
        *x = theX;
    }
    if (y != NULL) {
        *y = theY;
    }
    
}

// 根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x
                          y:(NSUInteger)y
{
    NSUInteger item = x * self.rowCount + y;
    return item;
}

@end
