//
//  MineCellModel.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/3.
//  Copyright © 2019 hll. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MineCellType) {
    MineCellTypeCompany = 0,       //我的企业
    MineCellTypeAliyun = 1,        //阿里云账号管理
    MineCellTypeCollect,           //我的收藏
    MineCellTypeOpinion,           //意见与反馈
    MineCellTypeContactuUs,        //联系我们
    MineCellTypeSetting,           //设置
};


@interface MineCellModel : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) MineCellType type;
@property (nonatomic, assign) BOOL isOn;
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon cellType:(MineCellType)type;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title switch:(BOOL)isOn;

@end

