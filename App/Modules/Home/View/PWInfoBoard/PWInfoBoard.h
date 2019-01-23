//
//  PWInfoBoard.h
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/9/3.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PWInfoBoardStyle) {
    PWInfoBoardStyleNotConnected = 0,       //未添加账号
    PWInfoBoardStyleConnected = 1,         //连接后
};
@interface PWInfoBoard : UIView
@property (nonatomic, copy) void(^connectClick)(void);
@property (nonatomic, copy) void(^historyInfoClick)(void);
@property (nonatomic, copy) void(^itemClick)(NSInteger index);

/** 初始化InfoBoard视图的frame与style*/
-(instancetype)initWithFrame:(CGRect)frame style:(PWInfoBoardStyle)style;

/** 创建InfoBoard视图*/
- (void)createUIWithParamsDict:(NSDictionary *)paramsDict;

/** 更改InfoBoard的style*/
- (void)updataInfoBoardStyle:(PWInfoBoardStyle)style itemData:(NSDictionary *)paramsDict;

/** 界面刷新*/
- (void)updataDatas:(NSDictionary *)paramsDict;

/** item刷新*/
- (void)updateItem:(NSDictionary *)paramsDict;

/** InfoBoard模块title更新*/
- (void)updateTitle:(NSString *)title;
@end
