//
//  PWDraggableModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/6.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"

@interface PWDraggableModel : JSONModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger index;
@end
