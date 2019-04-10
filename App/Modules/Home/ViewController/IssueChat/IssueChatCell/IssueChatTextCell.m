//
//  IssueChatTextCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatTextCell.h"

@implementation IssueChatTextCell
-(void)initPWChatCellUserInterface{
    [super initPWChatCellUserInterface];
    
    self.mTextView = [UITextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.font = RegularFONT(17);
    self.mTextView.textColor = PWTextBlackColor;
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.mBackImgButton addSubview:self.mTextView];
}

-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
    UIColor *color;
    if (layout.message.messageFrom ==PWChatMessageFromStaff) {
        color = RGBACOLOR(78, 135, 252, 1);
    }else{
        color = PWWhiteColor;
    }
    UIImage *image = [UIImage imageWithColor:color];
    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.mBackImgButton.frame = layout.backImgButtonRect;
    [self.mBackImgButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.mTextView.frame = self.layout.textLabRect;
    self.mTextView.text = layout.message.textString;
    self.mTextView.textColor = layout.message.textColor;
    self.mIndicator.hidden = YES;
    self.retryBtn.hidden = YES;
    if (layout.message.isSend && !layout.message.sendError) {
        [self.mIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mBackImgButton);
            make.right.mas_equalTo(self.mBackImgButton.mas_left).offset(-5);
        }];
        self.mIndicator.hidden = NO;
        self.mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.mIndicator startAnimating];
    }else if(layout.message.isSend && layout.message.sendError){
        [self.retryBtn setImage:[UIImage imageNamed:@"send_error"] forState:UIControlStateNormal];
//        [_retryBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mBackImgButton);
            make.right.mas_equalTo(self.mBackImgButton.mas_left).offset(-5);
            make.width.height.offset(ZOOM_SCALE(30));
        }];
        self.retryBtn.hidden = NO;
    }
}
-(void)showIndicator{
    [self.mIndicator startAnimating];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
