//
//  ZTPlaceHolderTextView.h
//  123
//
//  Created by tao on 2019/5/13.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZTPlaceHolderTextView;
@protocol ZTPlaceHolderTextViewDelegate <NSObject>

- (void)textViewHeigthChange:(ZTPlaceHolderTextView *_Nullable)view;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ZTPlaceHolderTextView : UITextView
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, weak)id<ZTPlaceHolderTextViewDelegate>zt_delegate;
@property (nonatomic, copy)NSString *oldCommentData;
@end

NS_ASSUME_NONNULL_END
