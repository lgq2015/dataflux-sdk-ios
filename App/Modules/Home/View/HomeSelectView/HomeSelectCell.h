//
//  HomeSelectCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/5/13.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SelectType){
    SelectTypeIssue, //全部类别
    SelectTypeView,  //标准视图
    SelectTypeIssueChat, //聊天里的选择
};
@interface HomeSelectCell : UITableViewCell
@property (nonatomic, assign) SelectType type;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, copy)   void(^changeChatStateClick)();
@end

NS_ASSUME_NONNULL_END
