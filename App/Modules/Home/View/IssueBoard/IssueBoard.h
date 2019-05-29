//
//  IssueBoard.h
//  IssueBoard
//
//  Created by 胡蕾蕾 on 2018/9/3.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueBoardCell.h"

typedef NS_ENUM(NSInteger, PWIssueBoardStyle) {
    PWIssueBoardStyleNotConnected = 0,       //未添加账号
    PWIssueBoardStyleConnected = 1,         //连接后
};
@protocol PWIssueBoardDelegate <NSObject>
@end
@interface IssueBoard : UIView
@property (nonatomic, copy) void(^connectClick)(void);
@property (nonatomic, copy) void(^historyInfoClick)(void);
@property (nonatomic, copy) void(^itemClick)(NSInteger index);

/** 初始化InfoBoard视图的frame与style*/
-(instancetype)initWithStyle:(PWIssueBoardStyle)style;

/** 创建InfoBoard视图*/
- (void)createUIWithParamsDict:(NSDictionary *)paramsDict;

/** 更改InfoBoard的style*/
- (void)updataInfoBoardStyle:(PWIssueBoardStyle)style itemData:(NSDictionary *)paramsDict;

/** 界面刷新*/
- (void)updataDatas:(NSDictionary *)paramsDict;

/** item刷新*/
- (void)updateItem:(NSDictionary *)paramsDict;

/** InfoBoard模块title更新*/
- (void)updateTitle:(NSString *)title;

@end
