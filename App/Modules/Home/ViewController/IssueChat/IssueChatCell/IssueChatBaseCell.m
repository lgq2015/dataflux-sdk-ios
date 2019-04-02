//
//  IssueChatBaseCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatBaseCell.h"

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
        self.backgroundColor = PWChatCellColor;
        self.contentView.backgroundColor = PWChatCellColor;
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
    [self.contentView addSubview:_mBackImgButton];
    [_mBackImgButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    }
}

- (void)iconPressed{
    
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
