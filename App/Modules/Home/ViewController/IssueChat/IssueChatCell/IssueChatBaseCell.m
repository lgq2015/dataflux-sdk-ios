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
    self.contentView.backgroundColor = PWWhiteColor;
    // 1、创建姓名
    _mNameLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(13) textColor:PWSubTitleColor text:@""];
    [self.contentView addSubview:_mNameLab];
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mHeaderImgBtn.backgroundColor =  PWWhiteColor;
    _mHeaderImgBtn.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_mHeaderImgBtn];
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(iconPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    _adminLab = [PWCommonCtrl lableWithFrame:CGRectZero font:RegularFONT(10) textColor:PWWhiteColor text:NSLocalizedString(@"local.owner", @"")];
    _adminLab.backgroundColor = [UIColor colorWithHexString:@"#F97B00"];
    _adminLab.textAlignment = NSTextAlignmentCenter;
    _adminLab.layer.cornerRadius = 2.0f;
    _adminLab.layer.masksToBounds = YES;
    [self.contentView addSubview:_adminLab];
    [_adminLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mHeaderImgBtn).offset(ZOOM_SCALE(31));
        make.centerX.mas_equalTo(_mHeaderImgBtn);
        make.width.offset(ZOOM_SCALE(40));
        make.height.offset(ZOOM_SCALE(14));
    }];
    //背景按钮
    _mBackImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mBackImgButton.backgroundColor =  [PWChatCellColor colorWithAlphaComponent:0.4];
    _mBackImgButton.tag = 50;
    _mBackImgButton.layer.cornerRadius = 4;
    _mBackImgButton.layer.masksToBounds = YES;
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
    self.adminLab.hidden = !layout.message.isManger;
    
    self.adminLab.text = layout.message.isAdmin?NSLocalizedString(@"local.owner", @""):NSLocalizedString(@"local.TeamAdministrator", @"");
        self.adminLab.backgroundColor = layout.message.isAdmin?[UIColor colorWithHexString:@"#F97B00"]:PWBlueColor;
    [self.mHeaderImgBtn sd_setImageWithURL:[NSURL URLWithString:layout.message.headerImgurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"team_memicon"]];
    self.mHeaderImgBtn.layer.cornerRadius = self.mHeaderImgBtn.height*0.5;
        _mExpertLab.hidden = YES;
        if (layout.message.messageFrom == PWChatMessageFromStaff) {
            [self.mHeaderImgBtn sd_setImageWithURL:[NSURL URLWithString:layout.message.headerImgurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"professor_wang_header"]];

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
//    if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatRetryClick:layout:)]){
//        [self.delegate PWChatRetryClick:self.indexPath layout:self.layout];
//    }
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
