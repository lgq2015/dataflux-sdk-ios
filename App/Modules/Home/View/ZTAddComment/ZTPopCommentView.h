//
//  ZTPopCommentView.h
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputHeaderView.h"
@protocol IssueKeyBoardDelegate <NSObject>
- (void)IssueKeyBoardInputViewChooeseImageClick;
- (void)IssueKeyBoardInputViewChooeseiCloudFileClick;
- (void)IssueKeyBoardInputViewSendText:(NSString *_Nullable)text;
- (void)IssueKeyBoardInputViewSendAtText:(NSString *_Nullable)text atInfoJSON:(NSDictionary *_Nonnull)atInfoJSON;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ZTPopCommentView : UIView
@property (nonatomic, strong) NSString *oldData;
@property (nonatomic, assign) IssueDealState state;
@property (nonatomic, assign) id<IssueKeyBoardDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame WithController:(UIViewController *)controller;
- (void)show;
@end

NS_ASSUME_NONNULL_END
