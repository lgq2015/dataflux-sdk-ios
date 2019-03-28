//
//  PWChatMessagelLayout.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatMessagelLayout.h"

@implementation PWChatMessagelLayout
//根据模型返回布局
-(instancetype)initWithMessage:(PWChatMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}
-(void)setMessage:(PWChatMessage *)message{
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
//    UILabel *nameLab = [PWCommonCtrl lableWithFrame:CGRectMake(0, 0, kWidth, 20) font:MediumFONT(12) textColor:PWWhiteColor text:_message.nameStr];
//    [nameLab sizeToFit];
//    _nameLabRect = nameLab.bounds;
    UITextView *mTextView = [UITextView new];
    mTextView.bounds = CGRectMake(0, ZOOM_SCALE(16)+8, PWChatTextInitWidth, 100);
    mTextView.font = MediumFONT(17);
    mTextView.text = _message.textString;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
     _textLabRect = mTextView.bounds;
    CGFloat textWidth  = _textLabRect.size.width;
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect), textWidth+PWChatTextLRB+PWChatTextLRS, textHeight+PWChatTextTop+PWChatTextBottom);
        
         _imageInsets = UIEdgeInsetsMake(PWChatAirTop, 0, PWChatAirBottom, 0);
        
        _textLabRect.origin.x = PWChatTextLRB;
        _textLabRect.origin.y = PWChatTextTop;
        
    }else{
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconRight-PWChatIconWH, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatDetailRight-PWChatTextLRB-textWidth-PWChatTextLRS, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect), textWidth+PWChatTextLRB+PWChatTextLRS, textHeight+PWChatTextTop+PWChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, 0, PWChatAirBottom, 0);
        
        _textLabRect.origin.x = PWChatTextLRS;
        _textLabRect.origin.y = PWChatTextTop;
    }
    

    _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + PWChatCellBottom;
    
}
- (void)setImage{
    UIImage *image = _message.image;
    CGFloat imgWidth  = CGImageGetWidth(image.CGImage);
    CGFloat imgHeight = CGImageGetHeight(image.CGImage);
    CGFloat imgActualHeight = PWChatImageMaxSize;
    CGFloat imgActualWidth =  PWChatImageMaxSize * imgWidth/imgHeight;
    
    _message.contentMode =  UIViewContentModeScaleAspectFit;
    
    if(imgActualWidth>PWChatImageMaxSize){
        imgActualWidth = PWChatImageMaxSize;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    if(imgActualWidth<PWChatImageMaxSize*0.25){
        imgActualWidth = PWChatImageMaxSize * 0.25;
        imgActualHeight = PWChatImageMaxSize * 0.8;
        _message.contentMode =  UIViewContentModeScaleAspectFill;
    }
    
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRB, PWChatAirBottom, PWChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconRight-PWChatIconWH, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatDetailRight-imgActualWidth, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRS, PWChatAirBottom, PWChatAirLRB);
    }
      _cellHeight = _backImgButtonRect.size.height + _backImgButtonRect.origin.y + PWChatCellBottom;
}
- (void)setFile{
    if(_message.messageFrom == PWChatMessageFromOther){
        _headerImgRect = CGRectMake(PWChatIconLeft,PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIconLeft+PWChatIconWH+PWChatIconRight, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, PWChatFileWidth+PWChatTextLRB+PWChatTextLRS, PWChatFileHeight+PWChatTextTop+PWChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRB, PWChatAirBottom, PWChatAirLRS);
        
        _fileLabRect.origin.x = PWChatTextLRB;
        _fileLabRect.origin.y = PWChatTextTop;
        
    }else{
        _headerImgRect = CGRectMake(PWChatIcon_RX, PWChatCellTop, PWChatIconWH, PWChatIconWH);
        _nameLabRect = CGRectMake(PWChatIcon_RX-PWChatIconRight, self.headerImgRect.origin.y, kWidth-80, ZOOM_SCALE(16));
        _backImgButtonRect = CGRectMake(PWChatIcon_RX-PWChatDetailRight-PWChatTextLRB-PWChatFileWidth-PWChatTextLRS, self.headerImgRect.origin.y+CGRectGetMaxY(_nameLabRect)+8, PWChatFileWidth+PWChatTextLRB+PWChatTextLRS, PWChatFileHeight+PWChatTextTop+PWChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(PWChatAirTop, PWChatAirLRS, PWChatAirBottom, PWChatAirLRB);
        
        _textLabRect.origin.x = PWChatTextLRS;
        _textLabRect.origin.y = PWChatTextTop;
    }
}
- (void)setSysterm{
    
}
@end
