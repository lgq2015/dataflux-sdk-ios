//
// Created by Brandon on 2018/6/14.
// Copyright (c) 2018 MYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MGSwipeTableCell;


@interface MGSwipeImageButton : UIView

typedef BOOL(^ MGSwipeButtonCallback)(MGSwipeTableCell * _Nonnull cell);
@property (nonatomic, strong, nullable) MGSwipeButtonCallback callback;
@property (nonatomic) NSInteger btnIndex;

- (instancetype)initWithImagePath:(NSString *)imagePath imageWidth:(CGFloat)imageWidth bgColor:(UIColor *)bgColor callBack:(nullable MGSwipeButtonCallback) callback;

-(BOOL) callMGSwipeConvenienceCallback: (MGSwipeTableCell *) sender;
@end
