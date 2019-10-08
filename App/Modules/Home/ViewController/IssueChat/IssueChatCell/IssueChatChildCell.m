//
//  IssueChatChildCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/10/8.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatChildCell.h"

@implementation IssueChatChildCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
    UIColor *color = [UIColor colorWithHexString:@"#F5F7FF"];
    
    UIImage *image = [UIImage imageWithColor:color];
    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    self.mFileView = [[UIView alloc]init];
    self.mFileView.frame = CGRectMake(0, 0, kWidth-layout.nameLabRect.origin.x-Interval(16), ZOOM_SCALE(39));
    self.mFileView.backgroundColor = color;
    self.mBackImgButton.frame = CGRectMake(layout.nameLabRect.origin.x, layout.nameLabRect.origin.y+layout.nameLabRect.size.height+Interval(4), kWidth-layout.nameLabRect.origin.x-Interval(16), ZOOM_SCALE(39));
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fileTap)];
    [self.mFileView addGestureRecognizer:tap];
    [self.mBackImgButton addSubview:self.mFileView];
    UIImageView *fileIconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"relatedInfo"]];
    fileIconImgView.tag = 22;
    [[self.mFileView viewWithTag:22] removeFromSuperview];
    [self.mFileView addSubview:fileIconImgView];
    fileIconImgView.contentMode = UIViewContentModeScaleAspectFill;
    [fileIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mFileView).offset(Interval(12));
        make.width.height.offset(ZOOM_SCALE(18));
        make.centerY.mas_equalTo(self.mFileView);
    }];
    UILabel *fileNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:[UIColor colorWithHexString:@"#333333"] text:layout.message.textString.string];
    fileNameLab.tag =33;
    [[self.mFileView viewWithTag:33] removeFromSuperview];
    [self.mFileView addSubview:fileNameLab];
    [fileNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fileIconImgView.mas_right).offset(Interval(8));
        make.height.offset(ZOOM_SCALE(20));
        make.centerY.mas_equalTo(fileIconImgView);
        make.right.mas_equalTo(self.mFileView).offset(-5);
    }];

}
-(void)fileTap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatChildCellClick:layout:)]){
        [self.delegate PWChatChildCellClick:self.indexPath layout:self.layout];
    }
}
- (void)buttonPressed:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatChildCellClick:layout:)]){
        [self.delegate PWChatChildCellClick:self.indexPath layout:self.layout];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
