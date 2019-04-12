//
//  PWPhotoOrAlbumImagePicker.m
//  App
//
//  Created by 胡蕾蕾 on 2018/12/19.
//  Copyright © 2018 hll. All rights reserved.
//

#import "PWPhotoOrAlbumImagePicker.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PhotosDefines.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface PWPhotoOrAlbumImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,copy) PWPhotoOrAlbumImagePickerBlock photoBlock;   //-> 回掉
@property (nonatomic,copy) PWFileBlock fileBlock;
@property (nonatomic, copy) PWPhotoOrAlbumImageAndNameBlock nameBlock;
@property (nonatomic,strong) UIImagePickerController *picker; //-> 多媒体选择控制器
@property (nonatomic,weak) UIViewController  *viewController; //-> 一定是weak 避免循环引用
@property (nonatomic,assign) NSInteger sourceType;            //-> 媒体来源 （相册/相机）
@end
@implementation PWPhotoOrAlbumImagePicker
#pragma mark - 初始化
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)takeAPhotoWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock{
    self.photoBlock = photoBlock;
    self.viewController = controller;
      [self getAlertActionType:2];
}
- (void)getPhotoAlbumTakeAPhotoAndNameWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImageAndNameBlock)photoAndNameBlock{
    self.nameBlock = photoAndNameBlock;
    self.viewController = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAlbumAction = [PWCommonCtrl actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:1];
    }];
    
    UIAlertAction *cemeraAction = [PWCommonCtrl actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:2];
    }];
    
    UIAlertAction *cancleAction = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    // 判断是否支持拍照
    [self imagePickerControlerIsAvailabelToCamera] ? [alertController addAction:cemeraAction]:nil;
    [alertController addAction:photoAlbumAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}


- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock{
    self.photoBlock = photoBlock;
    self.viewController = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAlbumAction = [PWCommonCtrl actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:1];
    }];

    UIAlertAction *cemeraAction = [PWCommonCtrl actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:2];
    }];
   
    UIAlertAction *cancleAction = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    // 判断是否支持拍照
    [self imagePickerControlerIsAvailabelToCamera] ? [alertController addAction:cemeraAction]:nil;
    [alertController addAction:photoAlbumAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)getPhotoAlbumOrTakeAPhotoOrFileWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock fileBlock:(PWFileBlock)fileBlock{
    self.photoBlock = photoBlock;
    self.viewController = controller;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAlbumAction = [PWCommonCtrl actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:1];
    }];
    
    UIAlertAction *cemeraAction = [PWCommonCtrl actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getAlertActionType:2];
    }];
    UIAlertAction *fileAction = [PWCommonCtrl actionWithTitle:@"文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *cancleAction = [PWCommonCtrl actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancleAction];
    // 判断是否支持拍照
    [self imagePickerControlerIsAvailabelToCamera] ? [alertController addAction:cemeraAction]:nil;
    [alertController addAction:photoAlbumAction];
    [alertController addAction:fileAction];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

/**
 UIAlertController 点击事件 确定选择的媒体来源（相册/相机）
 
 @param type 点击的类型
 */
- (void)getAlertActionType:(NSInteger)type {
    NSInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (type == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if (type ==2){
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self creatUIImagePickerControllerWithAlertActionType:sourceType];
}



/**
 点击事件出发的方法
 
 @param type 媒体库来源 （相册/相机）
 */
- (void)creatUIImagePickerControllerWithAlertActionType:(NSInteger)type {
    self.sourceType = type;
    // 获取不同媒体类型下的授权类型
    NSInteger cameragranted = [self AVAuthorizationStatusIsGranted];
    // 如果确定未授权 cameragranted ==0 弹框提示；如果确定已经授权 cameragranted == 1；如果第一次触发授权 cameragranted == 2，这里不处理
    NSString *tipTitle = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary? @"请开启照片权限":@"请开启相机权限";
    NSString *tipMessage = type == 2?@"可依次进入[设置-隐私-照片]，允许访问手机相册":@"可依次进入[设置-隐私]中，允许访问相机";
    if (cameragranted == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tipTitle message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *comfirmAction = [PWCommonCtrl actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
       
        [alertController addAction:cancle];
        [alertController addAction:comfirmAction];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else if (cameragranted == 1) {
        [self presentPickerViewController];
    }
}


// 判断硬件是否支持拍照
- (BOOL)imagePickerControlerIsAvailabelToCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 照机/相册 授权判断
- (NSInteger)AVAuthorizationStatusIsGranted  {
    __weak typeof(self) weakSelf = self;
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];  // 相机授权
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];                         // 相册授权
    NSInteger authStatus = self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? authStatusAlbm:authStatusVedio;
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限，如果用户第一次同意授权，直接执行再次调起
            if (self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }else{
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { //授权成功
                        [weakSelf presentPickerViewController];
                    }
                }];
            }
        }
            return 2;   //-> 不提示
        case 1: return 0; //-> 还未授权
        case 2: return 0; //-> 主动拒绝授权
        case 3: return 1; //-> 已授权
        default:return 0;
    }
}


/**
 如果第一次访问用户是否是授权，如果用户同意 直接再次执行
 */
-(void)presentPickerViewController{
    self.picker = [[UIImagePickerController alloc] init];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;          //-> 是否允许选取的图片可以裁剪编辑
    self.picker.sourceType = self.sourceType; //-> 媒体来源（相册/相机）
    [self.viewController presentViewController:self.picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
// 点击完成按钮的选取图片的回掉
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 获取编辑后的图片
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL *name = [info objectForKey:UIImagePickerControllerReferenceURL];
    __block NSString *filename;
    if(self.sourceType == 2){
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        filename = [representation filename];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:name resultBlock:resultblock failureBlock:nil];
    }
    // 如果裁剪的图片不符合标准 就会为空，直接使用原图
    image == nil    ?  image = [info objectForKey:UIImagePickerControllerOriginalImage] : nil;
   
    [picker dismissViewControllerAnimated:YES completion:^{
         self.photoBlock ?  self.photoBlock(image): nil;
        self.nameBlock ? self.nameBlock(image,filename):nil;
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 这个部分代码 视情况而定
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:PWOrangeTextColor, NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
}
@end
