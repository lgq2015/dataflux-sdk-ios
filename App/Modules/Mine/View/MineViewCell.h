//
//  MainViewCell.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/25.
//  Copyright © 2018 hll. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MineVCCellType) {
    MineVCCellTypeBase = 0,        //有icon,有title
    MineVCCellTypeTitle = 1,       //只有title
    MineVCCellTypeSwitch,          //有title,有switch按钮
    MineVCCellTypeButton,          //类似按钮
};

@class MineCellModel;
@interface MineViewCell : UITableViewCell
@property (nonatomic, strong) MineCellModel *data;
@property (nonatomic, strong) UISwitch *switchBtn;

-(void)initWithData:(MineCellModel *)data type:(MineVCCellType)type;
@end
