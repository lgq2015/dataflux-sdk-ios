//
//  ZTChangeTeamNavView.h
//  123
//
//  Created by tao on 2019/5/1.
//  Copyright © 2019 shitu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTChangeTeamNavView : UIView
@property (nonatomic, strong)UIButton*navViewLeftBtn;
@property (nonatomic, strong)UIImageView *navViewImageView;
- (instancetype)initWithTitle:(NSString *)titleString font:(UIFont *)font;
- (void)changeTitle:(NSString *)string;
- (CGRect)getChangeTeamNavViewFrame:(BOOL)isSwitch;
@end

NS_ASSUME_NONNULL_END
