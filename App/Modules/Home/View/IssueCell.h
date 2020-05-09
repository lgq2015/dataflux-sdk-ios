//
//  IssueCell.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/14.
//  Copyright © 2019 hll. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IssueListViewModel,SelectObject;
@interface IssueCell : UITableViewCell
@property (nonatomic, strong) IssueListViewModel *model;
@property (nonatomic, strong) SelectObject *selObj;
@end

