//
//  IssueChatBaseCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueChatMessagelLayout.h"

@protocol PWChatBaseCellDelegate <NSObject>
//点击头像
-(void)PWChatHeaderImgCellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

//点击文本cell
-(void)PWChatTextCellClick:(NSIndexPath*)indexPath index:(NSInteger)index layout:(IssueChatMessagelLayout *)layout;

//点击cell图片和短视频
-(void)PWChatImageCellClick:(NSIndexPath *)indexPath layout:(IssueChatMessagelLayout *)layout; 
NS_ASSUME_NONNULL_BEGIN

@end
@interface IssueChatBaseCell : UITableViewCell
-(void)initPWChatCellUserInterface;
-(void)showIndicator;

@property(nonatomic,assign)id<PWChatBaseCellDelegate> delegate;
@property(nonatomic, strong) IssueChatMessagelLayout  *layout;

//头像  姓名  背景按钮
@property(nonatomic, strong) UIButton  *mHeaderImgBtn;
@property(nonatomic, strong) UILabel   *mNameLab;
@property(nonatomic, strong) UIButton  *mBackImgButton;
@property(nonatomic, strong) UILabel   *mExpertLab;

@property(nonatomic, strong) NSIndexPath         *indexPath;
//文本消息
@property(nonatomic, strong) UITextView     *mTextView;

//图片消息
@property(nonatomic,strong) UIImageView *mImgView;

//文件信息
@property (nonatomic, strong) UIView *mFileView;
//系统消息
@property (nonatomic, strong) UILabel *mSystermLab;
//发消息的菊花转
@property (nonatomic, strong) UIActivityIndicatorView *mIndicator;

@end

NS_ASSUME_NONNULL_END
