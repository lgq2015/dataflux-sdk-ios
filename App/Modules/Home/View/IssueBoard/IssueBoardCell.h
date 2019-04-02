//
//  IssueBoardCell.h
//  IssueBoard
//
//  Created by 胡蕾蕾 on 2018/8/16.
//  Copyright © 2018年 hll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueBoardModel.h"


@interface IssueBoardCell : UICollectionViewCell
@property (nonatomic, strong) IssueBoardModel *model;
@property (nonatomic,assign) BOOL isShow;
-(void)pop;
-(void)bump;
@end
