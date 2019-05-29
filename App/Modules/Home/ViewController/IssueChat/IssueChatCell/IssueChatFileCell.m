//
//  IssueChatFileCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatFileCell.h"
@interface IssueChatFileCell ()
@property (nonatomic, strong) UIImageView *fileIcon;
@property (nonatomic, strong) UILabel *fileNameLab;
@end

@implementation IssueChatFileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
    UIColor *color;
    if (layout.message.messageFrom ==PWChatMessageFromSystem ) {
        color = PWBlueColor;
    }else{
        color = PWWhiteColor;
    }
    UIImage *image = [UIImage imageWithColor:color];
    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    self.mFileView = [[UIView alloc]init];
    self.mFileView.frame = layout.fileLabRect;
    self.mFileView.backgroundColor = PWWhiteColor;
    self.mBackImgButton.frame = layout.backImgButtonRect;
    self.mBackImgButton.layer.shadowOffset = CGSizeMake(0,6);
    self.mBackImgButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mBackImgButton.layer.shadowRadius = 8;
    self.mBackImgButton.layer.shadowOpacity = 0.06;
    self.mBackImgButton.userInteractionEnabled = YES;
    self.mBackImgButton.clipsToBounds = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fileTap)];
    [self.mFileView addGestureRecognizer:tap];
    [self.mBackImgButton addSubview:self.mFileView];
    UIImageView *fileIconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:layout.message.fileIcon]];
    fileIconImgView.tag = 22;
    [[self.mFileView viewWithTag:22] removeFromSuperview];
    [self.mFileView addSubview:fileIconImgView];
    fileIconImgView.contentMode = UIViewContentModeScaleAspectFill;
    [fileIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mFileView).offset(Interval(12));
        make.width.height.offset(ZOOM_SCALE(48));
        make.centerY.mas_equalTo(self.mFileView);
    }];
    UILabel *fileNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:layout.message.fileName];
    fileNameLab.tag =33;
    [[self.mFileView viewWithTag:33] removeFromSuperview];
    [self.mFileView addSubview:fileNameLab];
    [fileNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fileIconImgView.mas_right).offset(Interval(15));
        make.height.offset(ZOOM_SCALE(19));
        make.top.mas_equalTo(fileIconImgView);
        make.right.mas_equalTo(self.mFileView).offset(-5);
    }];
    UILabel *fileSizeLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:layout.message.fileSize];
    fileSizeLab.tag = 44;
    [[self.mFileView viewWithTag:44] removeFromSuperview];
    [self.mFileView addSubview:fileSizeLab];
    [fileSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fileNameLab);
        make.top.mas_equalTo(fileNameLab.mas_bottom).offset(Interval(3));
        make.height.offset(ZOOM_SCALE(16));
        make.right.mas_equalTo(self.mFileView).offset(-Interval(5));
    }];
}
-(void)fileTap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatFileCellClick:layout:)]){
        [self.delegate PWChatFileCellClick:self.indexPath layout:self.layout];
    }
}
- (void)buttonPressed:(UIButton *)button{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatFileCellClick:layout:)]){
        [self.delegate PWChatFileCellClick:self.indexPath layout:self.layout];
    }
}
-(UIImageView *)fileIcon{
    if (_fileIcon) {
        _fileIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    }
    return _fileIcon;
}
-(UILabel *)fileNameLab{
    if (!_fileNameLab) {
        _fileNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(14) textColor:PWTextBlackColor text:@""];
    }
    return _fileNameLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
