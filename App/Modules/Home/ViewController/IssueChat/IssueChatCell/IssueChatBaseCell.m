//
//  IssueChatBaseCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatBaseCell.h"
#import "IssueChatMessagelLayout.h"
@implementation IssueChatBaseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = PWBackgroundColor;
        self.contentView.backgroundColor = PWBackgroundColor;
        [self initPWChatCellUserInterface];
    }
    return self;
}
-(void)initPWChatCellUserInterface{
    // 1、创建姓名
    _mNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWSubTitleColor text:@""];
    [self.contentView addSubview:_mNameLab];
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mHeaderImgBtn.backgroundColor =  [UIColor brownColor];
    _mHeaderImgBtn.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_mHeaderImgBtn];
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(iconPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    //背景按钮
    _mBackImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mBackImgButton.backgroundColor =  [PWChatCellColor colorWithAlphaComponent:0.4];
    _mBackImgButton.tag = 50;
    _mBackImgButton.layer.cornerRadius = 4;
    _mBackImgButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_mBackImgButton];
    [_mBackImgButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //菊花转
    _mIndicator = [UIActivityIndicatorView new];
    [self.contentView addSubview:_mIndicator];
    _sendLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWTextColor text:@"上传中…"];
    _sendLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_sendLab];
    _retryBtn = [[UIButton alloc]init];
    _retryBtn.titleLabel.font = RegularFONT(12);
    _retryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    [_retryBtn setTitleColor:PWBlueColor forState:UIControlStateNormal];
    [_retryBtn addTarget:self action:@selector(retryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_retryBtn];
    
}
-(void)setLayout:(IssueChatMessagelLayout *)layout{
    _layout = layout;
    
    if (layout.message.messageFrom == PWChatMessageFromSystem) {
      
        
    }else{

    self.mNameLab.text = layout.message.nameStr;
    self.mNameLab.frame = layout.nameLabRect;
    self.mHeaderImgBtn.frame = layout.headerImgRect;
    [self.mHeaderImgBtn sd_setImageWithURL:[NSURL URLWithString:layout.message.headerImgurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    self.mHeaderImgBtn.layer.cornerRadius = self.mHeaderImgBtn.height*0.5;
        _mExpertLab.hidden = YES;
        if (layout.message.messageFrom == PWChatMessageFromStaff) {
            [self.mHeaderImgBtn sd_setImageWithURL:[NSURL URLWithString:layout.message.headerImgurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"expert_defaulticon"]];

            self.mExpertLab =[PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(12) textColor:PWBlueColor text:layout.message.stuffName];
            [self.contentView addSubview:_mExpertLab];
            [self.mExpertLab sizeToFit];
            self.mExpertLab.backgroundColor = RGBACOLOR(209, 225, 255, 1);
            self.mExpertLab.layer.cornerRadius = 2;
            self.mExpertLab.layer.masksToBounds = YES;
            self.mExpertLab.textAlignment = NSTextAlignmentCenter;
            self.mExpertLab.frame = layout.expertLabRect;
    
            _mExpertLab.hidden = NO;

        }
    }
}
- (void)retryBtnClick{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatRetryClick:layout:)]){
        [self.delegate PWChatRetryClick:self.indexPath layout:self.layout];
    }
}
- (void)iconPressed{
    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatHeaderImgCellClick:layout:)]){
        [self.delegate PWChatHeaderImgCellClick:self.indexPath layout:self.layout];
    }
}
- (void)buttonPressed:(UIButton *)button{
   
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
