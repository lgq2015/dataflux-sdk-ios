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
    self.mSystermLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:@""];
    self.mSystermLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.mSystermLab];
    [self.mSystermLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
-(void)setLayout:(IssueChatMessagelLayout *)layout{
    self.mSystermLab.frame = layout.systermLabRect;
    self.mSystermLab.text = layout.message.systermStr;

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
