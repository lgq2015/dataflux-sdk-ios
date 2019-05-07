//
//  IssueChatMessagelLayout.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatMessagelLayout.h"

@implementation IssueChatMessagelLayout
//根据模型返回布局
-(instancetype)initWithMessage:(IssueChatMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}
-(void)setMessage:(IssueChatMessage *)message{
    _message = message;
    
    switch (_message.messageType ) {
      case PWChatMessageTypeFile:
           [self setFile];
            break;
      case PWChatMessageTypeText:
           [self setText];
            break;
      case PWChatMessageTypeImage:
           [self setImage];
            break;
     case PWChatMessageTypeSysterm:
            [self setSysterm];
            break;
    }
    
}
- (void)setText{
    UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, 20) font:RegularFONT(12) textColor:PWWhiteColor text:_message.nameStr];
    [nameLab sizeToFit];
    _nameLabRect = nameLab.bounds;
    CGFloat nameWidth  = _nameLabRect.size.width;
    
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, ZOOM_SCALE(16)+8, PWChatTextInitWidth, 100);
    mTextView.font = RegularFONT(17);
    mTextView.text = _message.textString;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
     _textLabRect = mTextView.bounds;
    CGFloat textWidth  = _textLabRect.size.width;
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_nameLabRect)+8, textWidth+PWChatTextLRB+PWChatTextLRS, textHeight+PWChatTextTop+PWChatTextBottom);
        
         _imageInsets = UIEdgeInsetsMake(PWChatAirTop, 0, PWChatAirBottom, 0);
        
        _textLabRect.origin.x = PWChatTextLRB;
        _textLabRect.origin.y = PWChatTextTop;
        
    }else if(_message.messageFrom == PWChatMessageFromMe){
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconLeft-nameWidth, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatDetailRight-PWChatTextLRB-textWidth-PWChatTextLRS, CGRectGetMaxY(_nameLabRect)+8, textWidth+PWChatTextLRB+PWChatTextLRS, textHeight+PWChatTextTop+PWChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, 0, PWChatAirBottom, 0);
        
        _textLabRect.origin.x = PWChatTextLRS;
        _textLabRect.origin.y = PWChatTextTop;
    }else if(_message.messageFrom == PWChatMessageFromStaff){
        _expertLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));

        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_expertLabRect), kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, textWidth+PWChatTextLRB+PWChatTextLRS, textHeight+PWChatTextTop+PWChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, 0, PWChatAirBottom, 0);

        _textLabRect.origin.x = PWChatTextLRB;
        _textLabRect.origin.y = PWChatTextTop;

        
    }
    

    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + PWChatCellBottom;
    
}
- (void)setImage{
//   __block CGFloat imgActualHeight;
//  __block  CGFloat imgActualWidth;
//    if (_message.image) {
//        UIImage *image = _message.image;
//        CGFloat imgWidth  = CGImageGetWidth(image.CGImage);
//        CGFloat imgHeight = CGImageGetHeight(image.CGImage);
//         imgActualHeight = PWChatImageMaxSize;
//         imgActualWidth =  PWChatImageMaxSize * imgWidth/imgHeight;
//        [self setImageWidth:imgActualWidth Height:imgActualHeight];
//    }else{
//        UIImageView *imageView = [[UIImageView alloc]init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:_message.imageString] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            NSLog(@"宽：%f, 高：%f", image.size.width, image.size.height);
//            imgActualHeight = PWChatImageMaxSize;
//            imgActualWidth =  PWChatImageMaxSize * image.size.width/image.size.height;
//            [self setImageWidth:image.size.width Height:image.size.height];
//        }];
//    }
    [self setImageWidth:ZOOM_SCALE(140) Height:ZOOM_SCALE(102)];

    
}
-(void)setImageWidth:(CGFloat)imgActualWidth Height:(CGFloat)imgActualHeight{
    UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, 20) font:RegularFONT(12) textColor:PWWhiteColor text:_message.nameStr];
    [nameLab sizeToFit];
    _nameLabRect = nameLab.bounds;
    CGFloat nameWidth  = _nameLabRect.size.width;
    _message.contentMode =  UIViewContentModeScaleAspectFit;
    
    
    if(imgActualWidth<PWChatImageMaxSize*0.25){
        imgActualWidth = PWChatImageMaxSize * 0.25;
        imgActualHeight = PWChatImageMaxSize * 0.8;
        _message.contentMode =  UIViewContentModeScaleAspectFill;
    }
    
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_nameLabRect)+8, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRB, PWChatAirBottom, PWChatAirLRS);
        
    }else if(_message.messageFrom == PWChatMessageFromMe){
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconRight-nameWidth, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatDetailRight-imgActualWidth, CGRectGetMaxY(_nameLabRect)+8, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRS, PWChatAirBottom, PWChatAirLRB);
    }else if(_message.messageFrom == PWChatMessageFromStaff){
        _expertLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));

        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_expertLabRect), kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRB, PWChatAirBottom, PWChatAirLRS);
        
        
    }
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + PWChatCellBottom;
}
- (void)setFile{
    
    UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, 20) font:RegularFONT(12) textColor:PWWhiteColor text:_message.nameStr];
    [nameLab sizeToFit];
    _nameLabRect = nameLab.bounds;
    CGFloat nameWidth  = _nameLabRect.size.width;
    _message.contentMode =  UIViewContentModeScaleAspectFit;
    _fileLabRect = CGRectMake(0, 0,PWChatFileWidth , PWChatFileHeight);
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_nameLabRect)+8, PWChatFileWidth, PWChatFileHeight);
    
    }else if(_message.messageFrom == PWChatMessageFromMe){
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconRight-nameWidth, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
         _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatFileWidth-PWChatDetailRight, CGRectGetMaxY(_nameLabRect)+8, PWChatFileWidth, PWChatFileHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRS, PWChatAirBottom, PWChatAirLRB);
        
        _textLabRect.origin.x = PWChatTextLRS;
        _textLabRect.origin.y = PWChatTextTop;
    }else if(_message.messageFrom == PWChatMessageFromStaff){
       
        _expertLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_expertLabRect)+8, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, CGRectGetMaxY(_nameLabRect)+8, PWChatFileWidth, PWChatFileHeight);
        
    }
    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + PWChatCellBottom;

}
- (void)setSysterm{
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, ZOOM_SCALE(16)+8, PWChatTextInitWidth, 100);
    mTextView.font = RegularFONT(17);
    mTextView.text = _message.systermStr;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
    _systermLabRect = mTextView.bounds;
    _cellHeight = _systermLabRect.size.height;
    if ([_message.systermStr isEqualToString:@"在这里讨论该情报"]) {
        _cellHeight = _systermLabRect.size.height+Interval(28);

    }
}
@end
