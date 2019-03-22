//
//  PWChatBaseCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/3/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWChatMessagelLayout.h"

@protocol PWChatBaseCellDelegate <NSObject>
//点击头像
-(void)PWChatHeaderImgCellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

//点击文本cell
-(void)PWChatTextCellClick:(NSIndexPath*)indexPath index:(NSInteger)index layout:(PWChatMessagelLayout *)layout;
NS_ASSUME_NONNULL_BEGIN

@end
@interface PWChatBaseCell : UITableViewCell
@property(nonatomic,assign)id<PWChatBaseCellDelegate> delegate;
@property(nonatomic, strong) PWChatMessagelLayout  *layout;

@property(nonatomic, strong) NSIndexPath           *indexPath;
//文本消息
@property(nonatomic, strong) UITextView     *mTextView;

//图片消息
@property(nonatomic,strong) UIImageView *mImgView;

@end

NS_ASSUME_NONNULL_END
