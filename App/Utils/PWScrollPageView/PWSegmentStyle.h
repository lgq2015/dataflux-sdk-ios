//
//  PWSegmentStyle.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/16.
//  Copyright © 2018 hll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWSegmentStyle : NSObject
@property (assign, nonatomic) CGRect extraBtnFrame;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 默认为14 */
@property (strong, nonatomic) UIFont *titleFont;
/** 选中标题的字体 默认为14 */
@property (strong, nonatomic) UIFont *selectTitleFont;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** segmentVIew的高度*/
@property (assign, nonatomic) CGFloat segmentHeight;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

@property (nonatomic, assign) CGFloat extraBtnMarginTitle;
/** 是否显示附加的按钮 默认为NO*/
@property (assign, nonatomic, getter=isShowExtraButton) BOOL showExtraButton;
/** 设置附加按钮的背景图片 默认为nil*/
@property (strong, nonatomic) NSString *extraBtnBackgroundImageName;
@end
