//
//  MineCellModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MineCellType) {
    MineCellTypeEncourage = 0,     //鼓励我们
    MineCellTypeInformation,       //我的消息
    MineCellTypeAboutPW,           //关于王教授
    MineCellTypeCollect,           //我的收藏
    MineCellTypeOpinion,           //意见与反馈
    MineCellTypeContactuUs,        //联系我们
    MineCellTypeSetting,           //设置
    MineCellTypeInfoSource         //云服务
};


@interface MineCellModel : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) MineCellType type;
@property (nonatomic, strong) NSString *describeText;
@property (nonatomic, strong) NSString *rightIcon;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isIssueSource;
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon cellType:(MineCellType)type;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title isSwitch:(BOOL)isOn;
- (instancetype)initWithTitle:(NSString *)title describeText:(NSString *)text;
- (instancetype)initWithTitle:(NSString *)title rightIcon:(NSString *)rightIcon;
@end

