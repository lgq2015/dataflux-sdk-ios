//
//  PrivacySecurityControls.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/30.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PrivacySecurityControls.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PhotosDefines.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@implementation PrivacySecurityControls
- (NSInteger)getPrivacyStatusIsGrantedWithType:(PrivacyType)type controller:(UIViewController *)controller{
   
    NSString *tipTitle;
    NSString *tipMessage;
    NSString *goBtnTitle = NSLocalizedString(@"local.GoToOpen", @"");
    switch (type) {
        case PrivacyTypePHPhotoLibrary:
            tipTitle = NSLocalizedString(@"local.PleaseOpenPhotoAlbumPermissions", @"");
            tipMessage = NSLocalizedString(@"local.tip.OpenPhotoAlbumPermissionsTip", @"");
            break;
        case PrivacyTypeAVCaptureDevice:
            tipTitle = @"请开启相机权限";
            tipMessage= @"可依次进入[设置-隐私]中，允许访问相机";
            break;
        case PrivacyTypeUserNotification:
            tipTitle = @"开启通知权限";
            tipMessage= @"可依次进入[设置-隐私-通知]中，允许通知";
        default:
            break;
    }
    NSInteger cameragranted = 0 ;
    if(type == PrivacyTypeUserNotification){
        if ([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone)
        {
            
            
            //提示用户开启通知权限
            
        }
        else
        {
            tipTitle = @"关闭通知权限";
            tipMessage= @"可依次进入[设置-隐私-通知]中，关闭通知";
            goBtnTitle = @"去关闭";
        }
    }else{
    cameragranted = [self AVAuthorizationStatusIsGranted:type];
    }
   
    if (cameragranted == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tipTitle message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [PWCommonCtrl actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (self.refuseBlock) {
                self.refuseBlock();
            }
        }];
        UIAlertAction *comfirmAction = [PWCommonCtrl actionWithTitle:goBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        
        [alertController addAction:cancle];
        [alertController addAction:comfirmAction];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
    
    return cameragranted;
}
- (NSInteger)AVAuthorizationStatusIsGranted:(PrivacyType)type {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatusVedio = [AVCaptureDevice authorizationStatusForMediaType:mediaType];  // 相机授权
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];                         // 相册授权
    
    NSInteger authStatus = type == PrivacyTypePHPhotoLibrary ? authStatusAlbm:authStatusVedio;
    switch (authStatus) {
        case 0: { //第一次使用，则会弹出是否打开权限，如果用户第一次同意授权，直接执行再次调起
            if (type == PrivacyTypePHPhotoLibrary) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) { //授权成功
                        
                    }
                }];
            }else{
                [AVCaptureDevice requestAccessForMediaType : AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) { //授权成功
                      
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
@end
