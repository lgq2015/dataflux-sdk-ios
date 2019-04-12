//
//  IssueChatImageCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatImageCell.h"

@implementation IssueChatImageCell
-(void)initPWChatCellUserInterface{
    
    [super initPWChatCellUserInterface];
    
    self.mImgView = [UIImageView new];
    self.mImgView.layer.cornerRadius = 5;
    self.mImgView.layer.masksToBounds  = YES;
    self.mImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.mImgView.backgroundColor = [UIColor whiteColor];
    [self.mBackImgButton addSubview:self.mImgView];
    
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
    self.mBackImgButton.frame = layout.backImgButtonRect;
    [self.mBackImgButton setBackgroundImage:image forState:UIControlStateNormal];
    
    
    self.mImgView.frame = self.mBackImgButton.bounds;
    [self.mImgView sd_setImageWithURL:[NSURL URLWithString:layout.message.imageString]];
    self.mImgView.contentMode = self.layout.message.contentMode;
    
    
    //给图片设置一个描边 描边跟背景按钮的气泡图片一样
    UIImageView *btnImgView = [[UIImageView alloc]initWithImage:image];
    btnImgView.frame = CGRectInset(self.mImgView.frame, 0.0f, 0.0f);
    self.mImgView.layer.mask = btnImgView.layer;
    if (layout.message.image) {
        self.mImgView.image = layout.message.image;
    }
    self.mIndicator.hidden = YES;
    self.sendLab.hidden = YES;
    self.retryBtn.hidden = YES;
    if (layout.message.isSend && !layout.message.sendError) {
        [self.mIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mBackImgButton);
            make.centerY.mas_equalTo(self.mBackImgButton.centerY).offset(-10);
        }];
        self.mIndicator.hidden = NO;
        self.sendLab.hidden = NO;
        [self.sendLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mIndicator.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.mIndicator);
        }];
        self.mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.mIndicator startAnimating];
    }else if(layout.message.isSend && layout.message.sendError){
         self.retryBtn.hidden = NO;
        [self.retryBtn setImage:[UIImage imageNamed:@"send_error"] forState:UIControlStateNormal];
//        [self.retryBtn setTitle:@"重新发送" forState:UIControlStateNormal];
//        CGFloat offset = 10;
//        self.retryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.retryBtn.imageView.frame.size.width, -self.retryBtn.imageView.frame.size.height-offset/2, 0);
//        self.retryBtn.imageEdgeInsets = UIEdgeInsetsMake(-self.retryBtn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -self.retryBtn.titleLabel.intrinsicContentSize.width);
        [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.mBackImgButton);
            make.width.height.offset(ZOOM_SCALE(30));
        }];
        self.retryBtn.hidden = NO;
    }
}


//点击展开图片
-(void)buttonPressed:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatImageCellClick:layout:)]){
        [self.delegate PWChatImageCellClick:self.indexPath layout:self.layout];
    }
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
