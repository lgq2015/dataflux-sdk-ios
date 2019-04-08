//
//  WebItemView.h
//  App
//
//  Created by 胡蕾蕾 on 2019/2/22.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WebItemViewStyle){
    WebItemViewStyleNormal,      //有分享 有收藏   手册话题广场  未收藏
    WebItemViewStyleNoCollect,   //置顶 不能收藏
    WebItemViewStyleCollected,   //有分享 有收藏   已收藏
};
#define CollectionBtnTag 199
#define ShareBtnTag 198
NS_ASSUME_NONNULL_BEGIN

@interface WebItemView : UIView
@property (nonatomic, copy) void(^itemClick)(NSInteger tag);
-(instancetype)initWithStyle:(WebItemViewStyle)style;
- (void)showInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
