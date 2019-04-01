//
//  GridViewModel.h
//  App
//
//  Created by 胡蕾蕾 on 2018/12/11.
//  Copyright © 2018年 hll. All rights reserved.
//

#import "JSONModel.h"

@interface GridViewModel : JSONModel
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) NSString *image;
@end
