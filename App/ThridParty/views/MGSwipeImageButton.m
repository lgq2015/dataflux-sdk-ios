//
// Created by Brandon on 2018/6/14.
// Copyright (c) 2018 MYT. All rights reserved.
//

#import "MGSwipeImageButton.h"
#import "MGSwipeTableCell.h"

static CGFloat const ImageSize = 40;

@interface MGSwipeImageButton ()

@property(nonatomic, strong) NSString *imagePath;
@property(nonatomic) CGFloat imageWidth;
@property(nonatomic, strong) UIColor *bgColor;

@end

@implementation MGSwipeImageButton {

}
- (instancetype)initWithImagePath:(NSString *)imagePath imageWidth:(CGFloat)imageWidth bgColor:(UIColor *)bgColor callBack:(MGSwipeButtonCallback)callback {
    self = [super initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    if (self) {
        _imagePath = imagePath;
        _imageWidth = imageWidth;
        _bgColor = bgColor;
        _callback = callback;
        [self setUpView];
    }


    return self;
}

- (void)setUpView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:_imagePath]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    imageView.frame = CGRectMake((_imageWidth - ImageSize) / 2, (_imageWidth - ImageSize) / 2, ImageSize, ImageSize);
    self.backgroundColor = _bgColor;

    [self addSubview:imageView];
}

-(BOOL) callMGSwipeConvenienceCallback: (MGSwipeTableCell *) sender
{
    if (_callback) {
        return _callback(sender);
    }
    return NO;
}



@end
