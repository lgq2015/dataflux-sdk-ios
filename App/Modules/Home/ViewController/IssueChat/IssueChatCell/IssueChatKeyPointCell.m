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
   
}
-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
//    if(layout.cellHeight>ZOOM_SCALE(60)){
//        self.contentView.backgroundColor = PWRedColor;
//        CGRect backViewFrame =CGRectMake(Interval(16), ZOOM_SCALE(10), kWidth-Interval(32), layout.cellHeight-ZOOM_SCALE(20));
//    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(Interval(16), ZOOM_SCALE(10), kWidth-Interval(32),layout.cellHeight-ZOOM_SCALE(20))];
    backView.backgroundColor =[UIColor colorWithHexString:@"#F5F7FF"];
    backView.tag = 55;
    [[self.contentView viewWithTag:55] removeFromSuperview];
    [self.contentView addSubview:backView];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tag"]];
    icon.frame = CGRectMake(Interval(22), (backView.height-ZOOM_SCALE(16))/2.0, ZOOM_SCALE(16), ZOOM_SCALE(16));
    icon.tag = 56;
    [backView addSubview:icon];
    self.mSystermLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#2A7AF7"] text:@""];
    self.mSystermLab.numberOfLines = 0;
    self.mSystermLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:self.mSystermLab];
    UILabel *timeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#979797"] text:layout.message.nameStr];
    [backView addSubview:timeLab];
    self.mSystermLab.text = layout.message.stuffName;

    if (layout.cellHeight>ZOOM_SCALE(60)) {
        self.mSystermLab.frame = CGRectMake(Interval(32)+ZOOM_SCALE(16), 0, layout.textLabRect.size.width, layout.cellHeight-ZOOM_SCALE(20));
       
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backView).offset(-10);
//            make.width.offset(layout.nameLabRect.size.width);
            make.height.centerY.mas_equalTo(self.mSystermLab);
        }];
    }else{
   
    self.mSystermLab.frame = CGRectMake(Interval(32)+ZOOM_SCALE(16), 0, layout.textLabRect.size.width, layout.cellHeight-ZOOM_SCALE(20));
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mSystermLab.mas_right).offset(10);
        make.height.centerY.mas_equalTo(self.mSystermLab);
    }];
    }
//    NSString *text = [NSString stringWithFormat:@"%@  %@",layout.message.stuffName,layout.message.nameStr];
//      NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
//    if(!layout.message.stuffName||[layout.message.stuffName isKindOfClass:NSNull.class]){
//
//    }else if(layout.message.stuffName && layout.message.stuffName.length>0){
//        NSRange range = [text rangeOfString:layout.message.stuffName];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2A7AF7"] range:range];
//    }
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
