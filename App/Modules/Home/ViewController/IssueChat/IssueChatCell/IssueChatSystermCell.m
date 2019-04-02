//
//  IssueChatSystermCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/28.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatSystermCell.h"

@implementation IssueChatSystermCell
-(void)initPWChatCellUserInterface{
    self.mSystermLab.frame = self.layout.systermLabRect;
    self.mSystermLab.frame = CGRectMake(0, 5, self.layout.systermLabRect.size.width+20, self.layout.systermLabRect.size.height+10);
    self.mSystermLab.center = self.center;
    self.mSystermLab.text = self.layout.message.systermStr;
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
