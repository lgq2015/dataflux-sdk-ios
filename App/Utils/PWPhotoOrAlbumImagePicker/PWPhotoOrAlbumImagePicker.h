//
//  PWPhotoOrAlbumImagePicker.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/19.
//  Copyright © 2018 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PWPhotoOrAlbumImagePickerBlock)(UIImage *image);
typedef void (^PWPhotoOrAlbumImageAndNameBlock)(UIImage *image,NSString *name);
typedef void (^PWFileOrImageBlock)(UIImage *image,NSString *name,BOOL isFile);
typedef void (^PWFileBlock)(NSData *file);

@interface PWPhotoOrAlbumImagePicker : NSObject
/**
 公共方法 选择图片后的图片回掉
 
 @param controller 使用这个工具的控制器
 @param photoBlock 选择图片后的回掉
 */
- (void)getPhotoAlbumOrTakeAPhotoWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock;
/**
 公共方法 选择图片或文件
 
 @param controller 使用这个工具的控制器
 @param photoBlock 选择图片后的回掉
 */
- (void)getPhotoAlbumOrTakeAPhotoOrFileWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock fileBlock:(PWFileBlock)fileBlock;

- (void)takeAPhotoWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImagePickerBlock)photoBlock;
- (void)getPhotoAlbumTakeAPhotoAndNameWithController:(UIViewController *)controller photoBlock:(PWPhotoOrAlbumImageAndNameBlock)photoAndNameBlock;
- (void)getFileOrPhotoAndNameWithController:(UIViewController *)controller fileOrPhoto:(PWFileOrImageBlock)fileOrImageBlock;
@end
