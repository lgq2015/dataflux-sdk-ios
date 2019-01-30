//
//  PWInfoBoardCell.h
//  PWInfoBoard
//
//  Created by 胡蕾蕾 on 2018/8/16.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBoardModel.h"


@interface PWInfoBoardCell : UICollectionViewCell
@property (nonatomic, strong) InfoBoardModel *model;
-(void)pop;
-(void)bump;
@end
