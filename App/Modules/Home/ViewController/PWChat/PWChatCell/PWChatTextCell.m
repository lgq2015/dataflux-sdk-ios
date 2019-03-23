//
//  PWChatTextCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "PWChatTextCell.h"

@implementation PWChatTextCell
-(void)initPWChatCellUserInterface{
    [super initPWChatCellUserInterface];
    
    self.mTextView = [UITextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.font = MediumFONT(17);
    self.mTextView.textColor = PWTextBlackColor;
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.mBackImgButton addSubview:self.mTextView];
}

-(void)setLayout:(PWChatMessagelLayout *)layout{
    [super setLayout:layout];
    UIColor *color;
    if (layout.message.messageFrom ==PWChatMessageFromSystem ) {
        color = PWBlueColor;
    }else{
        color = PWWhiteColor;
    }
    UIImage *image = [UIImage imageWithColor:color];
    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.mBackImgButton.frame = layout.backImgButtonRect;
    [self.mBackImgButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.mTextView.frame = self.layout.textLabRect;
    self.mTextView.text = layout.message.textString;
    

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
