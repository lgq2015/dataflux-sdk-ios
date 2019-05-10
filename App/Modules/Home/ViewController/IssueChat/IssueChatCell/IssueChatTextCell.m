//
//  IssueChatTextCell.m
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import "IssueChatTextCell.h"
#import "IssueLogModel.h"
@implementation IssueChatTextCell
-(void)initPWChatCellUserInterface{
    [super initPWChatCellUserInterface];
    
    self.mTextView = [UITextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.font = RegularFONT(17);
    self.mTextView.textColor = PWTextBlackColor;
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.mBackImgButton addSubview:self.mTextView];
}

-(void)setLayout:(IssueChatMessagelLayout *)layout{
    [super setLayout:layout];
    UIColor *color;
    if (layout.message.messageFrom ==PWChatMessageFromStaff) {
        color = [UIColor colorWithHexString:@"#CCE0FF"];
    }else{
        color = PWWhiteColor;
    }
    UIImage *image = [UIImage imageWithColor:color];
    image = [image resizableImageWithCapInsets:layout.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.mBackImgButton.frame = layout.backImgButtonRect;
    [self.mBackImgButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.mTextView.frame = self.layout.textLabRect;
    self.mTextView.attributedText = layout.message.textString;
    self.mIndicator.hidden = YES;
    self.retryBtn.hidden = YES;
    if (layout.message.isSend && !layout.message.sendError) {
        [self.mIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mBackImgButton);
            make.right.mas_equalTo(self.mBackImgButton.mas_left).offset(-5);
        }];
        self.mIndicator.hidden = NO;
        self.mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.mIndicator startAnimating];
    }else if(layout.message.isSend && layout.message.sendError){
        [self.retryBtn setImage:[UIImage imageNamed:@"send_error"] forState:UIControlStateNormal];
//        [_retryBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mBackImgButton);
            make.right.mas_equalTo(self.mBackImgButton.mas_left).offset(-5);
            make.width.height.offset(ZOOM_SCALE(30));
        }];
        self.retryBtn.hidden = NO;
    }
    self.atReadBtn.hidden = YES;
    if (layout.message.isHasAtStr) {
        NSString *arStr = [self atString];
        self.atReadBtn = [PWCommonCtrl buttonWithFrame:CGRectZero type:PWButtonTypeWord text:arStr];
        [self.atReadBtn setTitleColor:[UIColor colorWithHexString:@"#C7C7CC"] forState:UIControlStateDisabled];

        self.atReadBtn.titleLabel.font = RegularFONT(13);
        self.atReadBtn.hidden = NO;
        if([[arStr substringWithRange:NSMakeRange(arStr.length-2, 2)] isEqualToString:@"已读"]){
            self.atReadBtn.enabled = NO;
        }else{
            self.atReadBtn.enabled = YES;
        }
        [self.contentView addSubview:self.atReadBtn];
        [self.atReadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mBackImgButton);
            make.top.mas_equalTo(self.mBackImgButton.mas_bottom).offset(4);
            make.height.offset(ZOOM_SCALE(18));
        }];
        [self.atReadBtn addTarget:self action:@selector(readBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(NSString *)atString{
    __block NSString *atStr;
    NSDictionary *atStatus = [self.layout.message.model.atStatusStr jsonValueDecoded];
    NSArray *readAccounts = PWSafeArrayVal(atStatus, @"readAccounts");
    NSArray *unreadAccounts = PWSafeArrayVal(atStatus, @"unreadAccounts");
    NSDictionary *atInfoJSON = [self.layout.message.model.atInfoJSONStr jsonValueDecoded];
    NSDictionary *serviceMap = PWSafeDictionaryVal(atInfoJSON, @"serviceMap");
    NSDictionary *accountIdMap = PWSafeDictionaryVal(atInfoJSON, @"accountIdMap");
    if (unreadAccounts.count>0) {
        if (unreadAccounts.count == 1 ) {
            if (readAccounts.count>0) {
                atStr = [NSString stringWithFormat:@"%ld 人未读",unreadAccounts.count];
            }else{
                if (serviceMap == nil || serviceMap.allKeys.count ==0) {
                    NSDictionary *read = readAccounts[0];
                    [userManager getTeamMenberWithId:read[@"accountId"] memberBlock:^(NSDictionary *member) {
                        if (member.allKeys.count>0) {
                            atStr = [NSString stringWithFormat:@"%@未读",[member stringValueForKey:@"name" default:@""]];
                            
                        }
                    }];
                }else{
                    atStr = [NSString stringWithFormat:@"%ld 人未读",unreadAccounts.count];
                }
            }
        }else{
        atStr = [NSString stringWithFormat:@"%ld 人未读",unreadAccounts.count];
        }
    }else if(readAccounts.count == 0 && unreadAccounts.count == 0){
        if (serviceMap.allKeys.count>0) {
            NSArray *isps = [userManager getTeamISPs];
            NSDictionary *displayName = PWSafeDictionaryVal(isps[0], @"displayName");
            NSString *name = [displayName stringValueForKey:@"zh_CN" default:@"王教授"];
            if (self.layout.message.isSend || self.layout.message.model.sendError) {
                atStr = [NSString stringWithFormat:@"%@未读",name];
            }else{
                atStr = [NSString stringWithFormat:@"%@已读",name];
            }
        }
    }else{
        if (readAccounts.count>1 || (readAccounts.count == 1&& serviceMap&& serviceMap.allKeys.count>0)) {
            atStr = @"全部已读";
        }else{
            NSDictionary *read = readAccounts[0];
            [userManager getTeamMenberWithId:read[@"accountId"] memberBlock:^(NSDictionary *member) {
                    if (member.allKeys.count>0) {
                    atStr = [NSString stringWithFormat:@"%@已读",[member stringValueForKey:@"name" default:@""]];
                
            }
            }];
        }
    }
//    if (unreadAccounts.count>0) {
//        if(unreadAccounts.count == 1 && readAccounts.count == 0 && (atInfoJSON == nil || atInfoJSON.allKeys.count == 1)){
//            NSDictionary *unread = unreadAccounts[0];
//            [userManager getTeamMenberWithId:unread[unread.allKeys[0]] memberBlock:^(NSDictionary *member) {
//                if (member.allKeys.count>0) {
//                    atStr = [NSString stringWithFormat:@"%@未读",[member stringValueForKey:@"name" default:@""]];
//                }
//            }];
//
//        }else{
//            atStr = [NSString stringWithFormat:@"%ld 人未读",unreadAccounts.count];
//        }
//    }
//    if ((unreadAccounts.count == 0 && readAccounts.count>0 )||(readAccounts.count == 1 && atInfoJSON.allKeys.count == 2)) {
//        if (readAccounts.count > 1) {
//            atStr = @"全部已读";
//        }else{
//            NSDictionary *read = readAccounts[0];
//            atStr = [NSString stringWithFormat:@"%@已读",read[read.allKeys[0]]];
//            [userManager getTeamMenberWithId:read[@"accountId"] memberBlock:^(NSDictionary *member) {
//                if (member.allKeys.count>0) {
//                    atStr = [NSString stringWithFormat:@"%@已读",[member stringValueForKey:@"name" default:@""]];
//
//                }
//            }];
//        }
//    }
//    if (unreadAccounts.count == 0 && readAccounts.count == 0) {
//
//
//        if(accountIdMap.allKeys.count>0){
//            atStr = [NSString stringWithFormat:@"%ld 人未读",accountIdMap.allKeys.count];
//        }else if(serviceMap.allKeys.count>0){
//            NSArray *isps = [userManager getTeamISPs];
//            NSDictionary *displayName = PWSafeDictionaryVal(isps[0], @"displayName");
//            NSString *name = [displayName stringValueForKey:@"zh_CN" default:@"王教授"];
//            if (self.layout.message.isSend) {
//                atStr = [NSString stringWithFormat:@"%@未读",name];
//            }else{
//                atStr = [NSString stringWithFormat:@"%@已读",name];
//            }
//        }
//
//    }
    return atStr;
}
- (void)readBtnClick{
  
        if(self.delegate && [self.delegate respondsToSelector:@selector(PWChatReadUnreadBtnClickLayout:)]){
            [self.delegate PWChatReadUnreadBtnClickLayout:self.layout];
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
