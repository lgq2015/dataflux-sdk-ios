//
//  PWDraggableItem.h
//  
//
//  Created by 胡蕾蕾 on 2018/9/12.
//  Copyright © 2018年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryModel.h"


typedef void (^DisplayBlock)(NSInteger index);
@class PWDraggableItem;

@protocol PWDraggableItemDelegate <NSObject>

/**
 *  @brief  通知父视图button的排列顺序发生了改变
 *
 *  @param dragButton  按钮位置已经改变button
 *  @param dragButtons 新排列的button数组
 */
- (void)dragButton:(PWDraggableItem *)dragButton dragButtons:(NSArray *)dragButtons startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
/**
 *  @param point 拖拽的item在scrollview的当前位置 让父视图来调整contentOffset
 */
- (void)dragCenter:(CGPoint)point;
@end
@interface PWDraggableItem : UIView
/**
 *  代理方法
 */
@property (nonatomic, weak) id<PWDraggableItemDelegate> delegate;

/**
 *  存放需要拖拽的按钮数组
 */
@property (nonatomic, strong) NSMutableArray *btnArray;

/**
 *  一排按钮的个数， 如使用openDisplayView方法，linecout不能为空
 */
@property (nonatomic, assign) NSUInteger lineCount;
@property (nonatomic, strong) UILabel *upTitleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIImageView *iconImgVie;
@property (nonatomic, strong) LibraryModel *model;
@property (nonatomic, copy) DisplayBlock clickBlock;

@end
