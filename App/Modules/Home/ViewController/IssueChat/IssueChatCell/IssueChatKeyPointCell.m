//
//  IssueChatKeyPointCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/5/16.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatKeyPointCell.h"

@implementation IssueChatKeyPointCell
-(void)initPWChatCellUserInterface{
    self.contentView.backgroundColor = PWWhiteColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(10), kWidth-Interval(32), ZOOM_SCALE(40))];
    backView.backgroundColor =[UIColor colorWithHexString:@"#F5F7FF"];
    [self.contentView addSubview:backView];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tag"]];
    icon.frame = CGRectMake(Interval(22), ZOOM_SCALE(12), ZOOM_SCALE(16), ZOOM_SCALE(16));
    [backView addSubview:icon];
    self.mSystermLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#979797"] text:@""];
    self.mSystermLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:self.mSystermLab];
    [self.mSystermLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(backView);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(icon.mas_right).offset(10);
    }];
}
-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
    NSString *text = [NSString stringWithFormat:@"%@  %@",layout.message.stuffName,layout.message.nameStr];
      NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    if(!layout.message.stuffName||[layout.message.stuffName isKindOfClass:NSNull.class]){
        
    }else if(layout.message.stuffName && layout.message.stuffName.length>0){
        NSRange range = [text rangeOfString:layout.message.stuffName];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2A7AF7"] range:range];
    }
    self.mSystermLab.attributedText = str;
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
