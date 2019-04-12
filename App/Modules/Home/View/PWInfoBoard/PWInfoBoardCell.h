//
//  PWInfoBoardCell.h
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/16.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PWInfoBoardItemState) {
    PWInfoBoardItemStateDisable = -1,       //不可用
    PWInfoBoardItemStateNormal = 0,         //normal
    PWInfoBoardItemStateRecommend,          //推荐
    PWInfoBoardItemStateWarning,            //警告
    PWInfoBoardItemStateSeriousness,        //严重
};

@interface PWInfoBoardCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *datas;
-(void)pop;
-(void)bump;
@end
