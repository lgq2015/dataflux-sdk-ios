//
//  IssueSourceDetailVC.h
//  App
//
//  Created by 胡蕾蕾 on 2019/1/17.
//  Copyright © 2019 hll. All rights reserved.
//

#import "RootViewController.h"
#import "IssueSourceConfige.h"


@interface IssueSourceDetailVC : RootViewController
@property (nonatomic, assign) SourceType type;
@property (nonatomic, strong) IssueSourceViewModel *model;
@property (nonatomic, assign) BOOL isDefault; // 下面提示是否显示
@property (nonatomic, assign) BOOL isAdd;  //添加还是 查看详情
@property (nonatomic, copy) void(^RefreshClick)(void);
@end


