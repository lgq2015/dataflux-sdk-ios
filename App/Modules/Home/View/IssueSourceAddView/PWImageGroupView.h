//
//  PWImageGroupView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWImageGroupItem.h"


NS_ASSUME_NONNULL_BEGIN
/**
 图片视图的cell
 */

@protocol PWImageGroupCellDelegate <NSObject>

//点击图片
-(void)PWImageGroupCellImageClick:(NSInteger)index gesture:(UITapGestureRecognizer *)gesture;

@end
@interface PWImageGroupCell : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,assign)id<PWImageGroupCellDelegate>imageCelldelegate;

//初始化cell
-(instancetype)initWithItem:(PWImageGroupItem *)item;
//设置frame
@property(nonatomic,assign)CGRect imageCellFrame;
//展示单位
@property(nonatomic,strong)PWImageGroupItem *item;
//展示图
@property(nonatomic,strong)UIImageView   *mImageView;


@end
/**
 图片展示视图
 */
typedef void (^PWImageDismissBlock)(void);
@interface PWImageGroupView : UIView<UIScrollViewDelegate,PWImageGroupCellDelegate>

-(instancetype)initWithGroupItems:(NSArray *)groupItems currentIndex:(NSInteger)currentIndex;

@property(nonatomic,assign)CGFloat           height;
@property(nonatomic,assign)CGFloat           width;

//展示图数组
@property(nonatomic,strong)NSArray           *groupItems;
//当前展示的视图
@property(nonatomic,assign)NSInteger         currentIndex;
@property(nonatomic,assign)PWImageGroupItem  *currentItem;
@property(nonatomic,strong)UIImageView       *fromImgView;
//分页控制器
@property(nonatomic,assign)NSInteger         currentPage;
@property(nonatomic,strong)UIPageControl     *mPageController;
//第一张展示图
@property(nonatomic,strong)UIImageView       *fristImgView;

//半透明背景图
@property(nonatomic,strong)UIView            *backView;
//图片数组滚动视图
@property(nonatomic,strong)UIScrollView      *mScrollView;
//关闭当前视图
@property(nonatomic,copy)PWImageDismissBlock dismissBlock;

//屏幕是否正在旋转 旋转过程中滚动视图不能进行位移
@property(nonatomic,assign)BOOL              deviceTransform;
//屏幕在一定情况下不需要处理旋转操作
@property(nonatomic,assign)UIDeviceOrientation  deviceOrientation;
@end

NS_ASSUME_NONNULL_END
