//
//  PWPhotoOrAlbumImagePicker.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/19.
//  Copyright © 2018 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PWPhotoOrAlbumImagePickerBlock)(UIImage *image);
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
@end
