//
//  PWDraggableModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"
/*
 "bucketPath": "test-path1",
 "category": "column",
 "coverImageMobile": "",
 "coverImageWeb": "",
 "id": "hdbk-efsqjDtRRGpPoTGGvjNo68",
 "name": "手册1",
 "orderNum": 1
 */
@interface PWDraggableModel : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *coverImageMobile;
@property (nonatomic, assign) NSInteger orderNum;
@property (nonatomic, strong) NSString *handbookId;
@property (nonatomic, strong) NSString *bucketPath;
@end
