//
//  PWImageGroupItem.h
//  App
//
//  Created by 胡蕾蕾 on 2019/4/11.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 展示图类型
 
 - SSImageGroupImage: 图片
 - SSImageGroupVideo: 短视频
 */
typedef NS_ENUM(NSInteger, PWImageGroupType) {
    PWImageGroupImage = 1,
    PWImageGroupVideo,
};

/**
 图片展示状态
 
 - PWImageShowValue1: 未展示
 - PWImageShowValue2: 放大展示
 - PWImageShowValue3: 滚动展示
 - PWImageShowValue4: 滚动隐藏
 */
typedef NS_ENUM(NSInteger, PWImageShowType) {
    PWImageShowValue1 = 1,
    PWImageShowValue2,
    PWImageShowValue3,
    PWImageShowValue4,
};
NS_ASSUME_NONNULL_BEGIN

@interface PWImageGroupItem : NSObject
//图类型
@property(nonatomic, assign) PWImageGroupType  imageType;

//需要展示的图片 图片视图
@property(nonatomic, strong) UIImage      *fromImage;
@property(nonatomic, strong) NSString      *fromImageStr;

@property(nonatomic, strong) UIImageView  *fromImgView;

//图片格式
@property(nonatomic, assign) UIViewContentMode contentMode;

//短视频路径
@property(nonatomic, strong)NSString  *videoPath;

//标签
@property(nonatomic, assign)NSInteger  itemTag;
@end

NS_ASSUME_NONNULL_END
