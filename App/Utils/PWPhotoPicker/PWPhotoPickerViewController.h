//
//  PWPhotoPickerViewController.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/5.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@class PWPhotoPickerViewController;
@protocol PWPhotoPickerProtocol <NSObject>
@optional
//选择完成
- (void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets;
- (void)photoPicker:(PWPhotoPickerViewController *)picker image:(UIImage *)image;

//点击选中
- (void)photoPicker:(PWPhotoPickerViewController *)picker didSelectAsset:(ALAsset*)asset;

//取消选中
- (void)photoPicker:(PWPhotoPickerViewController *)picker didDeselectAsset:(ALAsset*)asset;

//点击相机按钮相关操作
- (void)photoPickerTapCameraAction:(PWPhotoPickerViewController *)picker;

//取消
- (void)photoPickerDidCancel:(PWPhotoPickerViewController *)picker;

//超过最大选择项时
- (void)photoPickerDidMaximum:(PWPhotoPickerViewController *)picker;

//低于最低选择项时
- (void)photoPickerDidMinimum:(PWPhotoPickerViewController *)picker;

//选择过滤
- (void)photoPickerDidSelectionFilter:(PWPhotoPickerViewController *)picker;
@end
@interface PWPhotoPickerViewController : RootViewController
@property (weak, nonatomic) id<PWPhotoPickerProtocol> delegate;

//选择过滤
@property (nonatomic, strong) NSPredicate *selectionFilter;

//资源过滤
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

//选中的项
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

//最多选择项
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

//最少选择项
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;

//显示空相册
@property (nonatomic, assign) BOOL showEmptyGroups;

//是否开启多选
@property (nonatomic, assign) BOOL multipleSelection;

//是否加相机按钮
@property (nonatomic, assign) BOOL cameraAdd;

@end

